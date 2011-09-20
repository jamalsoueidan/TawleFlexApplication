package com.soueidan.games.tawla.managers
{
	import com.soueidan.games.tawla.components.interfaces.IChip;
	import com.soueidan.games.tawla.components.interfaces.ITriangle;
	import com.soueidan.games.tawla.core.Game;
	import com.soueidan.games.tawla.core.IPlayer;
	import com.soueidan.games.tawla.events.PlayerEvent;
	import com.soueidan.games.tawla.types.PlacementTypes;
	
	import mx.core.FlexGlobals;

	public class GameManager
	{
		
		static private var _instance:Game;
		
		static public function setGame(value:Game):void {
			_instance = value;
		}
		
		static public function getInstance():Game {
			return _instance;
		}
		
		static private function dispatchEvent(evt:*):void {
			_instance.dispatchEvent(evt);
		}
		
		static public function finishedPlaying():void {
			isAllChipsHome();
			
			var player:IPlayer = PlayerManager.player;
			
			if ( !winnerExists ) {
				//trace("winner not exists");
				if ( DiceManager.anyLeftMovements ) {
					if ( !canPlayerMoveAnyChip ) {
						//trace("dispatch", "no chip movements");
						dispatchEvent(new PlayerEvent(PlayerEvent.NO_CHIP_MOVEMENTS, false,false, player));
					}
				} else {
					//trace("dispatch", "finished playing");
					dispatchEvent(new PlayerEvent(PlayerEvent.FINISHED_PLAYING, false,false,player));
				}
			} else {
				setPlayerScore();
			}
		}
		
		public static function setPlayerScore(dispatch:Boolean=true):void
		{
			var score:int = 0;
			var opponent:IPlayer = PlayerManager.opponent;
			
			if ( opponent.isHome ) {
				score = 1;
			}
			
			if ( !opponent.isHome ) {
				score = 2;
				
				var triangle:ITriangle = TriangleManager.getByPosition(opponent.startPosition);
				var chip:IChip = triangle.firstChip;
				if ( chip && chip.player == opponent ) {
					score = 5;
				} 
			}
			
			PlayerManager.player.addScore(score);
			
			if ( !dispatch ) {
				return;
			}
			
			var eventName:String = PlayerEvent.NEW_ROUND;
			if ( PlayerManager.player.score >= 5 ) {
				eventName = PlayerEvent.HAVE_A_WINNER;
			}
			
			dispatchEvent(new PlayerEvent(eventName,false,false,PlayerManager.player));
			
		}
		
		static public function get canPlayerMoveAnyChip():Boolean {
			var player:IPlayer = PlayerManager.player;	
			
			for each(var chip:IChip in player.chips ) {
				if ( ChipManager.haveAnyMovements(chip) ) {
					return true;
				}
			}
			
			return false;
		}
		
		static private function isAllChipsHome():void {
			var player:IPlayer = PlayerManager.player;
			if ( player.isHome ) {
				return;
			}
			
			var isHome:Boolean = true;
			for each(var chip:IChip in player.chips ) {
				if ( chip.position < 19 && player.direction == PlacementTypes.TOP ) {
					isHome = false;	
				}
				
				if ( chip.position > 6 && player.direction == PlacementTypes.BOTTOM ) {
					isHome = false;	
				}
			}
			
			if ( isHome ) {
				player.isHome = true;	
				dispatchEvent(new PlayerEvent(PlayerEvent.IS_HOME, false, false, player));
			}
		}
		
		static private function get winnerExists():Boolean {
			var player:IPlayer = PlayerManager.player;
			if ( player.chips.length == 0 ) {
				return true;
			}
			return false;
		}
	}
}