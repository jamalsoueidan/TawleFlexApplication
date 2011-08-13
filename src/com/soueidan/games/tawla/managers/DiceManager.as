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
			_registeredMovements = ArrayUtil.merge(_registeredMovements, convertedMovements);
			
			//Logger.info("Registered movements:", ArrayUtil.toString(_registeredMovements));
			//Logger.info("Left movements:", ArrayUtil.toString(leftMovements));
		}
		
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
		 * It return all all the combination user can play with the dice values.
		 * It handles also dice doubles.
		 * 
		 * @return Array 
		 * 
		 */
		static private function get allDiceValueCombination():Array {			
			var movements:Array = _dice.all;
			movements.push(_dice.leftValue + _dice.rightValue);
			
			if ( _dice.isDouble ) {
				movements.push(_dice.leftValue * 3);
				movements.push(_dice.leftValue * 4);
			}
			
			return movements;
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
				var len:Number = Math.abs(_registeredMovements.length - 4);
				for(var i:int=0;i<len;i++){
					leftMovement.push(_dice.leftValue);
				}
			}
			
			return leftMovement;
		}
		
		/**
		 * Checks if this triangle parameter position is where this chip is allowed to be added
		 * with the values of the dice.
		 * 
		 * @param triangle Triangle that this chip is getting added to
		 * @param chip Chip that needs to be added to the triangle
		 * @return Boolean
		 * 
		 */		
		static public function movementIsAllowed(triangle:ITriangle, chip:IChip):Boolean {
			if ( !isDiceValue(triangle, chip)) {
				Logger.info("This is not dice value");
				return false;	
			}
	
			if ( !canOverLap(triangle, chip) ) {
				Logger.info("You are blocked by one triangle to move over this value");
				return false;
			}
			
			return true;
		}
		

		/**
		 * Check if this played move is one of the dice left movements.
		 *  
		 * @param triangle ITriangle
		 * @param chip IChip
		 * @return Boolean
		 * 
		 */
		static public function isDiceValue(triangle:ITriangle, chip:IChip):Boolean {
			var move:Number = Math.abs(triangle.position - chip.position);
			
			var movements:Array = convertMovement(move);
			
			//Logger.info("leftMovements", ArrayUtil.toString(leftMovements));
			//Logger.info("calculateMovement", ArrayUtil.toString(movements));
			
			if ( dice.isDouble ) {
				if ( leftMovements.length >= movements.length ) {
					return ArrayUtil.contains(allDiceValueCombination, move, true);
				}
			}
			
			return ArrayUtil.contains(leftMovements, move, true);
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
		
		static public function canOverLap(triangle:ITriangle, chip:IChip):Boolean {
			var move:Number = Math.abs(triangle.position - chip.position);
			
			var movements:Array = convertMovement(move);
			
			if ( movements.length == 1 ) {
				return true;
			}
			
			var i:int=0;
			if ( dice.isDouble ) {
				var len:int = move/movements.length;
				var start:int = 0;
				var allWorked:Boolean = true;
				for(i=0;i<len;i++){
					start += movements[i];
					if ( !tryPath(chip, start) ) {
						//Logger.info("Not worked path:", start, i);
						allWorked = false;
					}	
				}
				
				if ( allWorked ) {
					return true;
				} else {
					return false;
				}
			} else {
				for(i=0;i<movements.length;i++){
					if ( tryPath(chip, movements[i]) ) {
						//Logger.info("This path worked: ", movements[i]);
						return true;
					}	
				}
			}
			
			return false;
		}
		
		static private function tryPath(chip:IChip, movement:Number):Boolean {
			var startTriangle:ITriangle = TriangleManager.getFromChipPlacementByPosition(chip, movement);
			if ( TriangleManager.canOwnIt(startTriangle, chip) ) {
				return true;
			}
			return false;
		}
	}
}