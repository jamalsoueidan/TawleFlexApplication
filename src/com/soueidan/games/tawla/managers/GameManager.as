package com.soueidan.games.tawla.managers
{
	import com.soueidan.games.tawla.components.interfaces.IChip;
	import com.soueidan.games.tawla.core.Game;
	import com.soueidan.games.tawla.core.IPlayer;
	import com.soueidan.games.tawla.events.PlayerEvent;
	
	import mx.core.FlexGlobals;

	public class GameManager
	{
		static private function dispatchEvent(evt:*):void {
			var game:Game = FlexGlobals.topLevelApplication as Game;
			game.dispatchEvent(evt);
		}
		
		static public function finishedPlaying():void {
			isAllChipsHome();
			
			var player:IPlayer = PlayerManager.player;
			
			if ( !winnerExists ) {
				if ( playerHaveLeftMovements ) {
					if ( !canPlayerMoveAnyChip ) {
						dispatchEvent(new PlayerEvent(PlayerEvent.NO_CHIP_MOVEMENTS, false,false, player));
					}
				} else {
					dispatchEvent(new PlayerEvent(PlayerEvent.FINISHED_PLAYING, false,false,player));
				}
			} else {
				
				setPlayerScore();
				dispatchEvent(new PlayerEvent(PlayerEvent.HAVE_A_WINNER,false,false,player));
			}
		}
		
		private static function setPlayerScore():void
		{
			PlayerManager.player.addScore(1);
			
		}
		
		static private function get playerHaveLeftMovements():Boolean {
			if ( DiceManager.anyLeftMovements ) {
				return true;
			}
			return false;
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
			var isHome:Boolean = true;
			var player:IPlayer = PlayerManager.player;
			for each(var chip:IChip in player.chips ) {
				var position:int = PlayerManager.convertPosition(chip.position);
				if ( position < 19 ) {
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