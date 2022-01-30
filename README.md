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
* E: Opens or closes Tronic Menu.
* Ctrl + S: Saves a tronic contraption in the /data/saves folder.
* Ctrl + L: Loads a tronic contraption from the /data/saves folder.
* Ctrl + I: Imports tronics from a Neverdaunt save in the /data/n8saves folder.
* Shift + Left-mouse-drag: Selects multiple tronics
* When no tronics are selected:
  * Left-click: Selects a single tronic. The menu is displayed.
  * Ctrl + Left-click: Move a single tronic.
  * Alt + Left-click: Rotate a single tronic.
* When at least one tronic is selected:
  * Alt: Hides the menu
  * Shift + Left-click: Includes the tronic in the selection.
  * Ctrl + Left-click: Moves the selected tronics.

#### Menu Controls
* Deselect: Deselects all tronics and closes the menu.
* Pick up: Moves the selected tronics.
* Delete: Deletes all selected tronics.
* Rename: Renames all selected tronics.
* Data Entry: Only available when one tronic is selected. If the selected tronic is a Data tronic, opens the Data Entry window (if not open), and connects it to the selected Data tronic.
* Decouple: Only available when more than one tronic is selected. If the selected tronics have a connected wire, the wire is deleted.

### COMPUTE Mode Controls
* Left-click: Activates a tronic, if clickable (such as Buttons or a Keyboard).
* 1, 2, 3, or 4: Activates a button within a range from the mouse's position.

## Configuration File
An editable configuration file can be found at /data/config.txt and contains the following options:
* showHints
  * If enabled, shows the controls hint in EDIT mode or the buttons hint in COMPUTE mode. Enabled by default.
  * Accepts: "true" or "false"
* author
  * Signs saves made under this name, "Default" by default.