Usage: byondexe [config = byondexe.ini]

In byondexe.ini, the following options can be set as name = value pairs:

key = [text]
  Mandatory: This is a game-specific key that must be requested from the BYOND Staff.

byond = [dir]
  Mandatory: This points to the byond bin dir (which contains dreamseeker.exe, byondcore.dll,
             etc).  Some of these files will be repurposed and distributed with the exe.

include = [dir1,dir2,etc]
  Mandatory: The files in these directories will be embedded and distributed with your exe.
             Resource files (.rsc) may be included, and those will be handled specially by
             the client to import upon first load. 

             The directories are included in order, with duplicate files from later
             directories overriding those in earlier ones.  


exe = [file.exe]
  Mandatory: This is the name of the exe to create, typically [out].exe.  The version placed in the 
             current directory is an "installerless" distributable that can be given to other users to 
             run the game.  On first run, it will unpack the actual exe in the BYOND user folder and run
             that.  


out = [dir]
  Optional: This is the output directory that will be redistributed if you use the 'install' option below 
            (it is a required option if you use 'install', optional otherwise).
            The exe within can be run upon creation for testing purposes.

            When using the installer, this directory will the default name for your game (typically written as
            "../Program Files/[out]".

update = [file.zip]
  Optional: This is a zip of the output directory, with the special exception that the included
            exe will _not_ contain .rsc files (the idea being that .rsc files should only be 
            initialized with the official installation and not with updates; see below).  

            This zip file is suitable for use with the "Update URL" option on the associated
            website hub entry.  When the "Hub Version" field exceeds the HubVersion of the 
            user's exe, the update will be applied.  See below for more on versioning.

install = [file.exe]
  Optional: This is the name of the installer file created by NSIS, suitable for distribution
            to other users.  NSIS must exist on the current machine (download at:                             http://nsis.sourceforge.net).  Additionally, the file 'install.nsh' 
            (distributed with this package) must be present in the same dir 
            that the byondexe.ini resides.

            This creates an NSIS file called [exe].nsi that is compiled with NSIS to package 
            the [out] dir according to the rules in the .nsh files (which can be modified for
            custom installations). 

icon = [file].ico]
  Optional:  This .ico file will be used for the executable.

company = [text]
  Optional: This is embedded in the version info for the exe.

product = [text]
  Optional: This is embedded in the version info for the exe..

version = [text]
  Optional: This is embedded in the version info for the exe.
            
            The version should be of the form: Major.Minor.Build.HubVersion XXXX, where
            XXXX can be any text (like "beta").  Only the HubVersion is important as far as
            BYOND is concerned; it is used to sync with the "Hub Version" field on the website
            hub entry for updates.

See the included byondexe.ini for examples.

*** Notes on version information ***

All version information is updated through the included third-party 'verpatch.exe'.  This must be present
in the same directory as byondexe.exe in order to update the versioning.  Further information on this 
tool may be found at http://www.codeproject.com/Articles/37133/Simple-Version-Resource-Tool-for-Windows.

*** Notes on configuration files ***

Included in the distribution is a cfg/ folder with a default hub.html file that you should override to
create a custom "skin" for your game. This should always be packaged with the exe 
via the "include" directive above. 

Consult the README-CONFIG.txt file for more information on the files that may be configured.
