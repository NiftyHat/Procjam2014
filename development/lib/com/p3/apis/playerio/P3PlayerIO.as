package com.p3.apis.playerio 
{
	//import com.p3.apis.playerio.events.P3PioErrorEvent;
	import com.p3.apis.playerio.events.PlayerIOErrorEvent;
	import com.p3.apis.playerio.events.PlayerIOEvent;
	import com.p3.apis.playerio.events.PlayerIOMessageEvent;
	import com.p3.debug.mincomps.P3MinCompsLog;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import playerio.Client;
	import playerio.Connection;
	import playerio.Message;
	import playerio.PlayerIO;
	import playerio.PlayerIOError;
	
	/**
	 * Singleton Class
	 * @author Duncan Saunders
	 */
	public class P3PlayerIO extends EventDispatcher
	{
		
		
		/*---------------------------------------------------------------------------*\
		 *	BEGIN SINGLETON
		 *---------------------------------------------------------------------------*/
		
		
		public function P3PlayerIO() 
		{
			if (_instance) throw new Error ("only one instance of singleton allowed. Use P3PlayerIO.ins to accsess it");
		}
		
		public static function get inst ():P3PlayerIO 
		{
			if (!_instance) _instance = new P3PlayerIO;
			return _instance;
		}
		
		/*---------------------------------------------------------------------------*\
		 * END SINGLETON
		 *---------------------------------------------------------------------------*/
		private var _stage:Stage;
		
		public var _gameID:String;
		private static var _instance:P3PlayerIO
		private var debug:P3MinCompsLog;
		private var _playerID:int;
		private var _client:Client;
		private var _connnection:Connection;
		 
		public function init ($stage:Stage, $gameID:String = "test-game2-gz9z8eyekuuavljdezdw"):void 
		{
			debug = P3MinCompsLog.inst;
			debug.log("Player IO started!");
			//addChild(debug);
			_stage = $stage;
			_gameID = $gameID;
		}
		
		public function login ($userID:String = "GuestUser" , $connectionID:String = "public"):void
		{
			PlayerIO.connect(_stage, _gameID, $connectionID, $userID, "", "", onConnectCallback, onErrorCallback)
			debug.log("Trying to connect");
		}
		
		public function logout():void 
		{
			if (_connnection) 
			{
				debug.error("Disconnected from server!");
				_connnection.disconnect();
				_connnection = null;
				dispatchEvent(new PlayerIOEvent(PlayerIOEvent.LOGGED_OUT));
			}
		}
		
		private function onDisconnect():void 
		{
			logout();
		}
		
		private function onErrorCallback($error:PlayerIOError):void 
		{
			debug.error($error.message);
			dispatchEvent(new PlayerIOErrorEvent(PlayerIOErrorEvent.ERROR, $error));
		}
		
		private function onConnectCallback($client:Client):void 
		{
			_client = $client;
			_client.multiplayer.developmentServer = "127.0.0.1:8184";
			_client.multiplayer.createJoinRoom(
				"testRoom",						//Room id. If set to null a random roomid is used
				"TestGame",					//The game type started on the server
				true,								//Should the room be visible in the lobby?
				{},									//Room data. This data is returned to lobby list. Variabels can be modifed on the server
				{},									//User join data
				onRoomJoinCallback,							//Function executed on successful joining of the room
				onErrorCallback							//Function executed if we got a join error
			);
			debug.log("Hello Server! : " + _client.connectUserId);
			
		}
		
		private function onRoomJoinCallback($connection:Connection):void 
		{
			_connnection = $connection;
			debug.log("Hello Room! (waiting for init)");
			$connection.addMessageHandler("*", onMessageRecived)
			$connection.addMessageHandler("handshake", onHandshakeRecived);
			_connnection.addDisconnectHandler(onDisconnect);
		}
		
		private function onHandshakeRecived($message:Message):void 
		{
			if (!_playerID) _playerID = $message.getInt(0);
			debug.info("PlayerID" + _playerID);
			dispatchEvent(new PlayerIOEvent(PlayerIOEvent.LOGGED_IN));
		}
		
		private function onMessageRecived($message:Message):void 
		{
			//if (!_playerID) _playerID = $playerID;
			dispatchEvent(new PlayerIOMessageEvent(PlayerIOMessageEvent.MESSAGE, $message));
			//debug.info("PlayerID" + _playerID);
			debug.recived($message.toString());
		}
		
		public function get playerID():int 
		{
			return _playerID;
		}
		
		public function get client():Client 
		{
			return _client;
		}
		
	}
	
}