package com.soueidan.games.tawla.components
{
	import com.soueidan.games.tawla.components.interfaces.IChip;
	import com.soueidan.games.tawla.components.interfaces.ITriangle;
	import com.soueidan.games.tawla.core.IPlayer;
	import com.soueidan.games.tawla.types.ColorTypes;
	
	import flash.display.Bitmap;
	
	import mx.core.BitmapAsset;
	
	import spark.components.Group;
	import spark.primitives.BitmapImage;
	
	public class Chip extends Group implements IChip
	{
		static public const START_POSITION:Number = 1; // where to place chips when starting the game
		
		[Embed(source="assets/white.png")] 
		private var _white:Class;
		
		[Embed(source="assets/black.png")] 
		private var _black:Class;
		
		private var _bitmap:BitmapImage;
		
		private var _position:Number = START_POSITION;
		private var _player:IPlayer;
		private var _num:Number;
		
		private var _triangle:ITriangle;
		
		public function Chip(player:IPlayer, num:Number):void {
			super();
			
			height = width = 36;
			
			_num = num;
			_player = player;
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			if ( !_bitmap ) {
				_bitmap = new BitmapImage();
				if ( _player.color == ColorTypes.BLACK ) {
					_bitmap.source = new _black();
				} else {
					_bitmap.source = new _white();
				}
				_bitmap.smooth = true;
				_bitmap.verticalCenter = 0;
				_bitmap.horizontalCenter = 0;
				_bitmap.percentWidth = _bitmap.percentHeight = 100;
				addElement(_bitmap);
			}
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
	}
}