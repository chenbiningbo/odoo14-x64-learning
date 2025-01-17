odoo.define('mail.Chatter', function (require) {
"use strict";

var Activity = require('mail.Activity');
var AttachmentBox = require('mail.AttachmentBox');
var ChatterComposer = require('mail.composer.Chatter');
var Dialog = require('web.Dialog');
var Followers = require('mail.Followers');
var ThreadField = require('mail.ThreadField');
var mailUtils = require('mail.utils');

var concurrency = require('web.concurrency');
var config = require('web.config');
var core = require('web.core');
var Widget = require('web.Widget');

var _t = core._t;
var QWeb = core.qweb;

// The purpose of this widget is to display the chatter area below the form view
//
// It instantiates the optional mail_thread, mail_activity and mail_followers widgets.
// It Ensures that those widgets are appended at the right place, and allows them to communicate
// with each other.
// It synchronizes the rendering of those widgets (as they may be asynchronous), to mitigate
// the flickering when switching between records
var Chatter = Widget.extend({
    template: 'mail.Chatter',
    custom_events: {
        delete_attachment: '_onDeleteAttachment',
        discard_record_changes: '_onDiscardRecordChanges',
        reload_attachment_box: '_onReloadAttachmentBox',
        reload_mail_fields: '_onReloadMailFields',
        reset_suggested_partners: '_onResetSuggestedPartners',
    },
    events: {
        'click .o_chatter_button_new_message': '_onOpenComposerMessage',
        'click .o_chatter_button_log_note': '_onOpenComposerNote',
        'click .o_chatter_button_attachment': '_onClickAttachmentButton',
        'click .o_chatter_button_schedule_activity': '_onScheduleActivity',
    },
    supportedFieldTypes: ['one2many'],

    /**
     * @override
     * @param {widget} parent
     * @param {Object} record
     * @param {Object} mailFields
     * @param {string} [mailFields.mail_activity]
     * @param {string} [mailFields.mail_followers]
     * @param {string} [mailFields.mail_thread]
     * @param {Object} options
     * @param {string} [options.viewType=record.viewType] current viewType in
     *   which the chatter is instantiated
     */
    init: function (parent, record, mailFields, options) {
        this._super.apply(this, arguments);
        this._setState(record);

        this.attachments = {};
        this.fields = {};
        this._areAttachmentsLoaded = false;
        this._disableAttachmentBox = !!options.disable_attachment_box;
        this._dp = new concurrency.DropPrevious();
        this._isAttachmentBoxOpen = false;
        this._isComposerOpen = false;
        // mention: get the prefetched partners and use them as mention suggestions
        // if there is a follower widget, the followers will be added to the
        // suggestions as well once fetched
        this._mentionPartnerSuggestions = this.call('mail_service', 'getMentionPartnerSuggestions');
        this._mentionSuggestions = this._mentionPartnerSuggestions;
        /**
         * List of fetched suggested partners. This is lazy-loaded on opening
         * composer. `undefined` means it should be fetched again.
         */
        this._suggestedPartners = undefined;

        if (mailFields.mail_activity) {
            this.fields.activity = new Activity(this, mailFields.mail_activity, record, options);
        }
        if (mailFields.mail_followers) {
            this.fields.followers = new Followers(this, mailFields.mail_followers, record, options);
        }
        if (mailFields.mail_thread) {
            this.fields.thread = new ThreadField(this, mailFields.mail_thread, record, options);
            var fieldsInfo = record.fieldsInfo[options.viewType || record.viewType];
            var nodeOptions = fieldsInfo[mailFields.mail_thread].options || {};
            this.hasLogButton = options.display_log_button || nodeOptions.display_log_button;
            this.postRefresh = nodeOptions.post_refresh || 'never';
            this.reloadOnUploadAttachment = this.postRefresh === 'always';
            this.openAttachments = nodeOptions.open_attachments || false;
        }
    },
    /**
     * @override
     */
    start: function () {
        this._$topbar = this.$('.o_chatter_topbar');
        // render and append the buttons
        this._$topbar.prepend(this._renderButtons());
        // start and append the widgets
        var fieldDefs = _.invoke(this.fields, 'appendTo', $('<div>'));
        var def = this._dp.add(Promise.all(fieldDefs));
        this._render(def)
            .then(this._updateMentionSuggestions.bind(this))
            .then(() => {
                if (this.openAttachments) {
                    this._openAttachmentBox();
                }
            });

        return this._super.apply(this, arguments);
    },

    //--------------------------------------------------------------------------
    // Public
    //--------------------------------------------------------------------------

    /**
     * @param {Object} record
     * @param {integer} [record.res_id=undefined]
     * @param {Object[]} [fieldNames=undefined]
     */
    update: function (record, fieldNames) {
        var self = this;

        // close the composer if we switch to another record as it is record dependent
        if (this.record.res_id !== record.res_id) {
            this._closeComposer(true);
            this._closeAttachments();
            this._areAttachmentsLoaded = false;
            this.attachments = {};
        }

        // update the state
        this._setState(record);

        // detach the thread and activity widgets (temporarily force the height to prevent flickering)
        // keep the followers in the DOM as it has a synchronous pre-rendering
        this.$el.height(this.$el.height());
        if (this.fields.activity) {
            this.fields.activity.$el.detach();
        }
        if (this.fields.thread && this.fields.thread.$el ) {
            this.fields.thread.$el.detach();
        }

        // reset and re-append the widgets (and reset 'height: auto' rule)
        // if fieldNames is given, only reset those fields, otherwise reset all fields
        var fieldsToReset;
        if (fieldNames) {
            fieldsToReset = _.filter(this.fields, function (field) {
                return _.contains(fieldNames, field.name);
            });
        } else {
            fieldsToReset = this.fields;
        }
        var fieldDefs = _.invoke(fieldsToReset, 'reset', record);
        var def = this._dp.add(Promise.all(fieldDefs));
        this._render(def).then(function () {
            self.$el.height('auto');
            self._updateMentionSuggestions();
        });
        this._updateAttachmentCounter();
    },
    async updateSuggestedPartners() {
        this._suggestedPartners = undefined;
        if (this._composer && this._isComposerOpen) {
            const suggestedPartners = await this._getSuggestedPartners();
            this._composer.updateSuggestedPartners(suggestedPartners);
        }
    },

    //--------------------------------------------------------------------------
    // Private
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    _closeAttachments: function () {
        if (this.fields.attachments) {
            this.$('.o_chatter_button_attachment').removeClass('o_active_attach');
            this.fields.attachments.destroy();
            this._isAttachmentBoxOpen = false;
        }
    },
    /**
     * @private
     * @param {boolean} force
     */
    _closeComposer: function (force) {
        if (this._composer && (this._composer.isEmpty() || force)) {
            this.$el.removeClass('o_chatter_composer_active');
            this.$('.o_chatter_button_new_message, .o_chatter_button_log_note').removeClass('o_active');
            this._composer.do_hide();
            this._composer.clearComposer();
            this._isComposerOpen = false;
        }
    },
    /**
     * @private
     */
    _disableChatter: function () {
        this.$('.btn').prop('disabled', true); // disable buttons
    },
    /**
     * @private
     */
    _disableComposer: function () {
        this.$(".o_composer_button_send").prop('disabled', true);
    },
    /**
     * Discard changes on the record.
     *
     * @private
     * @returns {Promise} resolved if successfully discarding changes on
     *   the record, rejected otherwise
     */
    _discardChanges: function () {
        var self = this;
        return new Promise(function (resolve, reject) {
            self.trigger_up('discard_changes', {
                recordID: self.record.id,
                onSuccess: resolve,
                onFailure: reject,
            });
        });
    },
    /**
     * Discard changes on the record if the message will reload the record
     * after posting it
     *
     * @private
     * @param {Object} messageData
     * @return {Promise} resolved if no reload or proceed to discard the
     *   changes on the record, rejected otherwise
     */
    _discardOnReload: function (messageData) {
        if (this._reloadAfterPost(messageData)) {
            return this._discardChanges();
        }
        return Promise.resolve();
    },
    /**
     * @private
     */
    _enableChatter: function () {
        this.$('.btn').prop('disabled', false); // enable buttons
    },
    /**
     * @private
     */
    _enableComposer: function () {
        this.$(".o_composer_button_send").prop('disabled', false);
    },
    /*
    * @private
    * @return {Deferred}
    */
    _fetchAttachments: function () {
        var self = this;
        var domain = [
            ['res_id', '=', this.record.res_id],
            ['res_model', '=', this.record.model],
        ];
        return this._rpc({
            model: 'ir.attachment',
            method: 'search_read',
            domain: domain,
            fields: ['id', 'name', 'mimetype'],
        }).then(function (result) {
            self._areAttachmentsLoaded = true;
            self.attachments = result;
        });

    },
    /**
     * @private
     */
    async _getSuggestedPartners() {
        if (this._suggestedPartners) {
            return this._suggestedPartners;
        }
        const result = await this._rpc({
            route: '/mail/get_suggested_recipients',
            params: {
                model: this.record.model,
                res_ids: [this.context.default_res_id],
            },
        });
        const suggestedPartners = [];
        const threadRecipients = result[this.context.default_res_id] || [];
        for (const recipient of threadRecipients) {
            const parsedEmail = recipient[1] && mailUtils.parseEmail(recipient[1]);
            suggestedPartners.push({
                checked: true,
                partner_id: recipient[0],
                full_name: recipient[1],
                name: parsedEmail[0],
                email_address: parsedEmail[1],
                reason: recipient[2],
            });
        }
        this._suggestedPartners = suggestedPartners;
        return this._suggestedPartners;
    },
    /**
     * @private
     */
    _openAttachmentBox: function () {
        if (this.fields.attachments) {
            this._closeAttachments();
        }
        this.fields.attachments = new AttachmentBox(this, this.record, this.attachments);
        var $anchor = this.$('.o_chatter_topbar');
        if (this._composer) {
            var $anchor = this.$('.o_thread_composer');
        } else {
            var $anchor = this.$('.o_chatter_topbar');
        }
        this.fields.attachments.insertAfter($anchor);
        this.$('.o_chatter_button_attachment').addClass('o_active_attach');

        this._isAttachmentBoxOpen = true;
    },
    /**
     * @private
     * @param {Object} options
     * @param {Object[]} [options.suggestedPartners=[]]
     * @param {boolean} [options.isLog]
     */
    _openComposer: function (options) {
        var self = this;
        var oldComposer = this._composer;
        // create the new composer
        this._composer = new ChatterComposer(this, this.record.model, options.suggestedPartners || [], {
            commandsEnabled: false,
            context: this.context,
            inputMinHeight: 50,
            isLog: options && options.isLog,
            recordName: this.recordName,
            defaultBody: oldComposer && oldComposer.$input && oldComposer.$input.val(),
            defaultMentionSelections: oldComposer && oldComposer.getMentionListenerSelections(),
            attachmentIds: (oldComposer && oldComposer.get('attachment_ids')) || [],
        });
        this._composer.on('input_focused', this, function () {
            this._composer.mentionSetPrefetchedPartners(this._mentionSuggestions || []);
        });
        this._composer.insertAfter(this.$('.o_chatter_topbar')).then(function () {
            // destroy existing composer
            if (oldComposer) {
                oldComposer.destroy();
            }
            self._composer.focus();
            self._composer.on('post_message', self, function (messageData) {
                self._discardOnReload(messageData).then(function () {
                    self._disableComposer();
                    self.fields.thread.postMessage(messageData).then(function () {
                        self._closeComposer(true);
                        if (self._reloadAfterPost(messageData)) {
                            self.trigger_up('reload');
                        } else if (messageData.attachment_ids.length) {
                            self._reloadAttachmentBox();
                            self.trigger_up('reload', {fieldNames: ['message_attachment_count'], keepChanges: true});
                        }
                    }).guardedCatch(function () {
                        self._enableComposer();
                    });
                });
            });
            self._composer.on('need_refresh', self, self.trigger_up.bind(self, 'reload'));
            self._composer.on('close_composer', null, self._closeComposer.bind(self, true));

            self._isComposerOpen = true;
            self.$el.addClass('o_chatter_composer_active');
            self.$('.o_chatter_button_new_message, .o_chatter_button_log_note').removeClass('o_active');
            self.$('.o_chatter_button_new_message').toggleClass('o_active', !self._composer.options.isLog);
            self.$('.o_chatter_button_log_note').toggleClass('o_active', self._composer.options.isLog);
        });
    },
    /**
     * State if the record will be reloaded after posting a message.
     * Useful to warn the user of unsaved changes if the record is dirty.
     *
     * @private
     * @param {Object} messageData
     * @param {Array} [messageData.partner_ids] list of recipients of a message
     * @return {boolean} true if record will be reloaded after posting the
     *   message, false otherwise
     */
    _reloadAfterPost: function (messageData) {
        return this.postRefresh === 'always' ||
                (
                   this.postRefresh === 'recipients' &&
                   messageData.partner_ids &&
                   messageData.partner_ids.length
                );
    },
    /**
     * @private
     */
    _reloadAttachmentBox: function () {
        this._areAttachmentsLoaded = false;
        if (this._isAttachmentBoxOpen) {
            this._fetchAttachments().then(this._openAttachmentBox.bind(this));
        }
        if (!this._disableAttachmentBox) {
            this.trigger_up('reload', { fieldNames: ['message_attachment_count'], keepChanges: true });
        }
    },
    /**
     * @private
     * @param {Deferred} def
     * @returns {Deferred}
     */
    _render: function (def) {
        // the rendering of the chatter is aynchronous: relational data of its fields needs to be
        // fetched (in some case, it might be synchronous as they hold an internal cache).
        // this function takes a promise as argument, which is resolved once all fields have
        // fetched their data
        // this function appends the fields where they should be once the given promise is resolved
        // and if it takes more than 500ms, displays a spinner to indicate that it is loading
        var self = this;

        var $spinner = $(QWeb.render('Spinner'));
        concurrency.rejectAfter(concurrency.delay(500), def).then(function () {
            $spinner.appendTo(self.$el);
        });
        var always = function () {
            // disable widgets in create mode, otherwise enable
            self._isCreateMode ? self._disableChatter() : self._enableChatter();
            $spinner.remove();
        };

        return def.then(function () {
            if (self.fields.activity) {
                self.fields.activity.$el.appendTo(self.$el);
            }
            if (self.fields.followers) {
                if (self._disableAttachmentBox) {
                    self.fields.followers.$el.appendTo(self.$('.o_topbar_right_area'));
                } else {
                    self.fields.followers.$el.insertBefore(self.$('.o_chatter_button_attachment'));
                }
            }
            if (self.fields.thread && self.fields.thread.$el) {
                self.fields.thread.$el.appendTo(self.$el);
            }
        }).then(always).guardedCatch(always);
    },
    _renderButtons: function () {
        return QWeb.render('mail.chatter.Buttons', {
            newMessageButton: !!this.fields.thread,
            logNoteButton: this.hasLogButton,
            scheduleActivityButton: !!this.fields.activity,
            isMobile: config.device.isMobile,
            disableAttachmentBox: this._disableAttachmentBox,
            count: this.record.data.message_attachment_count || 0,
        });
    },
    /**
     * @private
     * @param {Object} record
     * @param {integer} [record.res_id]
     * @param {string} [record.model]
     * @param {string} record.data.display_name
     */
    _setState: function (record) {

        this._isCreateMode = !record.res_id;

        if (!this.record || this.record.res_id !== record.res_id) {
            this.context = {
                default_res_id: record.res_id || false,
                default_model: record.model || false,
            };
            // ensure a reload of the suggested partners when
            // opening the composer on another record
            this._suggestedPartners = undefined;
        }
        this.record = record;
        this.recordName = record.data.display_name;
    },
    /**
     * @private
     */
     _updateAttachmentCounter: function () {
        var count = this.record.data.message_attachment_count || 0;
        var $element = this.$('.o_chatter_attachment_button_count');
        if (Number($element.html()) !== count) {
            this._areAttachmentsLoaded = false;
            $element.html(count);
        }
     },
    /**
     * @private
     */
    _updateMentionSuggestions: function () {
        if (!this.fields.followers) {
            return;
        }
        var self = this;

        this._mentionSuggestions = [];

        // add the followers to the mention suggestions
        var followerSuggestions = [];
        var followers = this.fields.followers.getFollowers();
        _.each(followers, function (follower) {
            if (follower.res_model === 'res.partner') {
                followerSuggestions.push({
                    id: follower.res_id,
                    name: follower.name,
                    email: follower.email,
                });
            }
        });
        if (followerSuggestions.length) {
            this._mentionSuggestions.push(followerSuggestions);
        }

        // add the partners (followers filtered out) to the mention suggestions
        _.each(this._mentionPartnerSuggestions, function (partners) {
            self._mentionSuggestions.push(_.filter(partners, function (partner) {
                return !_.findWhere(followerSuggestions, { id: partner.id });
            }));
        });
    },


    //--------------------------------------------------------------------------
    // Handlers
    //--------------------------------------------------------------------------

    /**
     * @private
     * @param {OdooEvent} ev
     * @param {integer} ev.data.attachmentId
     * @param {String} ev.data.attachmentName
     */
    _onDeleteAttachment: function (ev) {
        ev.stopPropagation();
        var self = this;
        var options = {
            confirm_callback: function () {
                self._rpc({
                    model: 'ir.attachment',
                    method: 'unlink',
                    args: [parseInt(ev.data.attachmentId, 10)],
                })
                .then(function () {
                    self._reloadAttachmentBox();
                    if (self.fields.thread) {
                        self.fields.thread.removeAttachments([ev.data.attachmentId]);
                    }
                    self.trigger_up('reload');
                });
            }
        };
        var promptText = _.str.sprintf(_t("Do you really want to delete %s?"), _.escape(ev.data.attachmentName));
        Dialog.confirm(this, promptText, options);
    },
    /**
     * @private
     */
    _onClickAttachmentButton: function () {
        if(this._disableAttachmentBox) {
            return;
        }
        if (this._isAttachmentBoxOpen) {
            this._closeAttachments();
        } else {
            var def;
            if (!this._areAttachmentsLoaded) {
                def = this._fetchAttachments();
            }
            Promise.resolve(def).then(this._openAttachmentBox.bind(this));
        }
    },
    /**
     * Discard changes on the record.
     * This is notified by the composer, when opening the full-composer.
     *
     * @private
     * @param {OdooEvent} ev
     * @param {function} ev.data.proceed callback to tell to proceed
     */
    _onDiscardRecordChanges: function (ev) {
        this._discardChanges().then(ev.data.proceed);
    },
    async _onOpenComposerMessage() {
        const suggestedPartners = await this._getSuggestedPartners();
        this._openComposer({
            isLog: false,
            suggestedPartners,
        });
    },
    /**
     * @private
     */
    _onOpenComposerNote: function () {
        this._openComposer({ isLog: true });
    },
    /**
     * @private
     */
    _onReloadAttachmentBox: function () {
        if (this.reloadOnUploadAttachment) {
            this.trigger_up('reload');
        }
        this._reloadAttachmentBox();
    },
    /**
     * @private
     * @param {OdooEvent} event
     * @param {string} event.name
     * @param {Object} event.data
     * @param {boolean} [event.data.activity]
     * @param {boolean} [event.data.followers]
     * @param {boolean} [event.data.thread]
     */
    _onReloadMailFields: function (event) {
        var fieldNames = [];
        if (this.fields.activity && event.data.activity) {
            fieldNames.push(this.fields.activity.name);
        }
        if (this.fields.followers && event.data.followers) {
            fieldNames.push(this.fields.followers.name);
        }
        if (this.fields.thread && event.data.thread) {
            fieldNames.push(this.fields.thread.name);
        }
        this.trigger_up('reload', {
            fieldNames: fieldNames,
            keepChanges: true,
        });
    },
    /**
     * @private
     * @param {OdooEvent} ev
     */
    _onResetSuggestedPartners(ev) {
        ev.stopPropagation();
        this._suggestedPartners = undefined;
    },
    /**
     * @private
     */
    _onScheduleActivity: function () {
        this.fields.activity.scheduleActivity();
    },
});

return Chatter;

});
