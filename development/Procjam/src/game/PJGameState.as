package game 
{
	import axengine.events.AxLevelEvent;
	import base.events.GameEvent;
	import game.entities.characters.PJThief;
	import game.entities.PJPlayer;
	import game.world.PJWorld;
	import keith.ConvertToAxTileMaps;
	import org.axgl.Ax;
	import org.axgl.AxPoint;
	import org.axgl.AxState;
	import org.axgl.input.AxKey;
	import org.axgl.text.AxText;
	import org.axgl.tilemap.AxTilemap;
	
	/**
	 * ...
	 * @author Duncan Saunders
	 */
	public class PJGameState extends AxState 
	{
		private var generator:ConvertToAxTileMaps;
		private var generatorSeed:int = 0;
		
		private var floorGeom:AxTilemap
		private var wallsGeom:AxTilemap
		
		public function PJGameState() 
		{
			super();
			Core.control.addEventListener(AxLevelEvent.END, onLevelComplete);
			//add(new PJWorld);
			
			generator = new ConvertToAxTileMaps();
			redrawLevel()
			
		}
		
		
		override public function update():void 
		{
			super.update();
			if (Ax.keys.pressed(AxKey.RIGHT)) {
				generatorSeed++;
				redrawLevel()
			} else if (Ax.keys.pressed(AxKey.LEFT)) {
				generatorSeed--;
				redrawLevel()
			} 
		}
		
		private function redrawLevel():void 
		{
			generator.generate(20, 12, generatorSeed);
			
			if (floorGeom) remove(floorGeom);
			if (wallsGeom) remove(wallsGeom);
			
			floorGeom = generator.getFloorGeometry()
			wallsGeom = generator.getWallGeometry()
			add(floorGeom);
			add(wallsGeom);
		}
		
		private function onLevelComplete(e:AxLevelEvent):void 
		{
			Ax.switchState(new PJLevelEndState());
		}
		
	}

}