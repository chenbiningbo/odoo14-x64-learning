# -*- coding: utf-8 -*-
# Part of Odoo. See LICENSE file for full copyright and licensing details.

from odoo.addons.event.tests.common import TestEventCommon


class TestEventQuestionCommon(TestEventCommon):

    @classmethod
    def setUpClass(cls):
        super(TestEventQuestionCommon, cls).setUpClass()

        cls.event_question_1 = cls.env['event.question'].create({
            'title': 'Question1',
            'event_type_id': cls.event_type_complex.id,
            'is_individual': True,
            'answer_ids': [
                (0, 0, {'name': 'Q1-Answer1'}),
                (0, 0, {'name': 'Q1-Answer2'})
            ],
        })
        cls.event_question_2 = cls.env['event.question'].create({
            'title': 'Question2',
            'event_type_id': cls.event_type_complex.id,
            'is_individual': False,
            'answer_ids': [
                (0, 0, {'name': 'Q2-Answer1'}),
                (0, 0, {'name': 'Q2-Answer2'})
            ],
        })
        cls.event_type_complex.write({'use_questions': True})
