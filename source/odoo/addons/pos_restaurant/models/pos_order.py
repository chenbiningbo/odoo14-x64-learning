# -*- coding: utf-8 -*-
# Part of Odoo. See LICENSE file for full copyright and licensing details.
from itertools import groupby
from re import search

from odoo import api, fields, models


class PosOrderLine(models.Model):
    _inherit = 'pos.order.line'

    note = fields.Char('Note added by the waiter.')
    mp_skip = fields.Boolean('Skip line when sending ticket to kitchen printers.')
    mp_dirty = fields.Boolean()


class PosOrder(models.Model):
    _inherit = 'pos.order'

    table_id = fields.Many2one('restaurant.table', string='Table', help='The table where this order was served')
    customer_count = fields.Integer(string='Guests', help='The amount of customers that have been served by this order.')
    multiprint_resume = fields.Char()

    def _get_pack_lot_lines(self, order_lines):
        """Add pack_lot_lines to the order_lines.

        The function doesn't return anything but adds the results directly to the order_lines.

        :param order_lines: order_lines for which the pack_lot_lines are to be requested.
        :type order_lines: pos.order.line.
        """
        pack_lots = self.env['pos.pack.operation.lot'].search_read(
                domain = [('pos_order_line_id', 'in', [order_line['id'] for order_line in order_lines])],
                fields = [
                    'id',
                    'lot_name',
                    'pos_order_line_id'
                    ])
        for pack_lot in pack_lots:
            pack_lot['order_line'] = pack_lot['pos_order_line_id'][0]
            pack_lot['server_id'] = pack_lot['id']

            del pack_lot['pos_order_line_id']
            del pack_lot['id']

        for order_line_id, pack_lot_ids in groupby(pack_lots, key=lambda x:x['order_line']):
            next(order_line for order_line in order_lines if order_line['id'] == order_line_id)['pack_lot_ids'] = list(pack_lots)

    def _get_fields_for_order_line(self):
        return [
            'id',
            'discount',
            'product_id',
            'price_unit',
            'order_id',
            'qty',
            'note',
            'mp_skip',
            'mp_dirty',
        ]

    def _get_order_lines(self, orders):
        """Add pos_order_lines to the orders.

        The function doesn't return anything but adds the results directly to the orders.

        :param orders: orders for which the order_lines are to be requested.
        :type orders: pos.order.
        """
        order_lines = self.env['pos.order.line'].search_read(
                domain = [('order_id', 'in', [to['id'] for to in orders])],
                fields = self._get_fields_for_order_line())

        if order_lines != []:
            self._get_pack_lot_lines(order_lines)

        extended_order_lines = []
        for order_line in order_lines:
            order_line['product_id'] = order_line['product_id'][0]
            order_line['server_id'] = order_line['id']

            del order_line['id']
            if not 'pack_lot_ids' in order_line:
                order_line['pack_lot_ids'] = []
            extended_order_lines.append([0, 0, order_line])

        for order_id, order_lines in groupby(extended_order_lines, key=lambda x:x[2]['order_id']):
            next(order for order in orders if order['id'] == order_id[0])['lines'] = list(order_lines)

    def _get_fields_for_payment_lines(self):
        return [
            'id',
            'amount',
            'pos_order_id',
            'payment_method_id',
            'card_type',
            'transaction_id',
            'payment_status'
            ]

    def _get_payment_lines(self, orders):
        """Add account_bank_statement_lines to the orders.

        The function doesn't return anything but adds the results directly to the orders.

        :param orders: orders for which the payment_lines are to be requested.
        :type orders: pos.order.
        """
        payment_lines = self.env['pos.payment'].search_read(
                domain = [('pos_order_id', 'in', [po['id'] for po in orders])],
                fields = self._get_fields_for_payment_lines())

        extended_payment_lines = []
        for payment_line in payment_lines:
            payment_line['server_id'] = payment_line['id']
            payment_line['payment_method_id'] = payment_line['payment_method_id'][0]

            del payment_line['id']
            extended_payment_lines.append([0, 0, payment_line])
        for order_id, payment_lines in groupby(extended_payment_lines, key=lambda x:x[2]['pos_order_id']):
            next(order for order in orders if order['id'] == order_id[0])['statement_ids'] = list(payment_lines)

    def _get_fields_for_draft_order(self):
        return [
                    'id',
                    'pricelist_id',
                    'partner_id',
                    'sequence_number',
                    'session_id',
                    'pos_reference',
                    'create_uid',
                    'create_date',
                    'customer_count',
                    'fiscal_position_id',
                    'table_id',
                    'to_invoice',
                    'multiprint_resume',
                    ]

    @api.model
    def get_table_draft_orders(self, table_id):
        """Generate an object of all draft orders for the given table.

        Generate and return an JSON object with all draft orders for the given table, to send to the
        front end application.

        :param table_id: Id of the selected table.
        :type table_id: int.
        :returns: list -- list of dict representing the table orders
        """
        table_orders = self.search_read(
                domain = [('state', '=', 'draft'), ('table_id', '=', table_id)],
                fields = self._get_fields_for_draft_order())

        self._get_order_lines(table_orders)
        self._get_payment_lines(table_orders)

        for order in table_orders:
            order['pos_session_id'] = order['session_id'][0]
            order['uid'] = search(r"\d{5,}-\d{3,}-\d{4,}", order['pos_reference']).group(0)
            order['name'] = order['pos_reference']
            order['creation_date'] = order['create_date']
            order['server_id'] = order['id']
            if order['fiscal_position_id']:
                order['fiscal_position_id'] = order['fiscal_position_id'][0]
            if order['pricelist_id']:
                order['pricelist_id'] = order['pricelist_id'][0]
            if order['partner_id']:
                order['partner_id'] = order['partner_id'][0]
            if order['table_id']:
                order['table_id'] = order['table_id'][0]

            if not 'lines' in order:
                order['lines'] = []
            if not 'statement_ids' in order:
                order['statement_ids'] = []

            del order['id']
            del order['session_id']
            del order['pos_reference']
            del order['create_date']

        return table_orders

    @api.model
    def _order_fields(self, ui_order):
        order_fields = super(PosOrder, self)._order_fields(ui_order)
        order_fields['table_id'] = ui_order.get('table_id', False)
        order_fields['customer_count'] = ui_order.get('customer_count', 0)
        order_fields['multiprint_resume'] = ui_order.get('multiprint_resume', False)
        return order_fields
