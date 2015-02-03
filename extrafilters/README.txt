LevelFilters.lua is an example of the new extensible dropdown filter system. 

Comments are included to generally explain each section.

For a simpler example, see AF_ItemSaverFilters at http://www.esoui.com/downloads/info245-AdvancedFilters.html#other

You may submit your filters as plugins for Advanced Filters on ESOUI.
Do this by:
	1. Go to http://www.esoui.com/downloads/info245-AdvancedFilters.html
	2. Click on "Other Files" between "Change Log" and "Comments"
	3. Click on "Upload Optional Addon"
	4. Enter all relevant information and attach a .zip file containing the folder that contains your plugin
		heirarchy should look something like:

			AF_MyPluginFilters-1.0.0.zip
				AF_MyPluginFilters
					AF_MyPluginFilters.txt
					AF_MyPluginFilters.lua
	5. Submit
Remember to include all readme and disclaimer information required by ZOS.

Your addon manifest must look similar to the following (example from Item Saver filter):
--[[

## Title: Advanced Filters - Item Saver Filters
## Author: Randactyl
## Version: 1.0
## APIVersion: 100009
## DependsOn: AdvancedFilters ItemSaver

AF_ItemSaverFilters.lua

]]
Your title should retain the leading "Advanced Filters - " in order to keep things organized in the game's addon menu.
If your addon depends on any other addon for functionality, you must include the addon name in the DependsOn line.
AdvancedFilters must always be included in DependsOn.