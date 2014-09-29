package EPrints::Plugin::Screen::EPrint::Box::CORE;

@ISA = ( 'EPrints::Plugin::Screen::EPrint::Box' );

#use strict;
#use Data::Dumper;

use EPrints qw( no_check_user );
use FileHandle;


sub render
{
	# Set up vars and global stuff
    my( $self ) = @_;
    my $repository = $self->{repository};
    my $eprint = $self->{processor}->{eprint};
	my $session = $self->{session};

	my $base_url = $session->get_repository->get_conf( 'base_url' );
	
	# Get title of EPrint
    my $title = $eprint->get_value("title");
	# Escape single quote '
	$title =~ s/'/\\'/g;
	
	# Get abstract
    my $abstract = $eprint->get_value("abstract");
    # Incase abstract includes Carriage return+new line (\r\n) (Windows)
	$abstract =~ s/\r\n/ /g;
    # Incase abstract includes new line (\n)
    $abstract =~ s/\n/ /g;
	# Replace and escape instances of apostrophes '
	$abstract =~ s/'/\\'/g;
	
    # Create oaiIdentifier
    my $hostname = $session->get_repository->get_conf('host'); # get domain name of server
    my $eprintid = $eprint->get_value("eprintid"); # id of the eprint 
    
	my $oaiIdentifier = "oai:".$hostname.":".$eprintid; # Format into oai ident
    
	
	# Get URL of PDF download
	my @docs = $eprint->get_all_documents; # Get all documents associated with the eprint
	
	my $dlURL = "";
	
	# Iterate through array
    for $doc (@docs){
		$dlURL = $doc->get_url;
		# If a given url has a .pdf suffix, exit loop
		if ($dlURL =~ m/pdf$/i){
			last;
		}	
    }
	
	# If dlURL does not contains hostname of EPrints repo, send no URL!
	if (index($dlURL, $hostname) == -1) {
		$dlURL = "";
	}
	
	# Get authors and format them ready to place in javascript output	
    my $documentAuthorsArrayString = "";
    if ($eprint->is_set("creators_name"))
    {
		# for each author format accordingly 'familyName givenName',
		# Note: this loop automatically appends a , after each name
		for (@{$eprint->get_value("creators_name")})
		{
			my $authorName = $_->{family}.' '.$_->{given};
			# Escape single quote '
			$authorName =~ s/'/\\'/g;
			$documentAuthorsArrayString .= "'".$authorName."',";
		}
    }
	# Add empty '' string so javascript will not complain about the last comma
    $documentAuthorsArrayString .= "''";

	
    # Get CORE api key from configuration
    $apiKey = $self->param("core_api_key");
    
    # Get config if box should be disabled
    $disableBoxMode = $self->param("core_disable_box");
	   
    # Get heading set in Config
    $heading = $self->param("core_heading");
    
	## Now we have all the information we need, lets generate our output
	my $xml = $repository->xml;
    my $frag = $repository->make_doc_fragment;
	
    $BoxJS = '';
    # If disabledBoxMode if cfg.d file
    if ($disableBoxMode) {
        $BoxJS = "
                // Box is disabled
                \$widget = \$box";                
    } else {
        $BoxJS = "
                // Box is NOT disabled
                \$widget = \$('#COREpluginOutput');";
    }
        
	
	# Create javascript bit
    my $exp = $xml->create_data_element(
        "script","
            (function(\$) {
                \$(document).ready(function(){
                
                \$heading = '$heading';
                
                \$box = \$('#COREpluginOutput').parent().parent().parent();
                \$disablebox = $disableBoxMode;
                
                \$widget = '';
                if (\$disablebox)
                    \$widget = \$box;
                else
                    \$widget = \$('#COREpluginOutput');
                
                hideCOREWidgetBox(\$box);
                \$('#'+ \$widget.attr('id')).coreWidget({
                        documentOAI: '" . $oaiIdentifier . "',	
                        documentUrl: '" . $dlURL . "',
                        documentTitle: '" . $title . "',
                        documentAuthors: [" . $documentAuthorsArrayString . "],
                        documentAbstract: '" . $abstract  . "',
                        apiKey: '" . $apiKey  . "'
                    });
				});
            })(jQuery);",
        type=>"text/javascript");
    # Add external javascript file
    #my $scriptOutput = $xml->create_data_element("script",undef,src=>$base_url . "/javascript/CORE.widget.js");
    # Add external CSS
    #my $cssOutput = $xml->create_data_element("link",undef,href=>$base_url . "/style/CORE.css");
    		
	# Create div to output javascript contents to
    my $pluginOutputDiv = $xml->create_data_element("div",undef,id=>"COREpluginOutput");
	
	# Add created xml elements to frag obj
    $frag->appendChild($pluginOutputDiv);
    
    $frag->appendChild($exp);

   
    return $frag;
}
	