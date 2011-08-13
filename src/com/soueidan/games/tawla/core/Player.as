package com.soueidan.games.tawla.core
{

	import com.soueidan.games.tawla.components.Chip;
	import com.soueidan.games.tawla.components.interfaces.IChip;
	import com.soueidan.games.tawla.components.interfaces.ITriangle;
	import com.soueidan.games.tawla.managers.TriangleManager;
	import com.soueidan.games.tawla.utils.ArrayUtil;

	public class Player implements IPlayer
	{
		private var _color:String;
		private var _name:String;
		private var _placement:String;
		private var _chips:Array = new Array();
		
		public function get color():String {
			return _color;
		}
		
		public function set color(value:String):void {
			_color = value;
		}
		
		public function get chips():Array {
			return _chips;
		}
		
		public function play():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function stop():void
		{
			// TODO Auto Generated method stub
			
		}
		
		private var _isHome:Boolean;
		public function get isHome():Boolean {
			return _isHome;
		}

		public function set isHome(value:Boolean):void {
			_isHome = value;
		}
		
		public function set placement(value:String):void
		{
			_placement = value;
		}
		
		public function get placement():String
		{
			return _placement;
			
		}
		
		
		public function set name(value:String):void
		{
			_name = value;	
		}
		
		public function get name():String
		{
			return _name;
			
		}
		
		public function addChip(chip:IChip):void {
			_chips.push(chip);
		}
		
		public function removeChip(chip:IChip):void {
			_chips = ArrayUtil.remove(_chips, chip);
		}
		
		public function getRandomChip():IChip {
			var num:int = Math.floor(Math.random() * (0+(_chips.length-1)-0)) + 0
			var chip:IChip = _chips[num];
			if ( chip.position == Chip.START_POSITION ) {
				var triangle:ITriangle = TriangleManager.getByChipPosition(chip);
				chip = triangle.lastChip;
			}
			return chip;
		}
	}
}