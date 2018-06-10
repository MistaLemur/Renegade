DREAM SEEKER STANDALONE CUSTOMIZATION GUIDE

When creating a standalone Dream Seeker instance of your game, you have
several options available for customizing the initial splash screen and
making the user experience fit the style of the game. The standalone
.exe is bundled with some pre-made config files, and others you provide,
to create hubstub-out.html which is the file the user will see. All the
files will go in the skin directory for your game.

These are the files you can change:

	hub.ini - Sets some basic preferences
	hub.html - Content for the file
	hub.css - CSS styles

	live.css - CSS styles for some pages on byond.com
	livetest.html - A file where live.css settings can be tested

All changes you make to the HTML should be done to the hub.html file, and
styles to the hub.css file. The contents of hub.html will be inserted into
the file that the user sees. CSS can be used to show or hide various
interface elements that may be optional.

You can include your own scripts if needed via hub.html. jQuery 1.4.2 is
included among our JavaScript code and is available for you.

You can include any image files you want, so if you have an image with
src=button.gif then it will use the button.gif file in the skin directory
where all the other files are copied. These can also be used in hub.css to
dress up parts of your interface, like replacing the "Join" button for a
world with a button image of your choosing.

Keep in mind the splash popup will be displayed in an embedded browser which
uses Internet Explorer.


RESOURCES AND LOCAL INSTALLATION

Including an .rsc file in your distribution will cause that file to be
auto-loaded into the user's cache each time they play. If you set preload_rsc
to a URL, this will also be assumed to be the current valid file and
therefore preload_rsc will be ignored, avoiding an unncessary download; if
your live servers later change the preload URL, the change will be detected
and the locally installed .rsc file will be replaced with the newly
downloaded version. See HUB.INI SETTINGS below for more details.

To cause the game to be installed locally, you can include a file called
hub.zip. This file should be identical to the regular download package that
BYOND users would see on your hub page: In other words, it should be packaged
by Dream Maker so it includes your .dmb and .rsc files, plus any additional
files that are required. When the program runs, hub.zip will be unzipped and
installed, then erased to avoid needless re-installs.


HUB.INI SETTINGS

The hub.ini file allows you to set certain behavior for your project. The
file is laid out in plain text, where each line is NAME = VALUE. The settings
you can change are:
	
	WindowSize
		Specify the size of the window; format is [width]x[height]
	Name
		Name of your game (used if online info is not accessible)
	RequireUpdate
		false: always optional (default)
		true: force the user to update to newer versions even if the BYOND
		      version is still compatible
		auto: force the upgrade, and don't present an ok/cancel option
	LoginFirst
		false: Login screen does not pop up (default)
		true: User automatically logs with the last account they used, or login
		      screen pops up if password was not saved
	LoginOptional
		false: Attempting to join a game before logging in will pop up the login
		       box (default)
		true: Login is not required; user will login automatically as guest if
		      they don't login manually.
	NoGuest
		false: Guest logins are allowed (default)
		true: Do not allow guest logins (disables LoginOptional setting)
	SkipSplash
		false: Always start on the splash screen (default)
		true: If LoginOptional is also true, this will bypass the splash screen
		      entirely and immediately start a locally installed copy of the game.
		      If you want the user to be able to login, this setting is not
		      recommended; instead, a simple "Start Game" button leading to
		      byond://[hub path]##local may be preferable.
		launch: Start on the splash screen, but launch all games in a separate
		        instance and leave the main splash up.
	PreloadRscUrl
		If you set preload_rsc to a URL, this will keep a copy of the last
		URL seen. If you don't set this in hub.ini, it will be added the
		next time preload_rsc is seen and any .rsc file you have in your
		distribution will be assumed to be correct. If preload_rsc changes in
		the future, the .rsc from your distribution will be replaced with the
		new copy and this field will be updated to the new URL.
		NOTE: The "Clear Cache" button in the preferences box will also
		delete your local .rsc file and remove this field if the field is
		present, on the assumption that the user wants to download a fresh
		copy. Otherwise .rsc files in the distribution will be left alone.
	IsServer
		false: User always logs in with their own account or as guest (default)
		true: When a user starts a local game on Dream Seeker, their first login
		      is as host@localhost. This means they can login by launching a second
		      instance, using their normal account, without a conflict. This can be
		      useful for games where you want to setup dedicated servers and design
		      an admin control panel directly in the game.
	CommandLine
		Any additional command line options to use. For example:
		CommandLine = -threads off

		Command line options that may be useful:
		-threads off
		-map-threads off  (turn off map threads only)
		-isserver (host logs in as "host@localhost" to avoid account conflict if
		           they login as a player separately)


HUB.HTML

The contents of hub.html will be placed inside the #page_content div. This
should include basically all of your custom content.

Some items you can include here are:

	<div id="hub_live"></div>

		Include this to get a list of all live servers. The contents of the
		list will be placed here. This is present in the default file.

	<div id="hub_local"></div>

		Include this to show a local installation if it is present.

		Customize some of the look of this div by replacing the
		local_options var.

	<div id="hub_local_servers"></div>

		This will be filled in with a list of custom local servers created
		with the New Server dialog. They can have a different path from the
		normal local installation.

		Customize some of the look of this div by replacing the
		local_options var.

	<div id="hub_choice"></div>

		This div fills in with what looks like a world to join, but its Host
		button (in place of Join) shortcuts to the pager://choose_server
		link to bring up the New Server dialog. Users can then create a new
		local server with a custom install path (see hub_local_servers
		above).

		Customize some of the look of this div by replacing the host_options
		var.

	<span id="sub_time"></span>

		If you include this, it will be filled in with the subscription time
		remaining for the current user. See SUBCRIPTION CHECKING below.


HUB.CSS

All styles should be specified in hub.css. The default file includes a basic
set of styles you can change, some of which are explained below.

	MAIN PAGE

	body
		The page body. Do not give this style a width and height.
	#content
		A container div just inside the <body> tag
	#page_content
		The portion of the page containing hub.html; scrolls if needed

	#login
		The login links, usually at the top of the page. This section shows
		the user's current key and a logout link, or else it shows a login
		link. A link to open the client preferences page is also here.
		This div is inside #content, but not inside #page_content.

	.launched
		This class is given to the <body> element if this instance was
		launched by another one via SkipSplash = launch in the hub.ini file.
		The default hub.css will hide the #page_content and #login divs in
		this situation and always shows #progress. If you want a more
		nuanced approach, you should define your own styles as needed.

	LOGIN FORM	

	#loginform
		The div holding the form used for logins
	#loginbackground
		A placeholder div for a splash image for your login screen
	.logintext
		A general class used for all text within the login box
	.loginbox
		A div with everything within #loginform except for #loginbackground
	.loginheader
		The header message div, with text "Select an account to login."
	.loginmessage
		The message div containing a response to the last login attempt, e.g.
		"Invalid login".
	.login_usermessage
		A div that can contain a custom user message, set via the
		login_usermessage var in JavaScript.

	.saved
		This class is applied to the #loginform div when the user has
		selected a key from their list.
	.guest
		This class is applied to the #loginform div when the user has chosen
		the Guest key.
	.other
		This class is applied to the #loginform div when the user is entering
		a new key.

	.logincontent
		A div containing the rest of the login form, which includes all the
		divs in this section (below).
	.account_text
		The word "Account"
	.account_input_content
		A div wrapped around the select box for accounts, and the "other"
		fill-in box where a user can type in a new name.
	select.account_input
		The selection box for a user's accounts
	input.account_input
		The "other" fill-in box
	.create_account
		A link to create a new account
	.manage_account
		A link to manage the currently selected account
	.password_text
		The word "Password"
	.password_input
		The input field for the password
	.forgot_password
		A link to reset your password if you forget it
	.save_password
		A checkbox asking whether the password should be saved
	.save_account
		A checkbox asking whether the account should be saved for offline use
	.delete_account
		A link to delete the account from the list
	.login_button
		The div containing the login button
	.loginbutton
		The login button itself; its text is "Login".

	PREFERENCES BOX

	#prefspop
		The outer div controlling the whole box
	#prefsbackground
		A placeholder for a splash image
	.prefsbox
		A div around the inner contents
	#prefstitle
		A paragraph element containing the text "Preferences"
	#prefsform
		The form used for user preferences
	.close_button
		A blank link (no text) inside .prefsbox that can be used for a close
		button
	.prefs_button
		Any of the buttons in the preferences box
	.byond_dir_button
		The button for the BYOND data dir setting
	.clear_cache_button
		The button to clear the cache

	ABOUT BOX

		Please note: It is important to display BYOND's credits for legal
		reasons, but you are free to add special hover or collapse/expand
		effects as you wish.

	#aboutpop
		The outer div containing the whole box
	#aboutbackground
		A placeholder for a splash image
	.aboutbox
		A div around the inner contents
	#abouttitle
		A paragraph element containing the text "About [name]", where the
		name comes from your hub info, or from the Name field in hub.ini as a
		fallback; or, this is filled in via the about_title var
	#aboutdesc
		A div containing a your game's credits, filled in by the about_desc
		var
	#aboutall
		A div containing BYOND's info and credits (below)
	#aboutbyondlogo
		A div for the BYOND logo, and containing a link
		Disabled by default
	#aboutbyond
		A div for a "Made with BYOND" link.
	#aboutlibs
		A div for the libraries used by BYOND
	#aboutversion
		A div containing a your game's full version
	#aboutcopyright
		A div containing a your game's copyright, filled in by the
		about_copyright var
	.close_button
		A blank link (no text) inside .aboutbox that can be used for a close
		button

	PROGRESS BAR
	
		The progress bar is contained inside #content, but not #page_content.

	#progress
		The progress bar; will be hidden when no message displays
	#progressmessage
		Any text displayed in the progress bar
	#progressbar
		The filled-in part of the progress bar indicating current progress;
		width is changed via script automatically. Set the background color
		to change its color, or you can give it a background image instead.

	LIVE AND LOCAL GAMES

	.title
		"N games live" for live game listings, in #hub_live div
	.world
		An individual world in the live game listings
	.join
		A div that contains the join link for a world
	.join a
		The join link itself
	.status
		World status
	.player_total
		The total number of players
	.player
		A span that goes around a player name link
	.private
		A class that goes around the number of private users

	LOGIN AND SUBSCRIBER STATUS

		These styles do not apply to the login form.

	.logged_in
		Applied to the body tag if the user is logged in
	.subscriber
		Applied to the body tag if the current user is a subscriber
	.non_subscriber
		Applied to the body tag if the current user is logged in but not subscribed
	.finite_subscriber
		Applied to the body tag if the current user is subscribed but not for life
	.lifetime_subscriber
		Applied to the body tag if the current user is subscribed for life


SUBSCRIPTION CHECKING

To send a user to your subscription page, create a link with an href of
pager://subscribe or pager://subscribe?gift=1 (for gift subscriptions).

You can check subscription status by calling subscription_status() at any
time. This is also done on login.

The following will happen when subscription info is checked:
	
	- The .subscriber, .non_subscriber, .finite_subscriber, and
	  .lifetime_susbcriber classes will be applied to the <body> tag as
	  needed.

	- The amount of time left in the subscription will be filled in for
	  the HTML element with id="sub_time", if one exists.

	- Your user-defined subscriber_info() function will be called if you
	  have setup a script for one. The argument is a simple object which
	  may have the following properties:


If you want to display different messages depending on subscription status,
you can define styles for them in hub.css like so:
	
	.life_subscriber_info {display: none}
	.lifetime_subscriber .life_subscriber_info {display: block}
	.finite_subscriber_info {display: none}
	.finite_subscriber .finite_subscriber_info {display: block}
	.non_subscriber_info {display: none}
	.non_subscriber .non_subscriber_info {display: block}

Then you can have the appropriate messages in hub.html:
	
	<div class="lifetime_subscriber_info">
		You are subscribed for life! Why not give a
		<a href="pager://subscribe?gift=1">gift subscription</a> to a
		friend?
	</div>
	<div class="finite_subscriber_info">
		Your subscription is good for <span id="sub_time"></span>.
		You can <a href="pager://subscribe">renew</a> it at any time.
	</div>
	<div class="non_subscriber_info">
		Want even more fun in [GAME]?
		<a href="pager://subscribe">Subscribe today</a> for bonus
		features!
	</div>


USEFUL LINKS

	pager://about
	
		Open the about dialog.

	pager://prefs
	
		Open the preferences form.

	pager://subscribe
	
		Open a subscription page for your game.

	pager://choose_server
	
		Open a dialog asking the player to define a new local server. The hub.zip
		file is required; its contents will be stored in the path specified.

	byond://[hub path]##local

		Begin a locally installed game (see hub.zip in RESOURCES AND LOCAL
		INSTALLATION above)


JAVASCRIPT VARIABLES

	current_key
	
		This holds the current logged-in account, or is empty or undefined otherwise.

	launched

		True if this instance was launched by another one (via SkipSplash = launch in
		hub.ini).

	live_games

		This is filled in by the BYOND hub and returns info about the hub entry and
		any live games. It contains these properties:

		hub: An object with the hub entry info, with these properties:
			name
			author
			path
			url: URL of hub page
			icon
			small_icon
			banner
			created
			upgrade: upgrade URL, if any
			version: regular hub version
			skin_version (used to check if the distributed build should be upgraded)
		count: Number of live games
		title: "N Games Live!"
		worlds: An array of world objects, each with these properties:
			id
			url
			status
			host
			players_title: "N Players Online" or "No Players"
			total_players: Total number of players
			players: Array of player names (non-private, non-guest)
			guests: Number of private/guest players

		When live_games is sent back by the BYOND hub, fill_live() will be
		called. You can override this if you want to build the worlds
		yourself.

	local_servers

		This holds an array of locally installed servers (besides the main
		one) that were created via the New Server dialog. Each item in the
		list is an object with the properties "status" and "url", much like
		the worlds in live_games.

		The local() function is called when this is updated.


HELPER FUNCTIONS

	joinurl(url)
		Convert a URL (could also be a local .dmb file) to something that
		can be used on a Join button. You shouldn't need this unless you're
		building the world display yourself.

	fill_world(container, world)
		Given a container div, fill it with the world info. The world is an
		object with properties like status, url, players, etc. just like the
		worlds in live_games (see above).

	getsaved(name)

		Returns a named value found in saved_info, which holds info saved on
		the local system. This is equivalent to saved_info[name] unless you
		override the function.

		If the data exists, it will be returned as a string. Keep this in
		mind if you need to do any math with a number. If the data does not
		exist or was an empty string, it's returned as undefined.

	setsaved(name, value)
	setsaved(object)

		Saves data locally for later use, in name/value pairs. The value
		should be a string or number; it will be saved as a string.

		If you use an object, every name/value pair in that object will be
		saved. For example:

		setsaved({favorite: 'blue', nickname: 'Lancelot'})


USER-DEFINED FUNCTIONS AND VARIABLES

Your scripts in hub.html can override certain default behavior.

	about_copyright
	
		Custom text for the #aboutcopyright div in the about box. HTML is
		allowed.

	about_desc
	
		Custom text for the #aboutdesc div in the about box, used for a game
		description. HTML is allowed.

	about_title
	
		Custom title text for the #abouttitle div in the about box. HTML is
		allowed. By default this will be "About [name]", where the name is
		taken from Name in hub.ini or from your hub entry itself.

	disconnected(message)

		Called when a connection attempt to a server fails. This can allow
		you to respond when a user tries to join a server but can't connect.

	frame_options
	
		An object containing parameters used by the new account and forgot
		password popups. The parameters are as follows:
		
		width
		height
			The size of the frame or the outer page (in pixels).
		actual_size
			True if the width/height are for the frame, false if they
			represent the outer page's size. If false, the actual
			width/height will be a percentage of the page size.

	host_options

		An object with parameters for displaying the New Server option. See
		local_options for more info. These are the params that are most
		important:

		status
			Says "Choose a server to host" by default
		join
			Join button text, defaults to "Host"

	login_usermessage
	
		Set this var to insert custom text into the login box, which will go
		in the #login_usermessage div. HTML is not allowed.

	local_options

		An object with parameters for displaying a locally installed game,
		including servers with custom install paths. These are the parameters:

		status
			The status line (custom servers override this); normally "Local
			game"
		join
			The Join button text (normally "Join")

	saved_info

		An object with user-defined parameters and values, all of which are
		strings. This provides data that was saved with setsaved(), and can
		also be read via getsaved(). The saved_info_updated() function is
		called whenever this is filled in with new information.

	user_login(key)
	
		This is called after logging in with a key.

	user_logout()

		This is called after a user logs out.

	user_login_failed(message)

		This is called when a user attempts to login but the login fails.

	subscriber_info(results)
	
		The results argument is a JavaScript object that may contain any of
		the following values:

		key: Key of the user being checked
		byond_member: Status of user's Membership
		subscribed: Status of user's subscription
		time_left: Subscription time left in text form
		days_left: Subscription time left in days, rounded up; -1 is lifetime
		seconds_left: Subscription time left in seconds; -1 is lifetime

		The results.time_left value used to fill in an element with the ID
		"sub_time", if you have one in hub.html.

	upgraded()

		This function is called after an upgrade has completed successfully.

	local(hubpath, url)

		Fills in the hub_local div, and also hub_local_severs and hub_choice. This
		is called at startup and also whenever the list of local servers updates.
		You can override it to handle these yourself.

	fill_live()

		Called when live_games is sent back by the hub. Use as-is or override to
		handle this yourself.

	saved_info_updated()

		Called when the saved_info var is filled in with any new info. Use this to
		make any updates you need to when responding to changes.



LIVE.CSS, LIVE.HTML, and LIVETEST.HTML

For customizing the look of online pages like new account creation and the
forgot-password page to match your style, you can setup custom stylesheets.

To customize your subscription page, you will need to edit your hub entry on
BYOND using the Distribution tab.

If this is the first time using livetest.html, open it in a text editor
and insert your hub path in the top JavaScript section.

Now open livetest.html in your browser to customize the look of the online
pages. Fill in the values you want to try for CSS, and click one of the links
below. You will see a preview of what the result looks like.
	
To use the CSS, copy your finished CSS into a file called live.css that will
be in your hub's skin directory, or you can edit this in your hub entry
settings online instead.

Pro tip: In most browsers you can download an add-on that shows you the
content of the page, so you can see what CSS classes and IDs you will be
working with when making changes. For example, Firefox users can download the
Firebug add-on. Although the pages as seen here will ultimately be displayed
in an embedded instance of Explorer, you can still use this method for
rough-draft testing in the browser of your choice.

	Example use:
	
	1) When you have setup the installation files for your game, you'll
	   have a set of directories like cfg, skin, and bin. Put livetest.html
	   anywhere that it won't be included in your distribution.

	2) Open the file in a text editor and put in your hub path at the top
	   of the JavaScript section.

	3) Open the livetest.html file in a browser. Type in the same window
	   size you set in hub.ini, and then enter some CSS options.

	   Example CSS:

	   body, .big_box {color: red}

	4) Click the links below to see how these pages will look.

	5) When you're happy with the results, copy the content into live.css
	   and distribute it in the skin directory for your game.

