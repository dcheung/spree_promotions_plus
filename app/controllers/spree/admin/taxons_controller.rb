class Spree::Admin::TaxonsController < Spree::Admin::BaseController
	def load_selection
    search_class = params[:type].constantize
      translation_search_class = begin
        "#{params[:type]}::Translation".constantize
    rescue NameError
      nil
    end

    results = if params[:q].blank?
          []
    elsif translation_search_class.present? && translation_search_class.attribute_method?(:name)
          search_class.joins(:translations).where("lower(#{translation_search_class.table_name}.name) LIKE ?", "%#{params[:q].mb_chars.downcase}%")
    else 
          search_class.where('lower(name) LIKE ?', "%#{params[:q].mb_chars.downcase}%")
    end

    results = if results && results.length == 0
          {"text" => "No results."} 
    else
          results.map{|s| { id:   s.id, 
                            text: ((s.respond_to?(:to_print) ? s.to_print : s.name) || 'no_name')}}
    end

    respond_to do |format|
      format.json { render :json => results.to_json  }
		end
	end
end
