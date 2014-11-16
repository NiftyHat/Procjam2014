package {
	
	import axengine.state.AxInitState;
	import game.PJInitState;
	import org.axgl.Ax;
	
	[SWF(width="800", height="600", backgroundColor="#666666")] 
	//Set the size and color of the Flash file
	[Frame(factoryClass="Preloader")]
	public class Main extends Ax
	{	
		
		public function Main()
		{
			super(PJInitState, 800, 600, 1, 30, true);
			//super(608, 480, InitState, 1, 30, 30, true);
			Ax.logger.log("main init");
			Core.init();
			//new CustomContextMenu(this);
		}
		
	}
}