package com.soueidan.games.tawla.responses
{
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.soueidan.games.tawla.core.IPlayer;
	import com.soueidan.games.tawla.managers.DiceManager;
	import com.soueidan.games.tawla.managers.GameManager;
	import com.soueidan.games.tawla.managers.PlayerManager;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import mx.managers.PopUpManager;

	public class PlayerIsWinnerResponse extends DefaultResponse
	{

		static public const PLAYER_WIN_GAME:String = "player_is_winner";
		static public const PLAYER_WIN_ROUND:String = "player_new_round";
		
		override public function handleServerResponse(event:SFSEvent):void {
			var object:SFSObject = event.params.params as SFSObject;
			var player:IPlayer = PlayerManager.getPlayerById(object.getInt("playerId"));
			
			if ( player.chips.length > 0 ) {
				trace("player is cheating");
			}
			
			PlayerManager.setTurn(player);
			// don't add score again to me
			if ( _server.mySelf.id != player.id ) {
				trace("i did not win this game");
				GameManager.setPlayerScore(false);
			}
			
			if ( action == PLAYER_WIN_ROUND ) {
				trace("player won round");
				
				// it must be last or else setPlayerScore(this) wouldn't work
				// since it use the player state chips etc. at the moment.
				_game.reset();
				
				DiceManager.setValues(object);
			} else {
				trace("player won game");
			}
		}
	}
}