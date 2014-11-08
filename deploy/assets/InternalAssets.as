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
		
		[Embed(source = "graphics/editor_stuff/mt_template.png")]public var img_mt_template:Class
		[Embed(source = "graphics/no_asset.png")]public var img_no_asset:Class

		[Embed(source="graphics/tiles/greybox_tiles.png")] public var img_greybox_tiles:Class
		
		[Embed(source = "graphics/player.png")] public var img_player:Class;
		
		
		

		public function InternalAssets() 
		{
			super();
		}
		
	}

}