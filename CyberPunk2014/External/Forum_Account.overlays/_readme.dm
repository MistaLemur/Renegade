/*

  Version History

Version 7 (posted 06-09-2012)
 * Fixed a glitch with maptext on image objects. Every time you set the
   image's maptext it clears its maptext_width and height, so I made the
   Overlay object remember the values you set.

Version 6 (posted 05-25-2012)
 * Added the Overlay.Move() proc which moves the overlay to a new atom.
 * Got rid of the compile-time version checks to make the library work
   with pre-494 builds. If you don't have a version of BYOND that supports
   maptext, download it now!

Version 5 (posted 04-08-2012)
 * Added the RGB() proc to overlays. This proc sets an RGB value that's
   added to the overlay. The effects aren't cumulative. You can specify
   the args as a single string in the #RRGGBBAA form, or as three or
   four separate arguments (the separate RGBA components).
 * Changed the atom's overlay() proc to add a completely blank overlay
   (whose icon is null) if no parameters are specified.
 * Added the Overlay.MapText() proc as an alias of Text().
 * Updated demo\demo.dm to make use of the Text() proc.
 * Updated the maptext support to work with image-based overlays.

Version 4 (posted 03-25-2012)
 * Added the stat-bar-demo which shows how to create stat bars that
   use Overlay objects and manage how the overlay's icon_state is
   updated as values change.
 * Added the Overlay.Text() and Overlay.TextBounds() procs, which are
   used to set an overlay's maptext and maptext_width/height values.
   BYOND v494 is necessary to use maptext, but it currently doesn't
   work well with overlays (the overlay also shows an icon, even if
   you don't specify one).
 * Changed the atom.overlay() proc to support named arguments and
   added a layer parameter to it.
 * Changed how layering works for flicked overlays. When the overlays
   are created on the same layer as the mob, there may be issues. I
   recommend that you always specify a different layer for them.

Version 3 (posted 03-15-2012)
 * Added support for pixel offsets for flicked overlays.
 * Changed flicked overlay objects to have their layer set relative
   to the overlay they're being created for instead of being relative
   to the owner's layer.

Version 2 (posted 02-04-2012)
 * Added support for overlays with exclusive viewers. This means
   you can create an overlay and control exactly who can see it.
   For example, you can create a health bar overlay and only make
   it visible to yourself so that other players can't see your
   health bar.
 * Use the Overlay object's ShowTo() proc to add an exclusive
   viewer to an overlay. Use the HideFrom() proc to remove an
   exclusive viewer. If the overlay has no exclusive viewers, it
   is shown to all players (you can also use the ShowToAll() proc
   to show it to everyone).
 * Added the "show-to-demo" which contains an example of how to
   create exclusive viewers. You won't be able to notice a difference
   unless you host the demo and connect another instance of Dream
   Seeker.
 * Added the "flick-demo" which contains an example of creating and
   animating two overlays. They can be animated independently or at
   the same time.
 * Fixed a bug where updating an overlay would cause it to become
   shown, even if you had called the overlay's Hide() proc.

Version 1 (posted 01-27-12)
 * Initial post

*/