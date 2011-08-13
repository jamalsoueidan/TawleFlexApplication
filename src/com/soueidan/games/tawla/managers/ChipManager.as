package com.soueidan.games.tawla.managers
{
	import com.soueidan.games.tawla.components.Chip;
	import com.soueidan.games.tawla.components.interfaces.IChip;
	import com.soueidan.games.tawla.components.interfaces.IDice;
	import com.soueidan.games.tawla.components.interfaces.ITriangle;
	import com.soueidan.games.tawla.core.Game;
	import com.soueidan.games.tawla.core.IPlayer;
	
	import mx.core.FlexGlobals;
	
	import org.osflash.thunderbolt.Logger;

	public class ChipManager
	{
	
		static private var _chips:Array = new Array();
		
		static public function get all():Array {
			return _chips;
		}
		
		static public function add(chip:IChip):void {
			_chips.push(chip);
		}
		
		static public function create(player:IPlayer, num:Number):IChip {
			return new Chip(player, num);
		}
		
		/**
		 * Check if this chip can move to the dice values
		 * 
		 * @param chip Chip that needs to move 
		 * @return Boolean
		 * 
		 */
		static public function canMove(chip:IChip):Boolean {
			if ( chip.isFreezed ) {
				return false;
			}

			for each(var movement:Number in DiceManager.leftMovements ) {
				var triangle:ITriangle = TriangleManager.getFromChipPlacementByPosition(chip, movement);
				if ( triangle && TriangleManager.canOwnIt(triangle, chip) ) {
					return true; 
				}
			}
			return false;
		}
	}
}