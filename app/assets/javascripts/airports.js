$('document').ready(function() {
	
	var airports = new Bloodhound({
	  datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
	  queryTokenizer: Bloodhound.tokenizers.whitespace,
	  limit: 10,
	  local: [
		  {
		    "iata": "UTK",
		    "lon": "169.86667",
		    "iso": "MH",
		    "status": 1,
		    "name": "Utirik Airport",
		    "continent": "OC",
		    "type": "airport",
		    "lat": "11.233333",
		    "size": "small"
		  },
		  {
		    "iata": "FIV",
		    "iso": "US",
		    "status": 1,
		    "name": "Five Finger CG Heliport",
		    "continent": "NA",
		    "type": "heliport",
		    "size": null
		  }]
	});

	// kicks off the loading/processing of `local` and `prefetch`
	airports.initialize();

	// passing in `null` for the `options` arguments will result in the default
	// options being used
	$('#prefetch .typeahead').typeahead(null, {
	  name: 'airports',
	  displayKey: 'iata',
	  // `ttAdapter` wraps the suggestion engine in an adapter that
	  // is compatible with the typeahead jQuery plugin
	  source: airports.ttAdapter(),
	
		templates: {
        suggestion: function (airport) {
            return '<p>' + "<i class='fa fa-plane'></i> " + airport.iata + " - " + airport.name + '</p>';
        }
    }
	});

});