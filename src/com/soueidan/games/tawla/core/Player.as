package com.soueidan.games.tawla.core
{

	import com.soueidan.games.tawla.components.Chip;
	import com.soueidan.games.tawla.components.interfaces.IChip;
	import com.soueidan.games.tawla.components.interfaces.ICup;
	import com.soueidan.games.tawla.components.interfaces.ITriangle;
	import com.soueidan.games.tawla.managers.TriangleManager;
	import com.soueidan.games.tawla.types.PlacementTypes;
	import com.soueidan.games.tawla.utils.ArrayUtil;

	public class Player implements IPlayer
	{
		private var _chips:Array = new Array();
		private var _cup:ICup;
		
		private var _color:String;
		private var _name:String;
		private var _direction:Number = 1
		private var _isHome:Boolean;
		
		public function Player(cup:ICup):void {
			super();
			
			_cup = cup;
		}
		
		public function get cup():ICup
		{
			return _cup;
		}

		public function set cup(value:ICup):void
		{
			_cup = value;
		}

		public function get color():String {
			return _color;
		}
		
		public function set color(value:String):void {
			_color = value;
		}
		
		public function get chips():Array {
			return _chips;
		}
		
		public function get isHome():Boolean {
			return _isHome;
		}

		public function set isHome(value:Boolean):void {
			_isHome = value;
		}
		
		public function set direction(value:Number):void {
			_direction = value;
		}
		
		public function get direction():Number {
			return _direction;	
		}
		
		public function set name(value:String):void {
			_name = value;	
		}
		
		public function get name():String {
			return _name;
		}
		
		public function addChip(chip:IChip):void {
			_chips.push(chip);
		}
		
		public function removeChip(chip:IChip):void {
			_chips = ArrayUtil.remove(_chips, chip);
		}
	}
}