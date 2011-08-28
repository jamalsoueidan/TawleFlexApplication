package com.soueidan.games.tawla.responses
{
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.soueidan.games.tawla.core.IPlayer;
	import com.soueidan.games.tawla.managers.PlayerManager;

	public class PlayerIsHomeResponse extends DefaultResponse
	{
		static public const PLAYER_IS_HOME:String = "player_is_home";
		
		override public function handleServerResponse(event:SFSEvent ):void {
			var object:SFSObject = event.params.params as SFSObject;
			var player:IPlayer = PlayerManager.getPlayerById(object.getInt("playerId"));
			player.isHome = true;
 		}
	}
}