var dom = fl.getDocumentDOM();
var lib = dom.library;
var newSel = [];

var selItems = lib.getSelectedItems();

for( var i=0; i<selItems.length; i++ )
{

var s = selItems[i].name.split( "." );

var nameId = s[ 0 ] + "_mc";
lib.addNewItem( "movie clip", nameId );
lib.editItem( nameId );

var tl = dom.getTimeline();
tl.layers[0].name = "L1";
lib.addItemToDocument( {x:0, y:0}, selItems[i].name );

newSel[0] = tl.layers[ 0 ].frames[ 0 ].elements[ 0 ];

dom.selectNone();
dom.selection = newSel;
var mat = dom.selection[0].matrix;
mat.tx = - (dom.selection[0].width/2);
mat.ty = - (dom.selection[0].height/2);
dom.selection[0].matrix = mat;	
dom.selectNone();
dom.exitEditMode();

}