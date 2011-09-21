package com.soueidan.games.tawla.components
{
	import com.gskinner.motion.GTween;
	import com.soueidan.games.tawla.components.interfaces.IChip;
	import com.soueidan.games.tawla.components.interfaces.ITriangle;
	import com.soueidan.games.tawla.types.PlacementTypes;
	
	import flash.geom.Point;
	
	import spark.components.SkinnableContainer;
	
	public class Triangle extends SkinnableContainer implements ITriangle
	{
		private var _allowMovement:Boolean;
		private var _drawColor:int = 0x6495ED;
		private var _drawColorChanged:Boolean;
		
		private var _chips:Array = [];
		private var _chipsChanged:Boolean;
		
		private var _tweenEnabled:Boolean;
		private var _position:Number;
		
		private var _lastPosition:Point;
		
		public function Triangle(position:Number):void {
			super();
			
			percentHeight = 45;
			_position = position;
			width = 52;
		}
		
		public function get chips():Array {
			return _chips;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if ( _chipsChanged ) {
				_chipsChanged = false;
				
				if ( isBottom ) {
					placeBottom();
				} else {
					placeTop();
				}
				
				_tweenEnabled = true;
			}
			
			
			if ( _drawColorChanged ) {
				_drawColorChanged = false;

				var _alpha:Number = 0;
				if ( _allowMovement ) {
					_alpha = .4
				}
				graphics.clear();
				graphics.beginFill(_drawColor, _alpha);
				graphics.drawRect(0,0,unscaledWidth,unscaledHeight);
				graphics.endFill();
			}
		}
		
		private function placeTop():void
		{
			var chip:Chip;
			var positionX:int = 6;
			var positionY:int = 0;
			for(var i:int=0;i<_chips.length;i++) {				
				chip = _chips[i] as Chip;
				
				if ( !_tweenEnabled ) {
					chip.x = positionX;
					chip.y = positionY;
				} else {
					var myTween:GTween = new GTween(chip,1);
					myTween.proxy.x = positionX;
					myTween.proxy.y = positionY;
				}
				
				if ( _chips.length > 5 && _chips.length < 11) {
					positionY += chip.height/1.3;
				}
				
				if ( _chips.length > 10 ) {
					positionY += chip.height/2;
				}
				
				_lastPosition = new Point(positionX, positionY);
			}
		}
		
		private function placeBottom():void
		{
			var chip:Chip;
			var positionX:int = 6;
			var positionY:int = 0;
			for(var i:int=0;i<_chips.length;i++) {
				
				chip = _chips[i] as Chip;
				
				if ( i == 0 ) {
					positionY = height - chip.height;
				}
				
				if ( !_tweenEnabled ) {
					chip.x = positionX;
					chip.y = positionY;
				} else {
					var myTween:GTween = new GTween(chip,1);
					myTween.proxy.x = positionX;
					myTween.proxy.y = positionY;
				}
				
				if ( _chips.length > 5 && _chips.length < 11) {
					positionY -= chip.height/1.3;
				}
				
				if ( _chips.length > 10 ) {
					positionY -= chip.height/2;
				}
				
				_lastPosition = new Point(positionX, positionY);
			}
		}
		
		public function chipPosition(chip:IChip):Point {
			if ( !_lastPosition ) {
				if ( isBottom ) {
					_lastPosition = new Point(6,chip.height);
				} else {
					_lastPosition = new Point(6,0);
				}
			}
			
			return localToGlobal(_lastPosition);
		}
		
		public function add(chip:IChip, index:Number=-1):void {
			chip.triangle = this;
			_chips.push(chip);
			addElement(chip);
			updateList();
			
			// this line must be after the chip is added to the element
			// or the isFreeze on the chip wouldn't work since. We set 
			// the triangle instance in the chip after new position is set
			chip.position = position;
			
			unalert();
		}
		
		private function updateList():void
		{
			_chipsChanged = true;
			invalidateDisplayList();
		}
		
		public function remove(chip:IChip):void {
			for(var i:int=0;i<_chips.length;i++){
				if ( chip.num == _chips[i].num ) {
					_chips.splice(i,1);
				}
			}
			updateList();
		}
		
		public function get lastChip():IChip {
			if ( _chips.length == 0 ) {
				return null;
			}
			
			return _chips[(_chips.length-1)];
			
		}
		
		public function get firstChip():IChip {
			if ( _chips.length == 0 ) {
				return null;
			}
			
			return _chips[0];
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