package EPrints::Plugin::Screen::EPrint::Box::CoreRecommender;

@ISA = ( 'EPrints::Plugin::Screen::EPrint::Box' );

use EPrints qw( no_check_user );
use FileHandle;


sub render
{
    # Set up vars and global stuff
    my( $self ) = @_;
    my $repository = $self->{repository};
    my $eprint = $self->{processor}->{eprint};
    my $session = $self->{session};

    my $xml = $repository->xml;
    my $frag = $repository->make_doc_fragment;

    # Get ID of recommender from configuration
    $idRec = $self->param("id");

	my $external_css = '';
	if( $self->param( "include_css" ) ){
	
		$external_css = <<"ENDCSS"
				var link = d.createElement('link');
                link.setAttribute('rel', 'stylesheet');
                link.setAttribute('type', 'text/css');
                link.setAttribute('href', coreAddress + '/recommender/embed-eprints-style.css');
                d.getElementsByTagName('head')[0].appendChild(link);
ENDCSS

	}

    # Create javascript SnippetCode
    my $exp = $xml->create_data_element(
        "script","
            (function (d, s, idScript, idRec, userInput) {
                var coreAddress = 'https://core.ac.uk';
                var js, fjs = d.getElementsByTagName(s)[0];
                if (d.getElementById(idScript))
                    return;
                js = d.createElement(s);
                js.id = idScript;
                js.src = coreAddress + '/recommender/embed.js';
                fjs.parentNode.insertBefore(js, fjs);

                localStorage.setItem('idRecommender', idRec);
                localStorage.setItem('userInput', JSON.stringify(userInput));

				". $external_css . "
            }(document, 'script', 'recommender-embed', '". $idRec ."', {}));",
        type=>"text/javascript");
            
    # Add section title to plugin window
    my $pluginOutputTitle = $repository->html_phrase("Plugin/Screen/EPrint/Box/CORE:CoreRecommender:sectionTitle");
    $frag->appendChild($pluginOutputTitle);
    
    # Create div to output javascript contents to
    my $pluginOutputDiv = $xml->create_data_element("div",undef,id=>"coreRecommenderOutput");
    
    # Add created xml elements to frag obj
    $frag->appendChild($pluginOutputDiv);
    
    $frag->appendChild($exp);

   
    return $frag;
}
    
