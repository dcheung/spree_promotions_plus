module Spree
	class Calculator::FlatPercentPerItem < Calculator
		preference :flat_percent, :decimal, :default => 0.0

		attr_accessible :preferred_flat_percent

		def self.description
			I18n.t(:flat_percent_per_item)
		end

		def compute(object=nil)
			return 0 if object.nil? || target_products.blank?
			item_total = object.line_items.map{|li| target_products.include?(li.product) ? li.amount : 0.0 }.sum
			value = item_total * BigDecimal(self.preferred_flat_percent.to_s) / 100.0
			(value * 100).round.to_f / 100
		end

		def compatible_rule?(rule)
			rule.respond_to?(:preferred_products_source) && rule.respond_to?(:products) && 
			rule.respond_to?(:product_group) && rule.respond_to?(:eligible_products)
		end

		def target_products
			product_groups_rules = self.calculable.promotion.rules.select do |rule| 
				compatible_rule?(rule)
			end

			products_found = []
			product_groups_rules.each do |rule|
				products_found << rule.eligible_products
			end

			return products_found.flatten
		end
	end
end
