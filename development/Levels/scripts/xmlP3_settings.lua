-- Display the settings for the exporter.
DAME.AddHtmlTextLabel("A simple xml exporter to demonstrate a different output format. Not to be used directly but serve as an example for your own exporter.")
DAME.AddBrowsePath("Xml dir:","DataDir",false, "Where you place the xml files.")

DAME.AddTextInput("Level Name", "level", "LevelName", true, "The name you wish to call this level." )
DAME.AddHtmlTextLabel("Group Names - Export each area of the level using the name of the group. <br> Make Level Index - Builds an index file referancing all the areas.")
DAME.AddCheckbox( "Use Group Names" , "UseGroups" , true, "Select this if you want files to be named by group name rather than sequentially" )
DAME.AddCheckbox( "Make Level Index" , "MakeIndex" , true, "Select this if you want files to be named by group name rather than sequentially" )

return 1
