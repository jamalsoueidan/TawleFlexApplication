package com.soueidan.games.tawla.components
{
	import com.soueidan.games.tawla.components.interfaces.IChip;
	import com.soueidan.games.tawla.components.interfaces.ITriangle;
	
	import flash.display.Graphics;
	
	import spark.components.Group;
	import spark.layouts.HorizontalAlign;
	import spark.layouts.VerticalAlign;
	import spark.layouts.VerticalLayout;
	
	public class Triangle extends Group implements ITriangle
	{
		private var _allowMovement:Boolean;
		private var _drawColor:int = 0x6495ED;
		private var _drawColorChanged:Boolean;
		
		private var _chips:Array = [];
		private var _position:Number;
		
		public function Triangle(position:Number):void {
			super();
			
			percentHeight = 30;
			_position = position;
			width = 52;
		}
		
		public function get chips():Array {
			return _chips;
		}
		
		override public function setStyle(styleProp:String, newValue:*):void {
			super.setStyle(styleProp, newValue);
		
			if ( styleProp == "top" || styleProp == "bottom" ) {
				var l:VerticalLayout = new VerticalLayout();
				
				l.horizontalAlign = HorizontalAlign.CENTER;
				if ( styleProp != "top" ) {
					l.verticalAlign = VerticalAlign.BOTTOM;
				}
				
				l.gap = 0;
				layout = l;
			}
			
			_drawColorChanged = true;
			invalidateDisplayList();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if ( _drawColorChanged ) {
				_drawColorChanged = false;

				var _alpha:Number = 0;
				if ( _allowMovement ) {
					_alpha = .4
				}
				graphics.clear();
				graphics.beginFill(_drawColor, 1);
				graphics.drawRect(0,0,unscaledWidth,unscaledHeight);
				graphics.endFill();
			}
		}
		
		public function add(chip:IChip, index:Number=-1):void {			
			_chips.push(chip);
			
			if ( index > -1 ) {
				addElementAt(chip, index);	
			} else {
				if ( isBottom ) {
					addElementAt(chip, 0);
				} else {
					addElement(chip);
				}
			}
			
			// this line must be after the chip is added to the element
			// or the isFreeze on the chip wouldn't work since. We set 
			// the triangle instance in the chip after new position is set
			chip.position = position;
			
			unalert();
		}
		
		public function remove(chip:IChip):void {
			var newChips:Array = [];
			for each(var local:IChip in _chips ) {
				if ( chip != local ) {
					newChips.push(local);
				}
			}
			_chips = newChips;
		}
		
		public function get lastChip():IChip {
			if ( numElements > 0 ) {
				if ( isBottom ) {
					return getElementAt(0) as IChip;
				} else {
					return getElementAt((numElements-1)) as IChip;
				}
			} else {
				return null;
			}
		}
		
		public function get firstChip():IChip {
			if ( numElements > 0 ) {
				if ( isBottom ) {
					return getElementAt((numElements-1)) as IChip;
				} else {
					return getElementAt(0) as IChip;
				}
			} else {
				return null;
			}
		}
		
		public function alert():void {
			_allowMovement = _drawColorChanged = true;
			invalidateDisplayList();
		}
		
		public function unalert():void {
			_drawColorChanged = true;
			_allowMovement = false;
			invalidateDisplayList();
		}
		
		public function get position():Number
		{
			return _position;
		}
		
		public function get isBottom():Boolean {
			return ( position > 12 ); 
		}
		
		override public function toString():String {
			return String(_position);
		}
		
		public function removeAllChips():void {
			_chips = [];
			removeAllElements();
			unalert();
		}
	}
}