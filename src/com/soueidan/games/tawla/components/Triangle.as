package com.soueidan.games.tawla.components
{
	import com.soueidan.games.tawla.components.interfaces.IChip;
	import com.soueidan.games.tawla.components.interfaces.ITriangle;
	import com.soueidan.games.tawla.core.IPlayer;
	import com.soueidan.games.tawla.managers.TriangleManager;
	import com.soueidan.games.tawla.types.PlacementTypes;
	
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.IVisualElement;
	import mx.events.FlexEvent;
	
	import spark.components.Group;
	import spark.layouts.HorizontalAlign;
	import spark.layouts.VerticalAlign;
	import spark.layouts.VerticalLayout;
	import spark.primitives.Graphic;
	
	public class Triangle extends Group implements ITriangle
	{
		private var _drawColor:int = 0x6495ED;
		private var _drawColorChanged:Boolean;
		
		private var _chips:Array = [];
		private var _position:Number;
		
		public function Triangle(position:Number):void {
			super();
			
			percentHeight = 48;
			_position = position;
			width = 50;
		}
		
		public function get chips():Array {
			return _chips;
		}
		
		override public function setStyle(styleProp:String, newValue:*):void {
			super.setStyle(styleProp, newValue);
		
			if ( styleProp == "top" || styleProp == "bottom" ) {
				var l:VerticalLayout = new VerticalLayout();
				
				if ( styleProp == "top" ) {
					l.horizontalAlign = HorizontalAlign.CENTER;
				} else {
					l.verticalAlign = VerticalAlign.BOTTOM;
				}
				
				layout = l;
			}
			_drawColorChanged = true;
			invalidateDisplayList();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if ( _drawColorChanged ) {
				_drawColorChanged = false;

				var g:Graphics = this.graphics;	
				g.beginFill(_drawColor);
				g.drawRect(0,0,unscaledWidth,unscaledHeight);
				g.endFill();
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
		
		public function alert():void {
			_drawColor = 0x666666;
			_drawColorChanged = true;
			invalidateDisplayList();
		}
		
		public function unalert():void {
			if ( _drawColor == 0x6495ED ) {
				return;
			}
			
			_drawColor = 0x6495ED;
			_drawColorChanged = true;
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