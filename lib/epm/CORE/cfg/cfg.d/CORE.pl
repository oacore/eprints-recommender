# To make this widget work, you need an API key
# 1) visit http://core.kmi.open.ac.uk/api/doc#auth to register for your API key 
# 2) In this file, find and replace InsertKeyHere with your API key
# 3) Go to admin->Systems Tools and click on the 'Regenerate Abstracts' button or using the terminal, become the eprints user and run ~/bin/epadmin reload
# 4) Visit an eprint and see the widget in action!
# 5) The CSS for the widget is located in /lib/static/style/auto/CORE.css - we would reccomend you make a backup. You will need to restore the file if you want to upgrade or uninstall the plugin.

$c->{plugins}{"Screen::EPrint::Box::CORE"}{params}{core_api_key}  = "InsertKeyHere";

# We think it looks nicer to disable the surrounding box
$c->{plugins}{"Screen::EPrint::Box::CORE"}{params}{core_disable_box}  = 1;


# Modify Titles/heading
$c->{plugins}{"Screen::EPrint::Box::CORE"}{params}{core_heading}  = 'Similar Documents';
# for no heading, use the following line
#$c->{plugins}{"Screen::EPrint::Box::CORE"}{params}{core_heading}  = 'none';

# To modify the Box heading, find the file /lib/lang/en/phrases/CORE.xml and modify the phrase:
# Plugin/Screen/EPrint/Box/CORE:title


# No reason to modify lines below here (although feel free to if you know what you are doing!)
$c->{plugins}->{"Screen::EPrint::Box::CORE"}->{appears}->{summary_top} = undef;
$c->{plugins}->{"Screen::EPrint::Box::CORE"}->{appears}->{summary_right} = undef;
$c->{plugins}->{"Screen::EPrint::Box::CORE"}->{appears}->{summary_bottom} = 800;
$c->{plugins}->{"Screen::EPrint::Box::CORE"}->{appears}->{summary_left} = undef;

$c->{plugins}{"Screen::EPrint::Box::CORE"}{params}{disable} = 0;


