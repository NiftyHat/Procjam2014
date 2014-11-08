var itemArray = fl.getDocumentDOM().library.getSelectedItems()

for (var i = 0; i < itemArray.length; i++) 
{
    var item = itemArray[i];
	if(item.linkageClassName)
	{
		var className = item.linkageClassName;
		className = className + "_model";
		item.linkageClassName = className;
	}
}