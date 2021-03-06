package com.soueidan.games.tawla.components
{
	import com.soueidan.games.tawla.core.IPlayer;
	
	import spark.components.VGroup;
	import com.soueidan.games.tawla.components.interfaces.IChip;
	import com.soueidan.games.tawla.components.interfaces.ICup;
	
	public class Cup extends VGroup implements ICup
	{
		private var _drawColor:int = 0xFF0040;
		private var _drawColorChanged:Boolean = true;
		
		private var _chips:Array = [];
		
		public function Cup():void {
			super();

			width = 100;
			height = 100;
		}
		
		public function add(chip:IChip, index:Number=-1):void {	
			var player:IPlayer = chip.player;
			player.removeChip(chip);
			
			addElement(chip);
			_chips.push(chip);
		}
		
		public function remove(chip:IChip):void {
			
		}
		
		public function get lastChip():IChip {
			if ( numElements > 0 ) {
				return getElementAt((numElements-1)) as IChip;
			} else {
				return null;
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if ( _drawColorChanged ) {
				_drawColorChanged = false;
				
				graphics.beginFill(_drawColor);
				graphics.drawRect(0,0,unscaledWidth,unscaledHeight);
				graphics.endFill();
			}
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
		
		public function get position():Number
		{
			return 25;
		}
		
		public function get chips():Array {
			return _chips;
		}
		
	}
}