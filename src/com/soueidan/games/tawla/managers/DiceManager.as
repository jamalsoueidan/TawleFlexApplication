package com.soueidan.games.tawla.managers
{
	import com.soueidan.games.tawla.components.*;
	import com.soueidan.games.tawla.components.interfaces.*;
	import com.soueidan.games.tawla.core.*;
	import com.soueidan.games.tawla.types.*;
	import com.soueidan.games.tawla.utils.*;
	
	import org.osflash.thunderbolt.Logger;

	public class DiceManager
	{
		static private var _dice:IDice;
		private static var _registeredMovements:Array = [];
		
		static public function registerMovement(triangle:ITriangle, chip:IChip):void {
			var move:Number = Math.abs(triangle.position - chip.position);
			var convertedMovements:Array = DiceManager.convertMovement(move);
			_registeredMovements = ArrayUtil.merge(_registeredMovements, convertedMovements);		}
		
		static public function get registeredMovements():Array {
			return _registeredMovements;
		}
		
		static public function create():IDice {
			if ( !_dice ) {
				_dice = new Dice();
			}
			return _dice;
		}
		
		static public function reset():void {
			_registeredMovements = [];
		}
		
		static public function get dice():IDice {
			return _dice;
		}
		
		
		/**
		 * Can't be used while player is moving a chip on the board.
		 * Can be used to know which movements that is left to play.
		 * 
		 * @return Array
		 * 
		 */
		static public function get leftMovements():Array {
			var leftMovement:Array = [];
			
			if ( !_dice.isDouble ) {
				if ( !ArrayUtil.contains(_registeredMovements, _dice.leftValue) ) {
					leftMovement.push(_dice.leftValue);
				}
				
				if ( !ArrayUtil.contains(_registeredMovements, _dice.rightValue) ) {
					leftMovement.push(_dice.rightValue);
				}
				
				if ( _registeredMovements.length == 0 ) {
					leftMovement.push(_dice.total);
				}
			}
			
			if ( _dice.isDouble ) {
				var len:Number = Math.abs(_registeredMovements.length - 4) + 1;
				for(var i:int=1;i<len;i++){
					leftMovement.push(_dice.leftValue*i);
				}
			}
			
			return leftMovement;
		}
		
		static public function get anyLeftMovements():Boolean {
			return ( leftMovements.length > 0 )
		}
		
		/**
		 * Convert how many movement that played have used from current movements
		 * If played 12, then we need to examine which dice values he played
		 *  
		 * @param triangle
		 * @param chip
		 * @return 
		 * 
		 */
		static public function convertMovement(move:Number):Array {			
			if ( move == dice.leftValue ) {
				return [move];
			}
			
			if ( move == dice.rightValue ) {
				return [move];
			}
			
			if ( dice.isDouble ) {
				var len:int = move / dice.leftValue;
				var movements:Array = [];
				for(var i:int=0;i<len;i++){
					movements.push(dice.leftValue);
				}
				return movements;
			} else {
				return [dice.leftValue, dice.rightValue];	
			}
		}
	}
}