package com.soueidan.games.tawla.core
{

	import com.smartfoxserver.v2.entities.SFSUser;
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
		
		private var _color:int;
		private var _name:String;
		private var _direction:Number = 1
		private var _isHome:Boolean;
		
		private var _sfsUser:SFSUser;
		
		public function Player(cup:ICup, user:SFSUser):void {
			super();
			
			_cup = cup;
			
			_sfsUser = user;
		}
		
		public function get id():int {
			return _sfsUser.id;
		}
		
		public function get sfsUser():SFSUser
		{
			return _sfsUser;
		}
		
		
		public function get cup():ICup
		{
			return _cup;
		}

		public function set cup(value:ICup):void
		{
			_cup = value;
		}

		public function get color():int {
			return _color;
		}
		
		public function set color(value:int):void {
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
		
		public function get name():String {
			return _sfsUser.name;
		}
		
		public function addChip(chip:IChip):void {
			_chips.push(chip);
		}
		
		public function get isRegistered():Boolean {
			return _sfsUser.getVariable("isRegistered").getBoolValue();
		}
		
		public function removeChip(chip:IChip):void {
			_chips = ArrayUtil.remove(_chips, chip);
		}
	}
}