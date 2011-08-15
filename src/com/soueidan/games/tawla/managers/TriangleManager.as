package com.soueidan.games.tawla.managers
{
	import com.soueidan.games.tawla.components.*;
	import com.soueidan.games.tawla.components.interfaces.*;
	import com.soueidan.games.tawla.core.*;
	import com.soueidan.games.tawla.types.*;
	import com.soueidan.games.tawla.utils.*;
	
	import flash.geom.Point;
	import flash.sampler.NewObjectSample;
	
	import mx.core.ITransientDeferredInstance;
	import mx.core.mx_internal;
	
	import org.osflash.thunderbolt.Logger;

	public class TriangleManager
	{
		static private var _triangles:Array = new Array();
		static private var _cupIsActive:Boolean; // have we already added the cup, then no need to check if the cup can be active.
		static private var _setupCup:Boolean; // have we tried to add the cup on the screen?
		static private var _movements:Array = [];
		
		static public function showMovementsOnBoard(chip:IChip):void {
			if ( chip.isFreezed ) {
				return;
			}
			
			_cupIsActive = false;
			_setupCup = false;
			
			setLeftMovements(chip);
			filterOverlaps(chip);
			lightMovements();
		}
		
		static private function setLeftMovements(chip:IChip):void {
			var triangle:ITriangle= (chip.parent as ITriangle);
			var spot:ITriangle;
			var position:int = 0;
			
			_movements = [];
			
			var player:IPlayer = PlayerManager.player;
			
			for each(var value:Number in DiceManager.leftMovements ) {
				position = triangle.position + ( player.direction * value);
				
				spot = getByPosition(position);
				if ( spot ) {
					if ( !canOwnIt(spot, chip) && DiceManager.dice.isDouble) {
						break;
					}
				
					_movements.push(spot);
				} else {
					setupCupMovement(triangle, chip, value);
				}
			}
		}
		
		static private function setupCupMovement(triangle:ITriangle, chip:IChip, diceValue:Number):void {
			var player:IPlayer = PlayerManager.player;
			if ( !player.isHome || _cupIsActive ) {
				return;
			}
			
			var dice:IDice = DiceManager.dice;

			var position:int = triangle.position + ( player.direction * diceValue);
			
			//trace("dice", diceValue, "position", triangle.position, "position", position);
			
			var canMoveToCup:Boolean;
			if ( position == 0 || position == 25 ) {
				canMoveToCup = true;
			} else {
				var endTriangle:ITriangle = triangle;
				if ( _movements.length > 0 ) {
					if ( player.direction == PlacementTypes.BOTTOM )  endTriangle = _movements[0];
					else endTriangle = _movements[(_movements.length-1)];
				}
				
				if ( !anyChipsBehind(endTriangle, chip, position) ){
					canMoveToCup = true;
				}
			}
			
			if ( canMoveToCup ) {
				_cupIsActive = true;
				_movements.push(player.cup);
			}

		}
		
		static private function anyChipsBehind(triangle:ITriangle, chip:IChip, position:int):Boolean {
			if ( _setupCup ) {
				return true;
			}
			
			_setupCup = true;
			
			var player:IPlayer = chip.player;			
			if ( position < 0 || position > 25 ) {
				var position:int = triangle.position - 19;
				if ( player.direction == PlacementTypes.BOTTOM ) {
					position = Math.abs(triangle.position - 6);
				}
				
				//trace("triangle", triangle.position, "chip", chip.position, "position", position);
				
				var lastTriangle:ITriangle = triangle;
				var lastPosition:int;
				while(position>0) {
					lastPosition = lastTriangle.position + ( (player.direction*-1) * 1);
					
					lastTriangle = TriangleManager.getByPosition(lastPosition);
					if ( lastTriangle.chips.length > 0 ) {
						return true;
					}
					
					position -= 1;
				}
			}
			
			return false;
		}
		
		static private function filterOverlaps(chip:IChip):void {
			if ( DiceManager.leftMovements.length <= 1 ||  
				 _movements.length <= 2) {
				return;
			}
			
			if ( !DiceManager.dice.isDouble ) {
				var newMovements:Array = [];
				for(var i:int=0;i<2;i++) {
					if ( canOwnIt(_movements[i], chip) ) {
						newMovements.push(_movements[i]);
					}
				}
				
				// at least one triangle is free to add the total triangle position
				if ( newMovements.length >= 1 && canOwnIt(_movements[2], chip) ) {
					newMovements.push(_movements[2]);
				}
				
				_movements = newMovements;
			}
		}
		
		static private function lightMovements():void {
			for each(var triangle:ITriangle in _movements) {
				triangle.alert();
			}	
		}
		
		static public function removeAllMovementsOnBoard():void {
			for each(var triangle:ITriangle in _movements) {
				triangle.unalert();
			}
			_movements = [];
		}
		
		static public function get movements():Array {
			return _movements;
		}
		
		static public function get all():Array {
			return _triangles;
		}
		
		static public function create(position:Number):ITriangle {
			var triangle:ITriangle = new Triangle(position);
			_triangles.push(triangle);
			return triangle;
		}
		
		static public function getByPosition(position:Number):ITriangle {
			var index:int = position - 1;
			return _triangles[index];
		}
		
		static public function getFromChipToPosition(chip:IChip, position:Number):ITriangle {
			position = chip.position + ( chip.player.direction * position);
			return getByPosition(position);
		}
		
		static public function canOwnIt(triangle:ITriangle, chip:IChip):Boolean {
			var lastChipPlayed:IChip = triangle.lastChip;
			
			if ( !lastChipPlayed ) {
				return true;
			}
			
			if ( triangle.numElements < 2 ) {
				return true;
			}
			
			if ( lastChipPlayed.color != chip.color ) {
				return false;
			}

			return true;
		}
	}
}