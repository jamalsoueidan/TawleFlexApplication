package com.soueidan.games.tawla.requests
{
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.smartfoxserver.v2.requests.ExtensionRequest;
	import com.soueidan.games.tawla.events.PlayerEvent;
	import com.soueidan.smartfoxclient.core.SmartFoxClient;

	public class PlayerIsWinnerRequest extends ExtensionRequest
	{
		protected var _server:SmartFoxClient = SmartFoxClient.getInstance();
		
		protected var _params:ISFSObject;
		
		static private const action:String = "player_is_winner";
		
		public function PlayerIsWinnerRequest(evt:PlayerEvent)
		{
			_params = new SFSObject();
			_params.putInt("playerId", evt.player.id);
			
			super(action, _params, _server.currentRoom, false);
		}
	}
}