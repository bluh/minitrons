# minitrons-remake
## Concept
Minitrons is a remake of Tronics from the MMO, [Neverdaunt:8Bit](http://8bit.neverdaunt.com).

## Controls
By default, not moving your mouse for a short time while in COMPUTE mode will show a quick hint that describes the most basic controls. The following is a complete list of controls.

### Non-specific Controls
* Right-click: Pan the screen.
* Mouse-wheel: Zoom in or out.
* R: Centers the screen.
* C: Clears all tronics.
* Space: Switches from COMPUTE to EDIT mode or EDIT to COMPUTE mode.
 
### EDIT Mode Controls
* Left-click: Displays the menu on a single tronic.
* Shift + Left-click: Includes the clicked-on tronic in the menu (used to decouple two wires).
* Ctrl + Left-click: Moves the selected tronics or the just clicked-on tronic (if none are selected).
* Alt + Left-click: Rotates the clicked-on tronic.
* E: Opens or closes the Tronic menu.
* Ctrl + S: Saves a tronic contraption in the /data/saves folder.
* Ctrl + L: Loads a tronic contraption from the /data/saves folder.

### COMPUTE Mode Controls
* Left-click: Activates a tronic, if clickable (such as Buttons or a Keyboard).
* 1, 2, 3, or 4: Activates a button within a range from the mouse's position.

## Configuration File
An editable configuration file can be found at /data/config.txt and contains the following options:
* showHints
  * If enabled, shows the controls hint in EDIT mode or the buttons hint in COMPUTE mode. Enabled by default.
  * Accepts: "true" or "false"
