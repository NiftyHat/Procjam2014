package game.deco 
{
	import axengine.world.AxWorld;
	import game.entities.characters.PJThief;
	import game.entities.characters.PJWizard;
	import game.entities.PJCharacter;
	import game.PJEntity;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PJGravestone extends PJEntity 
	{
		
		public function PJGravestone($character:PJCharacter) 
		{
			super($character.x + 5, $character.y, null);
			var frame:int = 0;
			if ($character is PJThief)
			{
				frame = Math.random() * 3;
			}
			if ($character is PJWizard)
			{
				frame = Math.random() * 3 + 3;
			}

				//frame = Math.random() * 3 + 6;

			//var newTomb:AxSprite = new AxSprite(tombstoneGroup.members.length * 23, 0, Core.lib.int.img_tombstones, 22, 32)
			load(Core.lib.int.img_tombstones, 22, 32);
			show(frame);
			//_libraryAssetName = "GRAVE";
		}
		
		override public function init($world:AxWorld):void 
		{
			super.init($world);
			//loadNativeGraphics(false);
		}
		
	}

}