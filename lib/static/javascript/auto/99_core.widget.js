(function($) {
	// helper function to work with the templates, replaces placeholders with strings
	String.prototype.placeContent = function() {
		var formatted = this;
		for (var arg = 0; arg < arguments.length; arg++) {
			formatted = formatted.replace("{" + arg + "}", arguments[arg]);
		}
        return formatted;
	};
	
	$.fn.coreWidget = function(options) {
		var placeHolder = this;
        if ($heading == "")
            $heading = 'Similar Documents';
        if ($heading == 'none')
            $heading = '';
				
		var settings = {
			"serverUrl": "//core.kmi.open.ac.uk/widget2", 
			"widgetTpl": "\
				<div class=\"coreWidget\">\
					<h3>$heading</h3>\
					<ul>\
					{0}\
					</ul>\
					<div class=\"footer\">\
						<a href=\"{1}\" onclick=\"window.open(this.href); return false;\">Powered by <img src=\"{2}\"></a>\
					</div>\
				</div>\
			".replace("$heading", $heading),
			"documentTpl": "\
				<li><a href=\"{0}\">{1}</a></li>\
			"
		};

		
		// extend settings if the override is available
		if (options) {
			$.extend(settings, options);
		}
		var xhr = null;
		// api key and at least one of OAI, URL or abstract have to be specified
		if (settings.apiKey && (settings.documentOAI || settings.documentUrl || settings.documentAbstract)) {
			// use the JSONP call to retrieve the data from given server
            		xhr = $.ajax({
				url: settings.serverUrl, 
				dataType: "jsonp",
                		crossDomain : true,
				data: {
				    oai: settings.documentOAI,
                    		    url: settings.documentUrl,
				    title: settings.documentTitle,
				    authors: settings.documentAuthors,
				    aabstract: settings.documentAbstract,
				    api_key: settings.apiKey
				},
                		timeout: 1200000,

				
				error: function(XHR, textStatus, errorThrown) {
					//console.log('Error Status: ' + status + ' - Error Message:' + error );
				}
            });
			xhr.done(function(data) {
				if (data==""){
					//console.log("Data is empty. Do nothing. The plugin will not render a box");
					return;
				}
				var documentsHtml = "",
						document = null;
				if (data && (0 < data.count)) {
						// add all the document using pre-defined template
						for(i = 0; i < data.documents.length; ++i) {
								document = data.documents[i];
								documentsHtml += settings.documentTpl.placeContent(document.url, document.name);
						}
						// put together the widget template
						placeHolder.append(
							settings.widgetTpl.placeContent(documentsHtml,
								data.serverUrl, data.serverLogoUrl
							));
						// Show COREWidgetBox if data was sent
						if( data !== null ) {
							showCOREWidgetBox($box, $disablebox)
						}
				}
		});
		}
	};
})(jQuery);
// Disable Box here (incase syntax error in main document)
hideCOREWidgetBox(jQuery('#COREpluginOutput').parent().parent().parent());

function hideCOREWidgetBox($box) {
        try {
            $box.children('.ep_summary_box_title').hide();
            $box.children('#ep_summary_box_1_content').hide();
        }
        catch(e)
        {
            console.log(e.message);
        }
};

function showCOREWidgetBox($box, $disableBoxMode) {
    if (!$disableBoxMode)
    {
        try {
            $box.children('.ep_summary_box_title').show();
            $box.children('#ep_summary_box_1_content').show();
        }
        catch(e)
        {
            console.log(e.message);
        }
    }
};
