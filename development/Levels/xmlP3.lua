groups = DAME.GetGroups()
groupCount = as3.tolua(groups.length) -1

DAME.SetFloatPrecision(3)

tab1 = "\t"
tab2 = "\t\t"
tab3 = "\t\t\t"
tab4 = "\t\t\t\t"
tab5 = "\t\t\t\t\t"
tab6 = "\t\t\t\t\t"


MODE_MULTI_FILE_STRING = 0;
MODE_MULTI_FILE_NUMERICAL = 1;
MODE_SINGLE_FILE = 2;


deployDir = as3.tolua(VALUE_DeployDir);
assetsDir = as3.tolua(VALUE_AssetsDir);
dataDir = as3.tolua(VALUE_DataDir)
levelPre = as3.tolua(VALUE_LevelName)
isConstantFile = as3.tolua(VALUE_isConstantFile);
exportMode = MODE_MULTI_FILE_STRING;
if (as3.tolua(VALUE_ExportMethod) == "Single File") then exportMode = MODE_SINGLE_FILE end
if (as3.tolua(VALUE_ExportMethod) == "Multi File - Numerical Key") then exportMode = MODE_MULTI_FILE_NUMERICAL end
sharedAssetFile = as3.tolua(VALUE_SharedAssetFile)

exportDate = as3.tolua(os.date("%m/%d/%y %H:%M:%S"))
exportDir = deployDir.."/assets/xml/levels"

--default the assets directory if not set explicity
if (assetsDir == "") then
        assetsDir = deployDir.."/assets"
end

-- default the level name if not set explicitly
if (levelPre == "") then
        levelPre = as3.tolua(DAME.GetProjectName())
end

constantsFileText = "";
-- Prefill the constants file





-- Output tilemap data
-- slow to call as3.tolua many times.
function exportMapCSV( mapLayer, layerFileName, depth )
        -- get the raw mapdata. To change format, modify the strings passed in (rowPrefix,rowSuffix,columnPrefix,columnSeparator,columnSuffix,keywords)
        mapText = tab3.."<LAYER "
        mapText = mapText..xmlProp ("depth",depth)
        mapText = mapText..xmlProp ("name",                     as3.tolua(mapLayer.name))
        mapText = mapText..xmlProp ("tile_width",       as3.tolua(mapLayer.tileWidth));
        mapText = mapText..xmlProp ("tile_height",      as3.tolua(mapLayer.tileHeight));
        mapText = mapText..xmlProp ("rows",                     as3.tolua(mapLayer.map.heightInTiles))
        mapText = mapText..xmlProp ("cols",                     as3.tolua(mapLayer.map.widthInTiles))  
        mapText = mapText..xmlProp ("x",                        as3.tolua(mapLayer.map.x))
        mapText = mapText..xmlProp ("y",                        as3.tolua(mapLayer.map.y))     
        mapText = mapText..xmlProp ("x_unit",           as3.tolua(mapLayer.map.x) / as3.tolua(mapLayer.tileWidth))
        mapText = mapText..xmlProp ("y_unit",           as3.tolua(mapLayer.map.y) / as3.tolua(mapLayer.tileHeight))    
        mapText = mapText..xmlProp ("scroll_x",         as3.tolua(mapLayer.xScroll))
        mapText = mapText..xmlProp ("scroll_y",         as3.tolua(mapLayer.yScroll))   
        mapText = mapText..xmlProp ("tile_path",as3.tolua(DAME.GetRelativePath(assetsDir, mapLayer.imageFile)))
       
        if (as3.tolua(mapLayer.HasHits)) then mapText = mapText..xmlProp ("collide","true") end;
        -- then end
        mapText = mapText..">\n"
        mapText = mapText..as3.tolua(DAME.ConvertMapToText(mapLayer,tab4,"\n","",",",""))
        mapText = mapText..tab3.."</LAYER>\n"
        return mapText;
end

function exportObjectXML (spriteLayer, layerFileName)
        spriteName = "%spritename%"
        spriteText = tab3.."<"..spriteName..">\n"
        spriteText = spriteText..tab4.."<START x=\"%xpos%\" y=\"%ypos%\"/>\n"
        spriteText = spriteText..tab4.."<ID link_id=\"%linkid%\" guid=\"%guid%\"/>\n"
        spriteText = spriteText..tab4.."<CLASS name=\"%class%\"/>\n"
        spriteText = spriteText..tab4.."<SIZE width=\"%width%\" height=\"%height%\"/>\n"
        spriteText = spriteText..tab4.."<ROTATION deg=\"%degrees%\" rad=\"%radians%\"/>\n"
        spriteText = spriteText..tab4.."<BOUNDS x=\"%boundsx%\" y=\"%boundsy%\"  width=\"%boundswidth%\" height=\"%boundsheight%\"/>\n"
        spriteText = spriteText..tab4.."<SCROLL x=\""..as3.tolua(layerFileName.xScroll).."\" y=\""..as3.tolua(layerFileName.yScroll).."\"/>\n"
        spriteText = spriteText..tab4.."<SCALE x=\"%scalex%\" y=\"%scaley%\" />\n"
        spriteText = spriteText..tab4.."<ANCHOR x=\"%anchorx%\" y=\"%anchory%\"/>\n"
        spriteText = spriteText..tab4.."<PROPS>"
        propText = "%%proploop%%\n"..tab6.."<%propname%>%propvalue%</%propname%>%%proploopend%%\n"
        --propText =  as3.tolua(DAME.GetTextForProperties( groupPropertiesString, group.properties, groupPropTypes )).."\n"
        spriteText = spriteText..tab5..propText
        spriteText = spriteText..tab4.."</PROPS>\n"
        spriteText = spriteText..tab3.."</"..spriteName..">\n"
        returnText = as3.tolua(DAME.CreateTextForSprites(layerFileName,spriteText,"Entity"))
        return returnText;
        --return creationText;
end

function exportShapeXML (shapeLayer)
        shapeText ="";
        boxText = "";
        circleText = "";
        textboxText = "";
        boxText = "<RECT>\n"
        boxText = boxText..tab4.."<START x=\"%xpos%\" y=\"%ypos%\"/>\n"
        boxText = boxText..tab4.."<SIZE width=\"%width%\" height=\"%height%\"/>\n"
        boxText = boxText..tab4.."<ROTATION deg=\"%degrees%\" rad=\"%radians%\"/>\n"
        boxText = boxText..tab4.."<ID link_id=\"%linkid%\" guid=\"%guid%\"/>\n"
        boxText = boxText.."</RECT>\n"
        circleText = "<CIRCLE>\n"
        circleText = circleText..tab4.."<START x=\"%xpos%\" y=\"%ypos%\"/>\n"
        circleText = circleText..tab4.."<SIZE radius=\"radius\" width=\"%width%\" height=\"%height%\"/>\n"
        circleText = circleText..tab4.."<ID link_id=\"%linkid%\" guid=\"%guid%\"/>\n"
        circleText = circleText.."</CIRCLE>\n"
        shapeText = as3.tolua(DAME.CreateTextForShapes(shapeLayer, circleText, boxText, textboxText ))
        return shapeText;
end

function exportLinkXML ()
        returnText= "";
        linkText = tab4.."<LINK link_from=\"%linkfromid%\" link_to=\"%linktoid%\" link_from_str=\"%getlinkfromstr%\" link_to_str=\"%getlinktostr%\"/>\n"
        returnText = as3.tolua(DAME.GetTextForLinks(linkText));
        return returnText;
end



function exportClassResourcePathsXML ()
        spriteName = "%name%"
        spriteText = tab2.."<"..spriteName.." path=\"%imagefilerelative%\""..">\n"
        spriteText = spriteText..tab3.."<SIZE width=\"%width%\" height=\"%height%\"/>\n"
        spriteText = spriteText..tab3.."<BOUNDS x=\"%boundsx%\" y=\"%boundsy%\" width=\"%boundswidth%\" height=\"%boundsheight%\"/>\n"
        spriteText = spriteText..tab3.."<ANCHOR x=\"%anchorx%\" y=\"%anchory%\"/>\n"
        spriteText = spriteText.."%%if spriteanims%%"..tab3.."<ANIMS>\n"
        spriteText = spriteText.."%%spriteanimloop%%"..tab4.."<ANIM animnum=\"%animnum%\" fps=\"%fps%\" name=\"%animname%\" numframes=\"%numframes%\" looped=\"%looped%\" frames=\"%%animframeloop%%%tileid%%separator:,%%%animframeloopend%%\"/>\n %%spriteanimloopend%%"
        spriteText = spriteText..tab3.."</ANIMS>\n %%endif spriteanims%%"
        spriteText = spriteText..tab2.."</"..spriteName..">\n"
        returnText = as3.tolua(DAME.CreateTextForSpriteClasses(spriteText,spriteText,"","","","",null,assetsDir));
        return returnText;
        --return creationText;
end

function exportConstantFile()
        constantTemplate = "\t\t public static const %name% :String = '%name%' \n"
        returnText =as3.tolua(DAME.CreateTextForSpriteClasses(constantTemplate,constantTemplate,"","","","",null,assetsDir));
        return returnText;
end

function exportTilemapResourcePathsXML ()
        returnText = tab2.."<!--TILEMAPS"..table.getn(tilePaths).."-->\n";
        for k in pairs(tilePaths) do
                returnText = returnText..tab2.."<".."TILE_MAP".." path=\""..k.."\"/>\n"
        end
        return returnText;
end

function xmlProp (prop, value)
        propStr = prop.."=\""..value.."\" ";
        return propStr
end

-- ####################################################
-- BEGIN REAL FILE BUILIDING HERE
-- ####################################################
-- This is the file for the map level class.


levelMetaData = xmlProp("source",as3.tolua(levelPre))..xmlProp("date", exportDate)
if (sharedAssetFile ~= "") then levelMetaData = levelMetaData..xmlProp("sharedAssets", sharedAssetFile) end



areaIndexText = tab1.."<INDEX>\n"
       
assetText = tab1.."<ASSETS>\n"..exportClassResourcePathsXML()..tab1.."</ASSETS>\n";
--assetText = assetText..exportTilemapResourcePathsXML();

outputText = "";
levelFileText = "";

for groupIndex = 0,groupCount do


        indexName = "";
        groupText = "";
       
        maps = {}
        spriteLayers = {}
        shapeLayers = {}

        masterLayerAddText = ""
       
        group = groups[groupIndex]
       
        groupName = as3.tolua(group.name)
        groupName = string.gsub(groupName, " ", "_")
       
        indexName = groupName
        if (exportMode == MODE_MULTI_FILE_NUMERICAL) then indexName = "group_" groupdIndex.toString() end
        if (exportMode == MODE_MULTI_FILE_STRING) then indexName = groupName end
       


       
        areaIndexText = areaIndexText..tab2.."<AREA>"..indexName.."</AREA>\n"
       
        layerCount = as3.tolua(group.children.length) - 1
       
        groupText = tab1.."<AREA ".."key=\""..indexName.."\" >\n"
       
        -- Go through each layer and store some tables for the different layer types.
        for layerIndex = 0,layerCount do
                layer = group.children[layerIndex]
                isMap = as3.tolua(layer.map)~=nil
                layerSimpleName = as3.tolua(layer.name)
                layerSimpleName = string.gsub(layerSimpleName, " ", "_")
                layerName = groupName..layerSimpleName
                if isMap==true then
                        table.insert(maps,{layer,layerName})
                elseif as3.tolua(layer.IsSpriteLayer()) == true then
                        table.insert( spriteLayers,{indexName,layer,layerName})
                elseif as3.tolua(layer.IsShapeLayer()) == true then
                        table.insert(shapeLayers,{indexName,layer,layerName})
                end
        end

        --TILEMAPS
        groupText = groupText..tab2.."<LAYERS>\n"
        for i,v in ipairs(maps) do
                groupText = groupText..exportMapCSV( maps[i][1], maps[i][2], i -1 )
        end
        groupText = groupText..tab2.."</LAYERS>\n"

        --OBJECTS/SPRITES
        groupText = groupText..tab2.."<OBJECTS>\n"
        for i,v in ipairs(spriteLayers) do
                print(spriteLayers[i][1].children);
                groupText = groupText..exportObjectXML(spriteLayers[i][1],spriteLayers[i][2]);
        end
        groupText = groupText..tab2.."</OBJECTS>\n"
       
        --SHAPES
        groupText = groupText..tab2.."<SHAPES>\n"
        for i,v in ipairs(shapeLayers) do
                groupText = groupText..exportShapeXML(shapeLayers[i][2]);
        end
        groupText = groupText..tab2.."</SHAPES>\n"
       
        --LINKS
        groupText = groupText..tab2.."<LINKS>\n"
        groupText = groupText..exportLinkXML();
        groupText = groupText..tab2.."</LINKS>\n"
       
        --GROUP PROPERTIES
        layerProps = "%%proploop%%\n"..tab2.."<%propname%>%propvalue%</%propname%>%%proploopend%%\n"
        groupText = groupText..tab2.."<PROPS>"
        groupText = groupText..as3.tolua(DAME.GetTextForProperties(layerProps, group.properties));
        groupText = groupText..tab2.."</PROPS>\n";
       
        groupText = groupText..tab1.."</AREA>\n"
       
        levelHeaderText = "<LEVEL "
        levelHeaderText = levelHeaderText..xmlProp("key",as3.tolua(indexName))..levelMetaData
        levelHeaderText = levelHeaderText..">\n"

        -- Save the file!
        if (exportMode == MODE_SINGLE_FILE) then
                levelFileText = levelFileText..groupText;
        else
                levelFileText = groupText
                DAME.WriteFile(exportDir.."/"..levelPre.."/"..indexName..".xml", levelFileText )
        end

end

areaIndexText = areaIndexText..tab1.."</INDEX>\n"

if (exportMode == MODE_SINGLE_FILE) then
        if (sharedAssetFile ~= "") then
                levelFileText = levelHeaderText..areaIndexText..levelFileText.."</LEVEL>\n"
        else
                levelFileText = levelHeaderText..areaIndexText..levelFileText..assetText.."</LEVEL>\n"
        end
else
        if (sharedAssetFile ~= "") then
                levelFileText = levelHeaderText..areaIndexText.."</LEVEL>\n"
        else
                levelFileText = levelHeaderText..areaIndexText..assetText.."</LEVEL>\n"
        end
end
               
if (sharedAssetFile ~= "") then
        DAME.WriteFile(exportDir.."/"..sharedAssetFile..".xml", assetText )
end

if (isConstantFile) then
        header =  "// script generated file \n" .. "package assets\n { \n" .. "\t public class AssetConst \n\t{\n"
        constantsFile = header..exportConstantFile().."\n\t}\n}"
        DAME.WriteFile(assetsDir.."/".."AssetConst.as", constantsFile )
end

DAME.WriteFile(exportDir.."/"..levelPre..".xml", levelFileText )

return 1
  