package com.soueidan.games.tawla.responses
{
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.*;
	import com.smartfoxserver.v2.entities.data.*;
	import com.soueidan.games.tawla.core.*;
	import com.soueidan.games.tawla.handlers.*;
	import com.soueidan.games.tawla.managers.*;
	import com.soueidan.games.tawla.types.*;
	import com.soueidan.smartfoxserver.responseHandlers.BaseClientResponseHandler;
	
	public class StartGameResponseHandler extends DefaultResponseHandler
	{
		static public const START_GAME:String = "start_game";
		
		override public function handleServerResponse(event:SFSEvent):void {
			_game.enabled = true;
			
			var object:SFSObject = event.params.params as SFSObject;
			var player:IPlayer;
			
			var placement:int;
			var color:String;
			
			for each(var user:SFSUser in _server.currentRoom.playerList ) {
				placement = PlacementTypes.TOP;
				color = ColorTypes.BLACK;
				if ( user.id == _server.mySelf.id ) {
					placement = PlacementTypes.BOTTOM;
					color = ColorTypes.WHITE;
				}
				player = PlayerManager.create(user);
				player.color = color;
				player.direction = placement;
				PlayerManager.add(player);
			}
				
			_game.createCupsForPlayers();
			_game.board.setupChips();
			
			player = PlayerManager.getPlayerById(object.getInt("turn"));
			PlayerManager.setTurn(player);
		}
	}
}