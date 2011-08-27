package com.soueidan.games.tawla.managers
{
	import com.soueidan.games.tawla.components.Chip;
	import com.soueidan.games.tawla.components.interfaces.IChip;
	import com.soueidan.games.tawla.core.IPlayer;

	public class ChipManager
	{		
		static public function create(player:IPlayer, num:Number):IChip {
			return new Chip(player, num);
		}
		
		static public function haveAnyMovements(chip:IChip):Boolean {
			if ( chip.isFreezed ) {
				return false;
			}
			
			TriangleManager.showMovementsOnBoard(chip, false);	
			return ( TriangleManager.movements.length > 0 )
		}
		
		static public function lastChipStanding(chip:IChip):Boolean {
			var position:int = chip.position;
			return false;
		}
	}
}