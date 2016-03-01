#!/usr/bin/env perl

use FindBin;
use lib "$FindBin::Dir/../../lib";
use strict;
use JSON;
use DDGC;
use Data::Printer;

my $d  = DDGC->new;
my $ias = $d->rs('InstantAnswer');

my %seen;
while(<DATA>){
	chomp;
	my ($id, $git_login) = split /\t/;
	unless($seen{$git_login}){
		if(my $git_user = $d->rs('GitHub::User')->find({login => $git_login})){
			if(my $duckco_user = $d->rs('User')->find({github_id => $git_user->github_id})){
				$seen{$git_login} = $duckco_user;
			}
		}
	}

	if(my $ia = $d->rs('InstantAnswer')->find({meta_id => $id})){
		my $maintainer;
		if(my $du = $seen{$git_login}){
			$maintainer = '{"duckco":"' . $du->username . qq|","github":"$git_login"}|;
			$ia->add_to_users($du);
		}
		else{
			$maintainer = qq|{"github":"$git_login"}|;
		}

		$ia->update({maintainer => $maintainer});
	}
	else{ warn "Failed to lookup IA with id of $id" }
}

__DATA__
us_government_agencies_cheat_sheet	aasoliz				
apt_get_cheat_sheet	abadojack				
bike_sharing_indego_phl	AcriCAA				
german_cheat_sheet	AdamSC1-ddg				
expand_url	adman				
gravatar	adman				
hacker_news	adman				
similar_sites	adman				
brt	afelicioni				
arabic_cheat_sheet	AhmedBenmoussa				
pokemon_data	AkA84				
hearthstone	Akryum				
currency_in	Alchymista				
nmap_cheat_sheet	aleksandar-todorovic				
wordpress_cheat_sheet	aleksandar-todorovic				
slack_cheat_sheet	alexander95015				
todoist_cheat_sheet	alexander95015				
parking	AlexCutlipParkingPanda				
lgbt_cheat_sheet	alexishancock				
apple_mac_os_cheat_sheet	AlfonzM				
scala_cheat_sheet	amitdev				
golden_ratio	andrearonsen				
httpheaders	andrewalker				
js_keycodes_cheat_sheet	andrey-p				
seat_geek_events_by_artist	andrey-p				
seat_geek_events_by_city	andrey-p				
seat_geek_events_by_venue	andrey-p				
seat_geek_events_near_me	andrey-p				
kde_cheat_sheet	ankushg07				
morse_code_cheat_sheet	ankushg07				
safari_cheat_sheet	ankushg07				
states_of_india_cheat_sheet	ankushg07				
vitamin_cheat_sheet	ankushg07				
tcl_ref	anoved				
leet_speak	antoine-vugliano				
magit_cheat_sheet	apg				
java_cheat_sheet	arajparaj				
jira	arroway				
mplayer_cheat_sheet	arwk				
hdfs_shell_cheat_sheet	AshishAAB				
mass_on_time	astine				
dockerfile_cheat_sheet	atilacamurca				
npm_cheat_sheet	atilacamurca				
birth_stone	austinheimark				
factors	austinheimark				
golf_majors_cheat_sheet	austinheimark				
greatest_common_factor	austinheimark				
poker	austinheimark				
prime_factors	austinheimark				
sports	b1ake				
sports_mlb_games	b1ake				
sports_nfl_games	b1ake				
whois	b1ake				
crochet_pattern_cheat_sheet	b2ddg				
knitting_pattern_cheat_sheet	b2ddg				
pwned	b2ddg				
french_cheat_sheet	bbraithwaite				
mtg_phases_cheat_sheet	bcwarner				
wgha	bigcurl				
is_awesome_bigx_mac	BigxMac				
bengali_cheat_sheet	birajkarmakar				
uv	Bjoern				
palindrome	bm1362				
octopart	bnewbold				
code_search	boyter				
java	boyter				
binary_logic	bpaschen				
missing_kids	brianrisk				
quandl_fundamentals	brianrisk				
quandl_home_values	brianrisk				
quandl_world_bank	brianrisk				
riffsy	bryanhart				
duck_duck_go	bsstoner				
gifs	bsstoner				
nutrition	bsstoner				
products	bsstoner				
stocks	bsstoner				
videos	bsstoner				
english_braille_cheat_sheet	chappers				
guitar_chords	charles-l				
tmux_cheat_sheet	charles-l				
heroku_cheat_sheet	checkaayush				
color_picker	chrisharrill				
xwing_alliance_cheat_sheet	cinlloc				
date_math	cj01101				
cryptocurrency	claytonspinner				
triforce_cheat_sheet	cochsen				
unix_time	codejoust				
ubuntu_unity_cheat_sheet	CodeMouse92				
filezilla_cheat_sheet	codenirvana				
gnome_cheat_sheet	codenirvana				
sublime_text_cheat_sheet	codenirvana				
vlc_cheat_sheet	codenirvana				
secret_service_codenames_cheat_sheet	ColasBroux				
czech_cheat_sheet	comatory				
midnight_commander_cheat_sheet	comatory				
help_line	conorfl				
unicode	cosimo				
linux_cheat_sheet	crashrane				
julia	cskksc				
caniuse	csytan				
duck_say	csytan				
open_nic	cylgom				
shorten	danjarvis				
nato_alphabet_cheat_sheet	DavidGinzberg				
lowercase	DavidMascio				
minecraft_status	destruc7i0n				
node_js	dhruvbird				
crypt_hash_check	digit4lfa1l				
arch_linux_cheat_sheet	direwolf424				
gnu_screen_cheat_sheet	dnmfarrell				
perldoc_cheat_sheet	dnmfarrell				
dogo_books	dogomedia				
dogo_movies	dogomedia				
dogo_news	dogomedia				
base64	dogweather				
awesome_bar_cheat_sheet	domjacko				
anagram	drschwabe				
alternative_to	duckduckgo				
android_enthusiasts	duckduckgo	internal			
annex	duckduckgo	internal			
apache	duckduckgo	internal			
arqade	duckduckgo	internal			
ask_different	duckduckgo	internal			
ask_ubuntu	duckduckgo	internal			
avatar	duckduckgo	internal			
ben10	duckduckgo	internal			
bicycles	duckduckgo	internal			
bitcoin_longtail	duckduckgo	internal			
buffythe_vampire_slayerand_angel	duckduckgo	internal			
bulbapedia	duckduckgo	internal			
charmed	duckduckgo	internal			
christianity_longtail	duckduckgo	internal			
clojure	duckduckgo	internal			
club_penguin	duckduckgo	internal			
cross_validated	duckduckgo	internal			
database_administrators	duckduckgo	internal			
destiny	duckduckgo	internal			
dewey	duckduckgo				
diablo	duckduckgo	internal			
digimon_wiki	duckduckgo	internal			
disney	duckduckgo	internal			
doctor_who	duckduckgo	internal			
dofus_wiki	duckduckgo	internal			
doraemon	duckduckgo	internal			
downton_abbey	duckduckgo	internal			
dragon_age	duckduckgo	internal			
dragon_ball_wiki	duckduckgo	internal			
drupal	duckduckgo	internal			
duck_duck_hack	duckduckgo	internal			
e_wrestling	duckduckgo	internal			
electrical_engineering	duckduckgo	internal			
emacs	duckduckgo	internal			
emoticon	duckduckgo	internal			
english_language	duckduckgo	internal			
everquest2	duckduckgo	internal			
fallout_wiki	duckduckgo	internal			
feature_test	duckduckgo	internal			
final_fantasty_wiki	duckduckgo	internal			
fossil	duckduckgo	internal			
freshmeat	duckduckgo	internal			
ftp	duckduckgo	internal			
game_development	duckduckgo	internal			
game_of_thrones	duckduckgo	internal			
geographic_information_systems	duckduckgo	internal			
git_hub	duckduckgo	internal			
git_manual	duckduckgo	internal			
grand_theft_auto	duckduckgo	internal			
halopedia	duckduckgo	internal			
harry_potter	duckduckgo	internal			
home_improvement	duckduckgo	internal			
homebrew_longtail	duckduckgo	internal			
httpstatus	duckduckgo	internal			
indiana_jones_wiki	duckduckgo	internal			
ios	duckduckgo	internal			
jquery	duckduckgo	internal			
judaism_longtail	duckduckgo	internal			
launchpad	duckduckgo	internal			
league_of_legends	duckduckgo	internal			
linux_error	duckduckgo	internal			
london	duckduckgo	internal			
mad_men	duckduckgo	internal			
mariowiki	duckduckgo	internal			
mathematica_lontail	duckduckgo	internal			
mathematics	duckduckgo	internal			
memory_alpha	duckduckgo	internal			
memory_beta	duckduckgo	internal			
mercurial	duckduckgo	internal			
money_longtail	duckduckgo	internal			
moon_phases	duckduckgo				
movie_longtail	duckduckgo	internal			
muppet_wiki	duckduckgo	internal			
my_sql	duckduckgo	internal			
my_sqlerrors	duckduckgo	internal			
naruto	duckduckgo	internal			
oreilly	duckduckgo	internal			
osx	duckduckgo	internal			
perl_doc	duckduckgo	internal			
photography	duckduckgo	internal			
php	duckduckgo	internal			
physics	duckduckgo	internal			
ports	duckduckgo	internal			
pro_webmasters	duckduckgo	internal			
programming_longtail	duckduckgo	internal			
psychology_wiki	duckduckgo	internal			
python	duckduckgo	internal			
randagram	duckduckgo				
ranger_wiki	duckduckgo	internal			
reverse	duckduckgo				
rpg_longtail	duckduckgo	internal			
rune_scape_wiki	duckduckgo	internal			
science_fiction	duckduckgo	internal			
scooby_doo	duckduckgo	internal			
seasoned_advice	duckduckgo	internal			
security	duckduckgo	internal			
server_fault	duckduckgo	internal			
share_point	duckduckgo	internal			
sims	duckduckgo	internal			
skeptics	duckduckgo	internal			
source_forge	duckduckgo	internal			
spell	duckduckgo				
sponge_bob_square_pants	duckduckgo	internal			
stack_overflow	duckduckgo	internal			
star_wars_fanon	duckduckgo	internal			
starctaft	duckduckgo	internal			
stargate	duckduckgo	internal			
steven_universe_wiki	duckduckgo	internal			
subversion	duckduckgo	internal			
super_user	duckduckgo	internal			
terraria	duckduckgo	internal			
tex	duckduckgo	internal			
the_pokemon_encyclopedia	duckduckgo	internal			
theoretical_computer_science	duckduckgo	internal			
tibia	duckduckgo	internal			
tractors	duckduckgo	internal			
travel_longtail	duckduckgo	internal			
twelve_oclock	duckduckgo				
twentyfour	duckduckgo	internal			
unix	duckduckgo	internal			
ux_longtail	duckduckgo	internal			
web_applications	duckduckgo	internal			
where_am_i	duckduckgo				
wikipedia_czech	duckduckgo	internal			
wikipedia_dutch	duckduckgo	internal			
wikipedia_fathead	duckduckgo	internal			
wikipedia_french	duckduckgo	internal			
wikipedia_german	duckduckgo	internal			
wikipedia_italian	duckduckgo	internal			
wikipedia_japanese	duckduckgo	internal			
wikipedia_norwegian	duckduckgo	internal			
wikipedia_polish	duckduckgo	internal			
wikipedia_portuguese	duckduckgo	internal			
wikipedia_russian	duckduckgo	internal			
wikipedia_spanish	duckduckgo	internal			
wikipedia_swedish	duckduckgo	internal			
wikipedia_ukrainian	duckduckgo	internal			
windows	duckduckgo	internal			
wookieepedia	duckduckgo	internal			
word_press	duckduckgo	internal			
wow_wiki	duckduckgo	internal			
twitch_featured	dwaligon				
twitch_streams	dwaligon				
age_of_mythology_cheat_sheet	Edvac				
gimp_cheat_sheet	elebow				
jargon	elebow				
people_in_space	elebow				
yacht_specs	elephantRunAway				
conversions	elohmrow				
figlet	engvik				
minecraft	engvik				
jquery_cheat_sheet	epik				
shruggie	epik				
mdnjs	ericedens				
mercurial_cheat_sheet	ericlake				
bootstrap_cheat_sheet	ethanchewy				
css_cheat_sheet	ethanchewy				
python_cheat_sheet	ethanchewy				
perimeter	ezand				
plone	ezgraphs				
py_pi	ezgraphs				
blood_donor	faraday				
github_status	Feral2k				
launchpad_project	Feral2k				
urban_dictionary	FiloSottile				
unix_man	flaming-toast				
fortune	frncscgmz				
yui3	gaganpreet				
economic_indicators	gauravtiwari5050				
boolean_algebra_cheat_sheet	gautamkrishnar				
duckduckgo_syntax_cheat_sheet	gautamkrishnar				
github_flavoured_markdown_cheat_sheet	gautamkrishnar				
gta_vice_city_cheat_sheet	gautamkrishnar				
postgresql_cheat_sheet	gautamkrishnar				
road_rash_cheat_sheet	gautamkrishnar				
swift_cheat_sheet	gautamkrishnar				
windows_command_prompt_cheat_sheet	gautamkrishnar				
uppercase	gdrooid				
detect_lang	ghedo				
meta_cpan	ghedo				
tar_cheat_sheet	ghost				
timezone_converter	GlitchMr				
sms_cheat_sheet	gmahesh23				
cpp_strings_cheat_sheet	gohar94				
harry_potter_spells_cheat_sheet	gokul1794				
i3_cheat_sheet	goromlagche				
week	gsquire				
caesar_cipher	GuiltyDolphin				
calculator	GuiltyDolphin				
common_escape_sequences_cheat_sheet	GuiltyDolphin				
em_to_px	GuiltyDolphin				
pig_latin	GuiltyDolphin				
wunderlist_cheat_sheet	GuiltyDolphin				
ed_cheat_sheet	Gumnos				
shell_variables_cheat_sheet	h00gr 				
idn	habbie				
prime_number	haojunsui				
c_cheat_sheet	harisphnx				
gdb_cheat_sheet	harisphnx				
magic_number_cheat_sheet	Harsh061				
hayoo	headprogrammingczar				
constants	hemanth				
rafl	Hercynium				
forecast	himanshu0113				
pandas_cheat_sheet	Hitechverma				
kana	hradecek				
bible	hunterlang				
binary	hunterlang				
celeb_heights	hunterlang				
expatistan	hunterlang				
passphrase	hunterlang				
rand_word	hunterlang				
sig_figs	hunterlang				
anime	iambibhas				
deb_version	iambibhas				
rain	iambibhas				
rhymes	iambibhas				
sun_rise_set	iambibhas				
vcgencmd_cheat_sheet	iambibhas				
wikinews	iambibhas				
tfl_status	idlem1nd				
onion_address	ilv				
parse_cron	IndelibleStamp				
coupons	ingowachsmuth-sparheld				
dhl	jagtalon				
dictionary_definition	jagtalon				
fed_ex	jagtalon				
google_plus	jagtalon				
gulp	jagtalon				
hkdk	jagtalon				
images	jagtalon				
in_theaters	jagtalon				
ips	jagtalon				
laser_ship	jagtalon				
lastfm_artist	jagtalon				
news	jagtalon				
regexp	jagtalon				
sha	jagtalon				
twitter	jagtalon				
ups	jagtalon				
usps	jagtalon				
vin	jagtalon				
cpp_algorithms_cheat_sheet	jamie23				
intellij_cheat_sheet	jamie23				
google_inbox_cheat_sheet	JamyGolden				
kerbal_space_program_cheat_sheet	JamyGolden				
sketch_cheat_sheet	JamyGolden				
independence_day	jarmokivekas				
md5	jarmokivekas				
aoeii_cheat_sheet	jarroddunne				
saints_row_cheat_sheet	jatinparmar96				
chinese_dynasties_cheat_sheet	javathunderman				
isslocation	javathunderman				
microsoft_word_cheat_sheet	javathunderman				
paleo_ingredient_check	javathunderman				
gnupg_cheat_sheet	jclement				
sound_cloud	jdan				
airlines	jdorweiler				
calc_roots	jdorweiler				
latex	jdorweiler				
lyrics	jdorweiler				
password	jdorweiler				
random_number	jdorweiler				
poker_hands_cheat_sheet	jee1mr				
drush_cheat_sheet	jeet09				
anniversary_cheat_sheet	JerbiAhmed				
days_between	JetFault				
emacs_idris_mode_cheat_sheet	jfdm				
ghci_repl_cheat_sheet	jfdm				
idris_repl_cheat_sheet	jfdm				
ultimate_answer	jfeeneywm				
emacs_cheat_sheet	jim-brighter				
magic_eight_ball	jlbaez				
bitcoin	jmg				
editor	jmg				
pi	jmvbxx				
resistor_colors	joewalnes				
starcraft2_cheat_sheet	jonk1993				
bible_books_cheat_sheet	jophab				
cpp_cheat_sheet	jophab				
intel_8085_cheat_sheet	jophab				
intel_8086_cheat_sheet	jophab				
jira_cheat_sheet	jophab				
octave_cheat_sheet	jophab				
sql_cheat_sheet	jophab				
in_every_lang	josephwegner				
travis_status	josephwegner				
hello_world	jperla				
hgncgene_names	jrandall				
html_cheat_sheet	jsstrn				
svn_cheat_sheet	Juholei				
phpstorm_osx_cheat_sheet	juhosa				
sum_of_natural_numbers	JulianGindi				
salt_api_cheat_sheet	k00laidzone				
salt_cloud_cheat_sheet	k00laidzone				
calling_codes	kablamo				
vim_cheat_sheet	kablamo				
cryptography_cheat_sheet	kalpetros				
dessert	kennydude				
congress	kevinschaul 				
climb	kfloey				
c_sharp_snippets_cheat_sheet	Khalimov				
apod	killerfish				
astrosubject	killerfish				
country_codes	killerfish				
country_codes_cheat_sheet	killerfish				
eclipse_cheat_sheet	kishoresmeda				
chess960	koosha--				
fibonacci	koosha--				
hex_to_ascii	koosha--				
ruby_gems	koosha--				
sort	koosha--				
unix_permissions	koosha--				
ruby_globals_cheat_sheet	kotoshenya				
bitsum	kste				
affinity_designer_cheat_sheet	lablayers				
thesaurus	lactose				
valar_morghulis	larseng				
armenian_cheat_sheet	lerna				
symbolab	levaly				
security_addons	lights0123				
perforce_workshop_cheat_sheet	lizlam				
dice	loganom				
guid	loganom				
htmlref	lucassmagal				
lua_cheat_sheet	lxndio				
shell_cheat_sheet	lxndio				
chars	mahi30795				
average	Mailkov				
calendar_today	Mailkov				
color_codes	Mailkov				
frequency_spectrum	Mailkov				
percent_error	Mailkov				
public_dns	mailkov				
reverse_resistor_colours	Mailkov				
rubiks_cube_patterns	Mailkov				
scramble	Mailkov				
sun_info	Mailkov				
firefox_about_config	majuscule				
hex_to_dec	majuscule				
nletter_words	majuscule				
zapp_brannigan	majuscule				
madehow	marcantonio				
italian_cheat_sheet	marcostudios				
seat_geek_sports	MariagraziaAlastra				
bay_area_bike_share_ca	marianosimone				
citi_bike_nyc	marianosimone				
markdown_cheat_sheet	marianosimone				
xcode_cheat_sheet	marwendoukh				
paper	mattlehnig				
calendar_conversion	mattlehning				
coin	mattlehning				
hijri	mattlehning				
tips	mattlehning				
ip_codes	mattr555				
make_me_asandwich	mattr555				
path	mattr555				
reddit_search	mattr555				
screen_resolution	mattr555				
septa	mattr555				
stopwatch	mattr555				
tides	mattr555				
timer	mattr555				
tldr_pages	mattr555				
transit_njt	mattr555				
matlab_cheat_sheet	mayank7				
gentoo_portage_cheat_sheet	mbionchi				
rx_info	medicosconsultants				
airports	mellon85				
kmplayer_cheat_sheet	mesooryanarayananb				
xep	metajack				
workdays_between	mgarriott				
wp_cli_cheat_sheet	michaelck				
bulgarian_cheat_sheet	mickeypash				
currency_cheat_sheet	Midhun-Jo-Antony				
renego_job_search	mightycid				
bash_primary_expressions	mintsoft				
iplookup	mintsoft				
regex_cheat_sheet	mintsoft				
subnet_calc	mintsoft				
urldecode	mintsoft				
reddit_sub_search	MithrandirAgain				
xor	MithrandirAgain				
loan	mmattozzi				
envato	mobily				
mac_address	mogigoma				
tor_node	mogigoma				
mainframe_cheat_sheet	mohan08p				
malayalam_cheat_sheet	mohan08p				
marathi_cheat_sheet	mohan08p				
mongodb_cheat_sheet	mohan08p				
openstack_cheat_sheet	mohan08p				
chrome_cheat_sheet	moinism				
apps	moollaza				
couprex_coupons	moollaza				
movie	moollaza				
nodejs_tutorials_cheat_sheet	moollaza				
title_case	moollaza				
base	moritz				
unidecode	moritz				
coderwall	motersen				
currency	MrChrisW				
equaldex	MrChrisW				
flash_version	MrChrisW				
github	MrChrisW				
leak_db	MrChrisW				
sales_tax	MrChrisW				
solar_system	MrChrisW				
sublime_packages	MrChrisW				
time	MrChrisW				
chuck_norris	mr-mayank-gupta				
aspect_ratio	mrshu				
is_it_up	mrshu				
roman	mrshu				
golang_cheat_sheet	MsPseudolus				
qrcode	mstratman				
drinks	mutilator				
zodiac	n0mady				
atom_cheat_sheet	namadistro				
elementary_cheat_sheet	namandistro				
irc_cheat_sheet	namandistro				
rose_meanings_cheat_sheet	namandistro				
aur	natebrune				
rust_types_cheat_sheet	NateBrune				
brainfuck_cheat_sheet	navneetzz				
d3js_cheat_sheet	navneetzz				
illustrator_cheat_sheet	navneetzz				
indesign_cheat_sheet	navneetzz				
kubernetes_cheat_sheet	navneetzz				
mysql_cheat_sheet	navneetzz				
wavelength	nebulous				
plos	nelas				
coffee_to_water_ratio	nickselpa				
maven	nicoulaj				
openboot_cheat_sheet	NikPaulussen				
maps_maps	nilnilnil				
maps_places	nilnilnil				
htmlentities_decode	nishanths				
htmlentities_encode	nishanths				
isbn	nishanths				
urlencode	nishanths				
crontab_cheat_sheet	nkorth				
hackage	nomeata				
potus	numbertheory				
inkscape_cheat_sheet	octomwm				
dns	OndroNR				
slovak_cheat_sheet	OndroNR				
islamic_prayer_times	ozdemirburak				
turkish_cheat_sheet	ozdemirburak				
brainy_quote	Pattarawat				
portuguese_cheat_sheet	pedrobonfim				
nginx	Pfirsichbluete				
vi_cheat_sheet	philipmiesbauer				
viml_cheat_sheet	phora				
geometry	pixunil				
go_watch_it	plexusent				
perl_cheat_sheet	pratik-nagelia				
greek_roman_gods_cheat_sheet	pratts				
docker_cheat_sheet	preemeijer				
dutch_cheat_sheet	preemeijer				
scratch_cheat_sheet	preemeijer				
w3m_cheat_sheet	preemeijer				
assamese_cheat_sheet	prodicus				
nikto_cheat_sheet	pseudozidu				
bacon_ipsum	puskin94				
launchbug	puskin94				
percent_of	puskin94				
rc4	puskin94				
duckduckgo_cheat_sheet	Qeole				
md4	rafacas				
ripemd	rafacas				
sha3	rafacas				
github_cheat_sheet	rahiel				
hindi_cheat_sheet	rahuldecoded				
cmus_cheat_sheet	rahul-raturi				
php_cheat_sheet	rathoreanirudh				
npm	remixz				
opera_cheat_sheet	rhea-ahuja				
combination	richardscollin				
phonetic	robotmay				
kwixer	rodrigue-h				
metasploit_cheat_sheet	rohitzidu				
imgur_cheat_sheet	RomainLG				
fen_viewer	rouzbeh				
country_languages	roysten				
flip_text	rpicard				
coursebuffet	rubydubee				
gmail_cheat_sheet	sagarhani				
ubuntu_cheat_sheet	sagarhani				
homebrew	SalGnt				
vagrant_cheat_sheet	SalGnt				
default_port_numbers_cheat_sheet	salil93				
chess_cheat_sheet	samskeller				
tamil_cheat_sheet	saumyasurendiran				
aqi	schluchc				
xkcd	sdball				
teredo	seanheaton				
redis_cheat_sheet	seisfeld				
sip_response_codes_cheat_sheet	seisfeld				
recipes bsstoner
product_hunt	sevastos				
http_status_codes_cheat_sheet	ShreyasMinocha				
angular_js_cheat_sheet	SibuStephen				
newint	sighmon				
sublime_text_mac_cheat_sheet	silverli				
indian_languages_cheat_sheet	sinwar				
kabaddi_terms_cheat_sheet	sinwar				
camel_case	Sloff				
leap_year	Sloff				
microsoft_windows_cheat_sheet	Sloff				
unicornify	sloff				
keybase	soleo				
packagist	somus				
bootic	sparky				
coffeescript_cheat_sheet	Srnsep9				
abbreviations	stands4				
github_atom_mac_cheat_sheet	stanly-johnson				
groovy_cheat_sheet	stanly-johnson				
jive_talk_cheat_sheet	stanly-johnson				
military_slang_cheat_sheet	stanly-johnson				
nodejs_cheat_sheet	stanly-johnson				
opencv_cheat_sheet	stanly-johnson				
processing_lang_cheat_sheet	stanly-johnson				
toontown_cheat_sheet	Startomas				
statista	statista				
bpmto_ms	stefolof				
email_validator	stelim				
random_name	stelim				
phone_alphabet	stevelippert				
note_frequency	sublinear				
rand_pos	SueSmith				
digital_information_units_cheat_sheet	SvetlanaZem				
bash_cheat_sheet	synbit				
weekdays_between	syst3mw0rm				
asciidoc_cheat_sheet	tagawa				
atbash	tagawa				
firefox_os	tagawa				
geany_cheat_sheet	tagawa				
hipchat_cheat_sheet	tagawa				
indeed_jobs	tagawa				
japanese_prefectures_cheat_sheet	tagawa				
launch_library	tagawa				
openshot_cheat_sheet	tagawa				
switzerland	tagawa				
tennis_cheat_sheet	tagawa				
javascript_cheat_sheet	TanaLandis				
javascript_dom_cheat_sheet	TanaLandis				
iso639	tantalor				
un	tantalor				
zanran	taw				
namecheap	tejasmanohar				
minecraft_cheat_sheet	therealkbhat				
photoshop_cheat_sheet	therealkbhat				
playing_cards	therealkbhat				
radare2_cheatsheet	therealkbhat				
game_of_life_cheat_sheet	thistleBgood				
book	tihom				
nxt_account	toenu23				
rust_cargo	TomBebbington				
cusip	tommytommytommy				
route	tommytommytommy				
bbc	tophattedcoder				
haxelib	TopHattedCoder				
parcelforce	TopHattedCoder				
clojars	turbopape				
tvmaze_nextepisode	tvdavid				
tvmaze_previousepisode	tvdavid				
tvmaze_show	tvdavid				
word_map	twinword				
morse	und3f				
generate_mac	UnGround				
frequency	unlisted				
rot13	unlisted				
emoticon_cheat_sheet	vabaimova				
es6_cheat_sheet	vikashvverma				
firefox_cheat_sheet	vishwakulkarni				
name_days	w25				
abc	warthurton				
private_network	warthurton				
file_formats	whee				
ssh_cheat_sheet	wilhelm1973				
chinese_zodiac	wilkox				
convert_lat_lon	wilkox				
plural	wilkox				
reverse_complement	wilkox				
cantonese_cheat_sheet	wongalvis				
si_units_cheat_sheet	wongalvis				
weight	wongalvis				
bbcode_cheat_sheet	x-15a2				
perl6doc	xfix				
blender_cheat_sheet	xuv				
uptime	YouriAckx				
bin2unicode	zachthompson				
cheat_sheets	zachthompson				
colorado_14ers_cheat_sheet	zachthompson				
fallout_4_cheat_sheet	zachthompson				
fuel_economy	zachthompson				
the_witcher_3_cheat_sheet	zachthompson				
yoga_asanas	zachthompson				
yoga_asanas_api	zachthompson				
microsoft_windows_ten_cheat_sheet	zandips				
periodic_table	zblair				
fedora_project_package_db	zdm				
game_of_thrones_houses_cheat_sheet	zekiel				
git_cheat_sheet	zekiel				
quackhack_cheat_sheet	zekiel				
wu_tang_cheat_sheet	zekiel				
homebrew_cheat_sheet	zpalffy				
adobe_brackets_cheat_sheet	Zystvan				
