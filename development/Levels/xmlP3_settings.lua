if (exportMethod == nil) then
        exportMethod = as3.class.Array.new()
        exportMethod.push("Multi File - String Key")
        exportMethod.push("Multi File - Numerical Key")
        exportMethod.push("Single File")
end


DAME.AddHtmlTextLabel("A simple xml exporter to demonstrate a different output format. Not to be used directly but serve as an example for your own exporter.")
DAME.AddBrowsePath("Deploy Path:","DeployDir",false, "Where you place the xml files.")
DAME.AddBrowsePath("Assets Path:","AssetsDir",true, "The base directory of your image assets (optional).")

DAME.AddTextInput("Level Name", "level", "LevelName", true, "The name you wish to call this level." )
DAME.AddHtmlTextLabel("Export Method - Set for if you want a single file level or a multi file level and how multi filed levels areas should be named")
DAME.AddDropDown("Export Method", "ExportMethod", exportMethod, "Multi File group name key", "Select an export method, alters generated files" );
DAME.AddHtmlTextLabel("Name of shared asset index file; a single list of every asset in the dsf. Useful for game wide assets like the player sprite ect")
DAME.AddTextInput("Asset Index File Name", "asset_index", "SharedAssetFile", true, "Filename for shared assets, leave blank for none." )
DAME.AddCheckbox("Constants File", "isConstantFile", false, "If enabled the script creats an AS file with constants for all library items");

return 1