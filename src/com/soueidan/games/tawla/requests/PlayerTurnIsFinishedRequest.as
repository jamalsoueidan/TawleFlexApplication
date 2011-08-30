package com.soueidan.games.tawla.requests
{
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.requests.ExtensionRequest;
	import com.smartfoxserver.v2.requests.IRequest;
	import com.soueidan.smartfoxclient.core.SmartFoxClient;
	import com.soueidan.smartfoxclient.managers.SmartFoxManager;
	
	public class PlayerTurnIsFinishedRequest extends ExtensionRequest implements IRequest
	{
		protected var _server:SmartFoxClient = SmartFoxManager.getInstance();
		
		protected var _params:ISFSObject;
		
		static private const action:String = "player_finish_turn";
		
		public function PlayerTurnIsFinishedRequest()
		{			
			super(action, _params, _server.currentRoom, false);
		}
	}
}