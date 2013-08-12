module SpreePromotionsPlus
	class Engine < Rails::Engine
		engine_name 'spree_promotions_plus'
		isolate_namespace Spree

		config.autoload_paths += %W(#{config.root}/lib)

		# use rspec for tests
		config.generators do |g|
			g.test_framework :rspec
		end

		initializer "spree.promo.register.promotions.rules" do |app|
			# Rules
			app.config.spree.promotions.rules += [
																						Spree::Promotion::Rules::OrderTotal,
																						Spree::Promotion::Rules::OrderQuantity,
																						Spree::Promotion::Rules::ItemQuantity,
																						Spree::Promotion::Rules::ProductBuyTaxon,
																						Spree::Promotion::Rules::ProductBuyTaxonTotal,
																						Spree::Promotion::Rules::ProductBuyTaxonQuantity,
																						Spree::Promotion::Rules::HappyBirthday,
																						Spree::Promotion::Rules::Gender,
																						Spree::Promotion::Rules::Club
																					 ]
		end

		initializer 'spree.promo.register.promotion_plus_calculators', :after => "spree.promo.register.promotion.calculators" do |app|
				app.config.spree.calculators.promotion_actions_create_adjustments += [
																																							Spree::Calculator::FlatPercentPerItem,
																																							Spree::Calculator::FlatPercentPerTaxon,
																																							Spree::Calculator::FlatRatePerTaxon,
																																							Spree::Calculator::PayNGetM
																																						 ]
		end

		def self.activate
			Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
				Rails.configuration.cache_classes ? require(c) : load(c)
			end
		end

		config.to_prepare &method(:activate).to_proc
	end
end
