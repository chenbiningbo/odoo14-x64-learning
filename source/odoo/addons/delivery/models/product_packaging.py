# -*- coding: utf-8 -*-
# Part of Odoo. See LICENSE file for full copyright and licensing details.

from odoo import models, fields, api


class ProductPackaging(models.Model):
    _inherit = 'product.packaging'

    height = fields.Integer('Height')
    width = fields.Integer('Width')
    packaging_length = fields.Integer('Length')
    max_weight = fields.Float('Max Weight', help='Maximum weight shippable in this packaging')
    shipper_package_code = fields.Char('Package Code')
    package_carrier_type = fields.Selection([('none', 'No carrier integration')], string='Carrier', default='none')

    _sql_constraints = [
        ('positive_height', 'CHECK(height>=0)', 'Height must be positive'),
        ('positive_width', 'CHECK(width>=0)', 'Width must be positive'),
        ('positive_length', 'CHECK(packaging_length>=0)', 'Length must be positive'),
        ('positive_max_weight', 'CHECK(max_weight>=0.0)', 'Max Weight must be positive'),
    ]

    @api.onchange('package_carrier_type')
    def _onchange_carrier_type(self):
        carrier_id = self.env['delivery.carrier'].search([('delivery_type', '=', self.package_carrier_type)], limit=1)
        if carrier_id:
            self.shipper_package_code = carrier_id._get_default_custom_package_code()
        else:
            self.shipper_package_code = False
