package com.soueidan.games.tawla.managers
{
	import com.soueidan.games.tawla.components.Cup;
	import com.soueidan.games.tawla.components.interfaces.IChip;
	import com.soueidan.games.tawla.components.interfaces.IDice;
	import com.soueidan.games.tawla.core.IPlayer;
	import com.soueidan.games.tawla.utils.ArrayUtil;
	
	import org.osflash.thunderbolt.Logger;

	public class GameManager
	{
		static public function get finishedPlaying():Boolean {
			if ( isAllAtHome ) {
				PlayerManager.player.isHome = true;	
			}
			
			if ( DiceManager.leftMovements.length == 0 ) {
				return true;
			}
			
			if ( !canPlay ) {
				return true;
			}

			return false;
		}
		
		static public function get canPlay():Boolean {
			var haveAnyMovements:Boolean;
			
			for each(var chip:IChip in PlayerManager.player.chips ) {
				if ( ChipManager.canMove(chip)) {
					//trace("Can move from position: ", chip.position);
					haveAnyMovements = true;
					break;
				}
			}
			
			return haveAnyMovements;
		}
		
		static public function get isAllAtHome():Boolean {
			var player:IPlayer = PlayerManager.player;
			for each(var chip:IChip in player.chips ) {
				var position:int = PlayerManager.convertPosition(chip.position);
				if ( position < 19 ) {
					return false;
				}
			}
			return true;
		}
	}
}