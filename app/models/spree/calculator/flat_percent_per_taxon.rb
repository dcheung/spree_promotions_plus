module Spree
	class Calculator::FlatPercentPerTaxon < Calculator
		preference :flat_percent, :decimal, :default => 0.0
		preference :taxon, :integer, :default => 0

		attr_accessible :preferred_flat_percent, :preferred_taxon

		def self.description
			I18n.t(:flat_percent_per_taxon)
		end

		def compute(object=nil)
			return 0 if object.nil?
			taxon = Spree::Taxon.find(preferred_taxon)
			item_total = object.line_items.map{|li| li.product.first_taxon.ancestors.include?(taxon) ? li.amount : 0.0 }.sum
			value = item_total * BigDecimal(self.preferred_flat_percent.to_s) / 100.0
			(value * 100).round.to_f / 100
		end

	end
end

