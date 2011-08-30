package com.soueidan.games.tawla.requests
{
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.smartfoxserver.v2.requests.ExtensionRequest;
	import com.soueidan.games.tawla.events.PlayerEvent;
	import com.soueidan.smartfoxclient.core.SmartFoxClient;
	import com.soueidan.smartfoxclient.managers.SmartFoxManager;
	
	public class PlayerNewRoundRequest extends ExtensionRequest
	{
		protected var _server:SmartFoxClient = SmartFoxManager.getInstance();
		
		protected var _params:ISFSObject;
		
		static private const action:String = "player_new_round";
		
		public function PlayerNewRoundRequest(evt:PlayerEvent)
		{
			_params = new SFSObject();
			_params.putInt("playerId", evt.player.id);
			_params.putInt("playerScore", evt.player.score);
			
			super(action, _params, _server.currentRoom, false);
		}
	}
}