

$c->{plugins}{"Screen::EPrint::Box::CoreRecommender"}{params}{id}  = "recommenderID";

# No reason to modify lines below here (although feel free to if you know what you are doing!)
$c->{plugins}->{"Screen::EPrint::Box::CoreRecommender"}->{appears}->{summary_top} = undef;
$c->{plugins}->{"Screen::EPrint::Box::CoreRecommender"}->{appears}->{summary_right} = undef;
$c->{plugins}->{"Screen::EPrint::Box::CoreRecommender"}->{appears}->{summary_bottom} = 500;
$c->{plugins}->{"Screen::EPrint::Box::CoreRecommender"}->{appears}->{summary_left} = undef;

$c->{plugins}{"Screen::EPrint::Box::CoreRecommender"}{params}{disable} = 0;

