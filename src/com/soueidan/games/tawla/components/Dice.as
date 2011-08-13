package com.soueidan.games.tawla.components
{
	import com.soueidan.games.tawla.core.Game;
	import com.soueidan.games.tawla.events.DiceEvent;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	import spark.components.Button;
	import spark.components.VGroup;
	import com.soueidan.games.tawla.components.interfaces.IDice;
	
	public class Dice extends VGroup implements IDice
	{
		private var _dices:Array;
		
		override protected function createChildren():void {
			if ( !_dices) {
				_dices = new Array();
				var btn:Button = new Button()
				_dices.push(btn);
				btn.label = "1";
				btn.width = 30;
				addElement(btn);
				btn = new Button();
				btn.label = "5";
				btn.width = 30;
				addElement(btn);
				_dices.push(btn);
			}
			
			mouseChildren = false;
			super.createChildren();
		}
		
		public function shuffle():void {
			for each(var btn:Button in _dices ) {
				btn.label = random();
			}
			
			Game.getInstance().dispatchEvent(new DiceEvent(DiceEvent.CHANGED));
		}
		
		private function random():String
		{
			return String(Math.floor(Math.random() * (1+6-1)) + 1);
		}
		
		public function get total():Number {
		 	return (leftValue + rightValue);
		}
		
		public function get all():Array {
			return [leftValue, rightValue];	
		}
		
		public function get leftValue():Number {
			return Number(_dices[0].label);
		}
		
		public function get rightValue():Number {
			return Number(_dices[1].label);
		}
		
		public function get isDouble():Boolean {
			return ( leftValue == rightValue )
		}
	}
}