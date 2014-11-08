

groups = DAME.GetGroups()
groupCount = as3.tolua(groups.length) -1

DAME.SetFloatPrecision(0)

tab1 = "\t"
tab2 = "\t\t"
tab3 = "\t\t\t"
tab4 = "\t\t\t\t"
tab5 = "\t\t\t\t\t"

dataDir = as3.tolua(VALUE_DataDir)
levelPre = as3.tolua(VALUE_LevelName)
useGroups = as3.tolua(VALUE_UseGroups);
useIndex = as3.tolua(VALUE_MakeIndex);

-- Output tilemap data
-- slow to call as3.tolua many times.

function exportMapCSV( mapLayer, layerFileName, depth )
	-- get the raw mapdata. To change format, modify the strings passed in (rowPrefix,rowSuffix,columnPrefix,columnSeparator,columnSuffix,keywords)
	mapText = tab2.."<LAYER " 
	mapText = mapText..xmlProp ("depth",depth)
	mapText = mapText..xmlProp ("name",as3.tolua(mapLayer.name))
	mapText = mapText..xmlProp ("tile_width", as3.tolua(mapLayer.tileWidth));
	mapText = mapText..xmlProp ("tile_height",as3.tolua(mapLayer.tileHeight));
	mapText = mapText..xmlProp ("rows",as3.tolua(mapLayer.map.heightInTiles))
	mapText = mapText..xmlProp ("cols",as3.tolua(mapLayer.map.widthInTiles))
	mapText = mapText..xmlProp ("sf_x",as3.tolua(mapLayer.xScroll))
	mapText = mapText..xmlProp ("sf_y",as3.tolua(mapLayer.yScroll))
	mapText = mapText..">\n"
	mapText = mapText..as3.tolua(DAME.ConvertMapToText(mapLayer,tab3,"\n","",",",""))
	mapText = mapText..tab2.."</LAYER>\n"
	return mapText;
end

function exportObjectXML (spriteLayer, layerFileName)
	spriteName = "%spritename%"
	spriteText = tab2.."<"..spriteName..">\n" 
	spriteText = spriteText..tab3.."<START x=\"%xpos%\" y=\"%ypos%\"/>\n"
	spriteText = spriteText..tab3.."<ID link_id=\"%linkid%\" guid=\"%guid%\"/>\n"
	spriteText = spriteText..tab3.."<CLASS name=\"%class%\"/>\n"
	spriteText = spriteText..tab3.."<SIZE width=\"%width%\" height=\"%height%\"/>\n"
	spriteText = spriteText..tab3.."<ROTATION deg=\"%degrees%\" rad=\"%radians%\"/>\n"
	spriteText = spriteText..tab3.."<ANCHOR x=\"%anchor_x%\" y=\"%anchor_y%\"/>\n"
	spriteText = spriteText..tab3.."<PROPS>"
	propText = "%%proploop%%\n"..tab5.."<%propname%>%propvalue%</%propname%>%%proploopend%%\n"
	--propText =  as3.tolua(DAME.GetTextForProperties( groupPropertiesString, group.properties, groupPropTypes )).."\n"
	spriteText = spriteText..tab4..propText
	spriteText = spriteText..tab3.."</PROPS>\n"
	spriteText = spriteText..tab2.."</"..spriteName..">\n"
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
	boxText = boxText..tab3.."<START x=\"%xpos%\" y=\"%ypos%\"/>\n"
	boxText = boxText..tab3.."<SIZE width=\"%width%\" height=\"%height%\"/>\n"
	boxText = boxText..tab3.."<ROTATION deg=\"%degrees%\" rad=\"%radians%\"/>\n"
	boxText = boxText..tab3.."<ID link_id=\"%linkid%\" guid=\"%guid%\"/>\n"
	boxText = boxText.."</RECT>\n"
	circleText = "<CIRCLE>\n"
	circleText = circleText..tab3.."<START x=\"%xpos%\" y=\"%ypos%\"/>\n"
	circleText = circleText..tab3.."<SIZE radius=\"radius\" width=\"%width%\" height=\"%height%\"/>\n"
	circleText = circleText..tab3.."<ID link_id=\"%linkid%\" guid=\"%guid%\"/>\n"
	circleText = circleText.."</CIRCLE>\n"
	shapeText = as3.tolua(DAME.CreateTextForShapes(shapeLayer, circleText, boxText, textboxText ))
	return shapeText;
end

function xmlProp (prop, value)
	propStr = prop.."= \""..value.."\" ";
	return propStr
end

if (useIndex) then
	masterFileText = "<INDEX "
	masterFileText = masterFileText..xmlProp("key",as3.tolua(levelPre))
	masterFileText = masterFileText.."\>\n"
	masterFileText = masterFileText..tab1.."<AREAS>\n"
end 

-- This is the file for the map level class.
for groupIndex = 0,groupCount do
	
	
	fileText = ""
	
	maps = {}
	spriteLayers = {}
	shapeLayers = {}

	masterLayerAddText = ""


	group = groups[groupIndex]
	
	groupName = as3.tolua(group.name)
	groupName = string.gsub(groupName, " ", "_")
	
	if useGroups then levelName = groupName
	else levelName = levelPre
	end
	
	if (useIndex) then masterFileText = masterFileText..tab2.."<AREA>"..levelName.."</AREA>\n"; end
	
	layerCount = as3.tolua(group.children.length) - 1
	
	fileText = "<level>\n"
	fileText = fileText..tab1.."<INFO key=\""..levelName.."\" />\n" 
	
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
			table.insert( spriteLayers,{groupName,layer,layerName})
		elseif as3.tolua(layer.IsShapeLayer()) == true then
			table.insert(shapeLayers,{groupName,layer,layerName})
		end
	end


	fileText = fileText..tab1.."<LAYERS>\n"
	for i,v in ipairs(maps) do
		fileText = fileText..exportMapCSV( maps[i][1], maps[i][2], i -1 )
	end
	fileText = fileText..tab1.."</LAYERS>\n"


	-- create the sprites.

	fileText = fileText..tab1.."<OBJECTS>\n"
	for i,v in ipairs(spriteLayers) do
		fileText = fileText..exportObjectXML(spriteLayers[i][1],spriteLayers[i][2]);
	end
	fileText = fileText..tab1.."</OBJECTS>\n"
	
	fileText = fileText..tab1.."<SHAPES>\n"
	for i,v in ipairs(shapeLayers) do
		fileText = fileText..exportShapeXML(shapeLayers[i][2]);
	end
	fileText = fileText..tab1.."</SHAPES>\n"
	
	fileText = fileText.."</level>\n"
	
	-- Save the file!
	if (useIndex) then DAME.WriteFile(dataDir.."/"..levelPre.."/"..levelName..".xml", fileText )
	else DAME.WriteFile(dataDir.."/"..levelName..".xml", fileText )
	end

end

if (useIndex) then
	masterFileText = masterFileText..tab1.."</AREAS>\n"
	masterFileText = masterFileText.."</INDEX>"
	DAME.WriteFile(dataDir.."/"..levelPre..".xml", masterFileText )
	end




return 1
