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

		def target_products
			#TODO: product groups?
			product_groups_rule = self.calculable.promotion.rules.select{|rule| !rule.product_group_id.blank?}	
			if product_groups_rule.blank?
				self.calculable.promotion.rules.map(&:products).flatten
			else
				product_groups_rule.map{|rule| rule.product_group.products}.flatten
			end
		end
	end
end
