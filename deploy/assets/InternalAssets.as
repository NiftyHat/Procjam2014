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
		
		
		[Embed(source="graphics/items/coin_pile.png")] public var img_coin_pile:Class;
		[Embed(source = "graphics/characters/theif_01_char.png")] public var img_thief_01:Class;
		
		[Embed(source = "graphics/tiles/vision_tiles.png")]public var img_vision_tiles:Class;
		
		[Embed(source = "graphics/grave.png")]public var img_grave:Class;

		[Embed(source = "fonts/alagard.ttf", fontFamily = "alagard", embedAsCFF = "false")] public static const font:String
		
		[Embed(source="graphics/effects/attack_tiles.png")] public var img_attack_zone_tiles:Class;
		
		
		[Embed(source = "graphics/effects/fire.png")]public var img_fire:Class;
		[Embed(source = "graphics/projectiles/fireball.png")]public var img_fireball:Class;
		
		[Embed(source="graphics/ui/tombstones.png")]public var img_tombstones:Class;
		
		
		[Embed(source = "graphics/ui/title/game_start.jpg")]public var img_game_start:Class;
		[Embed(source = "graphics/ui/title/subtitle_strapline.png")]public var img_subtitle_strapline:Class;
		[Embed(source = "graphics/ui/title/subtitle_text.png")]public var img_subtitle_text:Class;
		[Embed(source = "graphics/ui/title/title_text.png")]public var img_title_text:Class;
		
		[Embed(source = "graphics/ui/title/byline_text.png")]public var img_byline_text:Class;
		
		[Embed(source = "graphics/ui/gameover/game_over_bg.jpg")]public var img_game_over_bg:Class;
		[Embed(source="graphics/ui/gameover/game_over_text.png")]public var img_game_over_text:Class;
		
		
		public function InternalAssets() 
		{
			super();
		}
		
	}

}