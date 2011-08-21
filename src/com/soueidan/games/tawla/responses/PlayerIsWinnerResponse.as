package com.soueidan.games.tawla.responses
{
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.soueidan.games.tawla.core.IPlayer;
	import com.soueidan.games.tawla.managers.PlayerManager;
	
	import mx.managers.PopUpManager;

	public class PlayerIsWinnerResponse extends DefaultResponse
	{

		static public const PLAYER_WIN_GAME:String = "player_win_game";
		static public const PLAYER_WIN_ROUND:String = "player_win_round";
		
		override public function handleServerResponse(event:SFSEvent):void {
			var object:SFSObject = event.params.params as SFSObject;
			var player:IPlayer = PlayerManager.getPlayerById(object.getInt("playerId"));
			
			if ( action == PLAYER_WIN_ROUND ) {
				trace("player won round");
			} else {
				
			}
			
		}
	}
}