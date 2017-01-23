Files in this directory are examples of Advanced Filters' extensible dropdown filter system.

See LevelFilters.lua for comments explaining the whole process.

See [Advanced Filters - Item Saver Filters](http://www.esoui.com/downloads/info781-AdvancedFilters-ItemSaverFilters.html) for an example of the new information generator function supported in Advanced Filters 1.4.0.0.

You may submit your filters as plugins for Advanced Filters on ESOUI.
Do this by:

1. Go to http://www.esoui.com/downloads/info245-AdvancedFilters.html
2. Click on "Other Files" between "Change Log" and "Comments"
3. Click on "Upload Optional Addon"
4. Enter all relevant information and attach a .zip file containing the folder that contains your plugin. The archive hierarchy should look something like:

        AF_MyPluginFilters-1.0.0.zip
            AF_MyPluginFilters
                AF_MyPluginFilters.txt
                AF_MyPluginFilters.lua

5. Submit

Remember to include all readme and disclaimer information required by ZOS.

Your addon manifest must look similar to the following:

    ## Title: Advanced Filters - My Plugin Filters
    ## Author: Randactyl
    ## Version: 1.0
    ## APIVersion: 100009
    ## DependsOn: AdvancedFilters Dependency1 Dependency2

    AF_ItemSaverFilters.lua

Your title should retain the leading "Advanced Filters - " in order to keep things organized in the game's addon menu.
If your addon depends on any other addon for functionality, you must include the addon name in the DependsOn line; each entry separated by a single space.
AdvancedFilters must always be included in DependsOn.