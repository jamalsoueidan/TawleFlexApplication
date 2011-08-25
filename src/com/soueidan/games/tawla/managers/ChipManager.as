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
		
		static public function getChip(player:IPlayer, num:Number):IChip {
			for each(var chip:IChip in player.chips ) {
				if (chip.num == num) {
					return chip;
				}
			}
			return null;
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