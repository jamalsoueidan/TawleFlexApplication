package com.soueidan.games.tawla.managers
{
	import com.smartfoxserver.v2.entities.SFSUser;
	import com.soueidan.games.engine.managers.ClientManager;
	import com.soueidan.games.tawla.components.interfaces.IChip;
	import com.soueidan.games.tawla.core.Game;
	import com.soueidan.games.tawla.core.IPlayer;
	import com.soueidan.games.tawla.core.Player;
	import com.soueidan.games.tawla.events.PlayerEvent;

	public class PlayerManager
	{
		static private var _player:IPlayer;
		static private var _players:Array = new Array();
		
		static public function get opponent():IPlayer {
			if ( _players[0].sfsUser == ClientManager.getInstance().mySelf) {
				return _players[1];
			} else {
				return _players[0];
			}
			
			return null;
		}
		
		static public function get myself():IPlayer {
			if ( _players[0].sfsUser == ClientManager.getInstance().mySelf) {
				return _players[0];
			} else {
				return _players[1];
			}
			
			return null;
		}
		
		static public function get all():Array {
			return _players;
		}
		
		static public function add(player:IPlayer):void {
			_players.push(player);
		}
		
		static public function create(user:SFSUser=null):IPlayer {
			return new Player(CupManager.create(), user);
		}
		
		static public function get total():Number {
			return _players.length;
		}
		
		static public function get player():IPlayer {
			return _player;
		}
		
		static public function reset():void {
			for each(var player:IPlayer in _players ) {
				player.removeAllChips();
			}
		}

		/**
		 * Next player turn 
		 * @return 
		 * 
		 */
		static public function next():void {
			if ( _player == _players[0]) {
				setTurn(_players[1]);
			} else {
				setTurn(_players[0]);
			}
		}
		
		// check if the checker belongs to this current player who turn is on
		static public function currentPlayerTurnBelongsThisChipTo(chip:IChip):Boolean {
			return isMyTurn(chip.player);
		}
		
		static private function isMyTurn(player:IPlayer):Boolean {
			return ( _player.color == player.color );
		}
		
		static public function setTurn(player:IPlayer):void {
			_player = player;
			
			trace("__________________________________");
			trace("::::: TURN ::::::", player.name);
			
			DiceManager.reset();
			GameManager.getInstance().dispatchEvent(new PlayerEvent(PlayerEvent.TURN_CHANGE,false,false, _player));
		}
		
		static public function getPlayerByName(value:String):IPlayer {
			for each(var player:IPlayer in _players ) {
				if ( player.name == value ) {
					return player;
				}
			}
			return null;
		}
		
		static public function getPlayerById(value:int):IPlayer {
			for each(var player:IPlayer in _players ) {
				if ( value == player.id ) {
					return player;
				}
			}
			return null;
		}
		
		static public function getChip(num:Number):IChip {
			for each(var chip:IChip in _player.chips) {
				if ( chip.num == num ) return chip;
			}
			return null;
		}
	}
}