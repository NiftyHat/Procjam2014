var itemArray = fl.getDocumentDOM().library.items;

for (var i = 0; i < itemArray.length; i++) 
{
    var item = itemArray[i];
	if(item.linkageClassName)
	{
		var className = item.linkageClassName;
		className = "lib.sfx." + className.substring(0, className.length - 4);
		item.linkageClassName = className;
	}
}