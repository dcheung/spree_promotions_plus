//= require admin/spree_core

function enable_taxons_rules_selector() {
	$(".taxons_rules_selector").select2({
		placeholder: "Start typing",
		allowClear: true,
		minimumInputLength: 3,
		format: 'json',
		width: "400px",
    initSelection: function(element, callback) {
    	return callback({id: element.val(), text: $("#taxon_id_name").val()});
    },
		ajax: {
			url: "/admin/taxons/load_selection.json",
			dataType: 'json',
			data: function (term, page) {
				return {
					q: term, 
					type: 'Spree::Taxon'
				};
			},
			results: function (data, page) { 
        return { results: data, more: false };
			}
		}
	});	
} 
