package com.soueidan.games.tawla.requests
{
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.smartfoxserver.v2.requests.ExtensionRequest;
	import com.soueidan.games.engine.managers.ClientManager;
	import com.soueidan.games.engine.net.Client;
	import com.soueidan.games.tawla.events.PlayerEvent;
	
	public class PlayerIsHomeRequest extends ExtensionRequest
	{
		protected var _server:Client = ClientManager.getInstance();
		
		protected var _params:ISFSObject;
		
		static private const action:String = "player_is_home";
		
		public function PlayerIsHomeRequest(evt:PlayerEvent)
		{
			_params = new SFSObject();
			_params.putInt("playerId", evt.player.id);
			
			super(action, _params, _server.currentRoom, false);
		}
	}
}