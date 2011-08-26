package com.soueidan.games.tawla.components
{
	import com.soueidan.games.tawla.components.interfaces.IChip;
	import com.soueidan.games.tawla.components.interfaces.ITriangle;
	import com.soueidan.games.tawla.core.IPlayer;
	import com.soueidan.games.tawla.events.ChipEvent;
	import com.soueidan.games.tawla.managers.TriangleManager;
	import com.soueidan.games.tawla.types.ColorTypes;
	import com.soueidan.games.tawla.types.PlacementTypes;
	
	import flash.events.Event;
	
	import spark.components.Group;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class Chip extends Group implements IChip
	{
		static public const START_POSITION:Number = 1; // where to place chips when starting the game
		
		private var _position:Number = START_POSITION;
		private var _player:IPlayer;
		private var _num:Number;
		
		private var _triangle:ITriangle;
		
		public function Chip(player:IPlayer, num:Number):void {
			super();
			
			height = width = 45;
			
			_num = num;
			_player = player;
		}
		
		public function get num():Number {
			return _num;
		}
		
		public function get player():IPlayer {
			return _player;
		}
		
		public function get position():Number {
			return _position;
		}
		
		public function set position(value:Number):void {
			_position = value;
			_triangle = parent as ITriangle;
		}
		
		public function get color():int {
			return player.color;
		}
		
		public function get isFreezed():Boolean {
			if ( _triangle.numElements == 1 ) {
				return false;
			}
			
			if ( _triangle.numElements > 1 ) {
				if ( _triangle.lastChip.color != color ) {
					return true;
				}
			}
			
			return false;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			graphics.beginFill(color);
			graphics.drawCircle(unscaledWidth/2,unscaledHeight/2,25);
			graphics.endFill();
		}
		
	}
}