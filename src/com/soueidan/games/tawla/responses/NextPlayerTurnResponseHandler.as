package com.soueidan.games.tawla.responses
{
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.soueidan.games.tawla.core.IPlayer;
	import com.soueidan.games.tawla.managers.DiceManager;
	import com.soueidan.games.tawla.managers.PlayerManager;
	import com.soueidan.smartfoxserver.responseHandlers.BaseClientResponseHandler;
	
	public class NextPlayerTurnResponseHandler extends BaseClientResponseHandler
	{
		static public const NEXT_PLAYER_TURN:String = "next_player_turn";
		
		override public function handleServerResponse(event:SFSEvent):void {
			var object:SFSObject = event.params.params as SFSObject;
			var player:IPlayer = PlayerManager.getPlayerById(object.getInt("turn"));
			trace("next player", player.id);
			PlayerManager.setTurn(player);
			
			DiceManager.setValues(object);
		}
	}
}