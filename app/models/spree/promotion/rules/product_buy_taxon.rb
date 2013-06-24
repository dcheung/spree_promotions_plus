module Spree
	class Promotion::Rules::ProductBuyTaxon < PromotionRule
		preference :taxon, :integer, :default => ''

		attr_accessible :preferred_taxon

		def eligible?(order, options = {})
      taxon = Spree::Taxon.find(preferred_taxon)
			order.line_items.any?{|line_item| line_item.product.first_taxon.ancestors.include?(taxon)}
		end

	end
end
