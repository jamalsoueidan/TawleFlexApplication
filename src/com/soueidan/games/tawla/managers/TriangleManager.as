package com.soueidan.games.tawla.managers
{
	import com.soueidan.games.tawla.components.*;
	import com.soueidan.games.tawla.components.interfaces.*;
	import com.soueidan.games.tawla.core.*;
	import com.soueidan.games.tawla.types.*;
	import com.soueidan.games.tawla.utils.*;
	
	import flash.geom.Point;
	
	import org.osflash.thunderbolt.Logger;

	public class TriangleManager
	{
		static private var _triangles:Array = new Array();
	
		static private var _canMoveToTriangles:Array = [];
		
		static public function register(triangle:ITriangle):void {
			_canMoveToTriangles.push(triangle);
		}
		

		static public function get all():Array {
			return _triangles;
		}
		
		static public function create(position:Number):ITriangle {
			var triangle:ITriangle = new Triangle(position);
			add(triangle);
			return triangle;
		}
		
		static public function add(triangle:ITriangle):void {
			//trace(triangle.placement, triangle.position);
			_triangles.push(triangle);
			
		}
		
		static public function convertPosition(triangle:ITriangle, chip:IChip):Number {
			if ( chip.player.placement == PlacementTypes.BOTTOM ) {
				return (25 - chip.position);
			}
			
			return triangle.position;
		}
		
		static public function applyPosition(triangle:ITriangle, chip:IChip):void {
			chip.position = triangle.position;
		}
		
		/**
		 * Get triangle from the player start position
		 * 
		 * 
		 * @param player Player
		 * @param position Count from player start position
		 * @return ITriangle 
		 * 
		 */
		static public function getFromPlayerPlacementByPosition(player:IPlayer, position:Number):ITriangle {
			if ( player.placement == PlacementTypes.BOTTOM ) {
				position = 25 - position;
			}
			
			return findByPosition(position);
		}
		
		/**
		 * Get triangle from the chip start position
		 * 
		 * @param chip Chip
		 * @param position Count to this position
		 * @return ITriangle
		 * 
		 */
		static public function getFromChipPlacementByPosition(chip:IChip, position:Number):ITriangle {
			var player:IPlayer = chip.player;
			if ( player.placement == PlacementTypes.BOTTOM ) {
				position = chip.position - position
			} else {
				position = chip.position + position;
			}
			
			return findByPosition(position);
		}
		
		static public function getByChipPosition(chip:IChip):ITriangle {
			return ITriangle(chip.parent);
		}
		
		/*
			it use player turn
		*/
		static public function getByPosition(position:Number):ITriangle {
			var player:IPlayer = PlayerManager.player;
			if ( player.placement == PlacementTypes.BOTTOM ) {
				position = 25 - position;
			}
			
			return findByPosition(position);
		}

		
		static private function findByPosition(position:int):ITriangle {			
			for each(var triangle:ITriangle in _triangles ) { 
				if ( triangle.position == position ) {
					return triangle;
				}
			}
			return null;
		}
		
		static public function canBeMovedTo(triangle:ITriangle, chip:IChip):Boolean {
			
			// must be above the triangle.position == chip.position
			if ( chip.isFreezed ) {
				Logger.info("Chip is freezed");
				return false;
			}
			
			if ( triangle.position == chip.position ) {
				return true;
			}
			
			if ( !canOwnIt(triangle, chip) ) {
				Logger.info("Can't own it");
				return false;
			}
			
			if ( chipMovingBack(triangle, chip) ) {
				Logger.info("Can't move this chip back");
				return false;
			}
			
			return DiceManager.movementIsAllowed(triangle, chip);
		}
		
		/**
		 * 
		 * @param triangle ITriangle
		 * @param chip IChip
		 * @return Return true if it can be occiped
		 * 
		 */
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
		
		/**
		 * 
		 * @param triangle ITriangle
		 * @param chip IChip
		 * @return Return true if this chip is trying to move back.
		 * 
		 */
		static private function chipMovingBack(triangle:ITriangle, chip:IChip):Boolean {
			var player:IPlayer = chip.player;
			
			if ( player.placement == PlacementTypes.TOP && chip.position > triangle.position ) {
				return true;
			}
			
			if ( player.placement == PlacementTypes.BOTTOM && chip.position < triangle.position ) {
				return true;
			}
			
			return false;
		}
	}
}