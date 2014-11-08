package assets
{
	import com.p3.loading.bundles.P3InternalBundle;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class InternalAssets extends P3InternalBundle 
	{
		
		//[Embed(source = '../assets.zip', mimeType = 'application/octet-stream')]public var zip:Class
		//THIS IS THE RESOURCE EMBED FOR THE STANDALONE VERSION. COMMENT THIS OUT ON THE SITE VERSION.
		[Embed(source = 'fonts/alagard.ttf', fontFamily = "alagard", embedAsCFF = "false")]public var font_alagard:Class
		
		[Embed(source = "graphics/mt_template.png")]public var img_mt_template:Class
		[Embed(source = "graphics/no_asset.png")]public var img_no_asset:Class

		[Embed(source = "graphics/tiles/grass_tiles.png")] public var img_grass_tiles:Class
		[Embed(source="graphics/tiles/sky_tiles.png")] public var img_sky_tiles:Class
		[Embed(source="graphics/tiles/greybox_tiles.png")] public var img_greybox_tiles:Class
		
		
		
		//INVENTORY
		[Embed(source = "graphics/ui/inventory_bg.png")]public var img_inventory_bg:Class
		[Embed(source = "graphics/ui/inventory_cell.png")]  public var img_inventory_cell:Class;
		
		[Embed(source="graphics/items/inventory/inventory_coin_pile.png")]public var img_inv_coins:Class;
				
		//FOOD GRAFX
		
		
		
		
		

		public function InternalAssets() 
		{
			super();
		}
		
	}

}