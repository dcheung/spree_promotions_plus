module Spree
	class Promotion::Rules::ProductBuyTaxonQuantity < PromotionRule
		preference :taxon, :integer, :default => ''
		preference :quantity, :integer, :default => 10
		preference :operator, :string, :default => '>'

		attr_accessible :preferred_quantity, :preferred_operator, :preferred_taxon

		OPERATORS = ['gt', 'gte']

		def eligible?(order, options = {})
      item_total = 0
      taxon = Spree::Taxon.find(preferred_taxon)
      order.line_items.each do |line_item|
        item_total += line_item.quantity if line_item.product.first_taxon.ancestors.include?(taxon)
      end
      item_total.send(preferred_operator == 'gte' ? :>= : :>, preferred_quantity)
    end

	end
end
