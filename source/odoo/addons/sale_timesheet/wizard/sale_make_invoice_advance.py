from odoo import api, fields, models


class SaleAdvancePaymentInv(models.TransientModel):
    _inherit = "sale.advance.payment.inv"

    @api.model
    def _default_invoicing_timesheet_enabled(self):
        if 'active_id' not in self._context and 'active_ids' not in self._context:
            return False
        sale_orders = self.env['sale.order'].browse(self._context.get('active_id') or self._context.get('active_ids'))
        order_lines = sale_orders.mapped('order_line').filtered(lambda sol: sol.invoice_status == 'to invoice')
        product_ids = order_lines.mapped('product_id').filtered(lambda p: p._is_delivered_timesheet())
        return bool(product_ids)

    date_invoice_timesheet = fields.Date(
        string='Invoice Timesheets Up To This Date',
        default=fields.Date.today,
        required=False,
        help="Only timesheets not yet invoiced (and validated, if applicable) up to this date included will be invoiced. If no date is indicated, all timesheets not yet invoiced (and validated, if applicable) will be invoiced without distinction.")
    invoicing_timesheet_enabled = fields.Boolean(default=_default_invoicing_timesheet_enabled)

    def create_invoices(self):
        """ Override method from sale/wizard/sale_make_invoice_advance.py

            When the user want to invoice the timesheets to the SO
            up to a specific date then we need to recompute the
            qty_to_invoice for each product_id in sale.order.line,
            before creating the invoice.
        """
        sale_orders = self.env['sale.order'].browse(
            self._context.get('active_ids', [])
        )

        if self.advance_payment_method == 'delivered' and self.invoicing_timesheet_enabled:
            if self.date_invoice_timesheet:
                sale_orders.mapped('order_line')._recompute_qty_to_invoice(self.date_invoice_timesheet)

            sale_orders._create_invoices(final=self.deduct_down_payments, date=self.date_invoice_timesheet)

            if self._context.get('open_invoices', False):
                return sale_orders.action_view_invoice()
            return {'type': 'ir.actions.act_window_close'}

        return super(SaleAdvancePaymentInv, self).create_invoices()
