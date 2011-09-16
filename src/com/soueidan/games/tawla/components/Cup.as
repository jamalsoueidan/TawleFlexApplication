package com.soueidan.games.tawla.components
{
	import com.soueidan.games.tawla.components.interfaces.IChip;
	import com.soueidan.games.tawla.components.interfaces.ICup;
	import com.soueidan.games.tawla.core.IPlayer;
	
	import spark.components.SkinnableContainer;
	import spark.components.VGroup;
	
	public class Cup extends SkinnableContainer implements ICup
	{
		private var _drawColor:int = 0xFF0040;
		private var _drawColorChanged:Boolean = true;
		
		private var _chips:Array = [];
		private var _position:int = 0;
		
		public function add(chip:IChip, index:Number=-1):void {	
			var player:IPlayer = chip.player;
			player.removeChip(chip);
			if ( position == 25 ) {
				chip.y -= height;
			}
			addElement(chip);
			_chips.push(chip);
		}
		
		public function remove(chip:IChip):void {
			
		}
		
		public function setPosition(value:Number):void {
			_position = value;
		}
		
		public function get lastChip():IChip {
			if ( numElements > 0 ) {
				return getElementAt((numElements-1)) as IChip;
			} else {
				return null;
			}
		}
		
		public function get firstChip():IChip {
			return null;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		
			
				_drawColorChanged = false;
				trace(unscaledHeight);
				graphics.beginFill(_drawColor);
				graphics.drawRect(0,0,unscaledWidth,unscaledHeight);
				graphics.endFill();
			
		}
		
		public function alert():void {
			_drawColor = 0x999999;
			_drawColorChanged = true;
			invalidateDisplayList();
		}
		
		public function unalert():void {
			if ( _drawColor == 0xFF0040 ) {
				return;
			}
			
			_drawColor = 0xFF0040;
			_drawColorChanged = true;
			invalidateDisplayList();
		}
		
		public function get position():Number {
			return _position;
		}
		
		public function get chips():Array {
			return _chips;
		}
		
		public function get isBottom():Boolean {
			return ( position > 12 ); 
		}
		
		public function removeAllChips():void {
			_chips = [];
			removeAllElements();
			unalert();
		}
	}
}