package com.soueidan.games.tawla.requests
{
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.requests.ExtensionRequest;
	import com.smartfoxserver.v2.requests.IRequest;
	import com.soueidan.games.engine.managers.ClientManager;
	import com.soueidan.games.engine.net.Client;
	
	public class PlayerTurnIsFinishedRequest extends ExtensionRequest implements IRequest
	{
		protected var _server:Client = ClientManager.getInstance();
		
		protected var _params:ISFSObject;
		
		static private const action:String = "player_finish_turn";
		
		public function PlayerTurnIsFinishedRequest()
		{			
			super(action, _params, _server.currentRoom, false);
		}
	}
}