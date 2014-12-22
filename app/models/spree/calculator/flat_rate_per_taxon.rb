module Spree
	class Calculator::FlatRatePerTaxon < Calculator
		preference :amount, :decimal, :default => 0.0
		preference :taxon, :integer, :default => 0

		attr_accessible :preferred_taxon, :preferred_amount

		def self.description
			I18n.t(:flat_rate_per_taxon)
		end

		def compute(object=nil)
			return 0 if object.nil?
			taxon = Spree::Taxon.find(preferred_taxon)
			value = object.line_items.map{|li| li.product.first_taxon.ancestors.include?(taxon) ? (li.price > self.preferred_amount ? (li.quantity * self.preferred_amount) : 0.0) : 0.0 }.sum
			(value * 100).round.to_f / 100
		end

	end
end
