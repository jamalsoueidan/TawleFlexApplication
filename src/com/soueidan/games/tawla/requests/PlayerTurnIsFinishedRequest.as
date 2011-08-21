package com.soueidan.games.tawla.requests
{
	import com.smartfoxserver.v2.entities.Room;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.smartfoxserver.v2.requests.ExtensionRequest;
	import com.smartfoxserver.v2.requests.IRequest;
	import com.soueidan.games.tawla.events.PlayerEvent;
	import com.soueidan.smartfoxclient.core.SmartFoxClient;
	
	public class PlayerTurnIsFinishedRequest extends ExtensionRequest implements IRequest
	{
		protected var _server:SmartFoxClient = SmartFoxClient.getInstance();
		
		protected var _params:ISFSObject;
		
		static private const action:String = "player_finish_turn";
		
		public function PlayerTurnIsFinishedRequest()
		{			
			super(action, _params, _server.currentRoom, false);
		}
	}
}