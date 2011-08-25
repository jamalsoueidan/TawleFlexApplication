package com.soueidan.games.tawla.components
{
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.soueidan.games.tawla.components.interfaces.IDice;
	import com.soueidan.games.tawla.core.Game;
	import com.soueidan.games.tawla.events.DiceEvent;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	import spark.components.Button;
	import spark.components.Label;
	import spark.components.TextInput;
	import spark.components.VGroup;
	
	public class Dice extends VGroup implements IDice
	{
		private var _dices:Array;
		
		override protected function createChildren():void {
			if ( !_dices) {
				_dices = new Array();
				var btn:TextInput = new TextInput()
				_dices.push(btn);
				btn.text = "6";
				btn.width = 30;
				addElement(btn);
				btn = new TextInput();
				btn.text = "6";
				btn.width = 30;
				addElement(btn);
				_dices.push(btn);
			}
			
			//mouseChildren = false;
			super.createChildren();
		}
		
		public function shuffle():void {
			for each(var btn:TextInput in _dices ) {
				btn.text = random();
			}
			
			Game.getInstance().dispatchEvent(new DiceEvent(DiceEvent.SHUFFLED));
		}
		
		private function random():String
		{
			return String(Math.floor(Math.random() * (1+6-1)) + 1);
		}
		
		public function get total():Number {
		 	return (leftValue + rightValue);
		}
		
		public function get all():Array {
			if ( isDouble ) {
				return [leftValue, leftValue, leftValue, leftValue];
			} else {
				return [leftValue, rightValue];
			}		
		}
		
		public function get combinations():Array {
			var combinations:Array = [];
			if ( isDouble ) {
				for(var i:int=1;i<5;i++)
				combinations.push(leftValue*i);
			} else {
				combinations.push(leftValue);
				combinations.push(rightValue);
				combinations.push(leftValue + rightValue);
			}
			return combinations;
		}
		
		public function get isDouble():Boolean {
			return ( leftValue == rightValue );
		}
		
		public function get leftValue():Number {
			return Number(_dices[0].text);
		}
		
		public function get rightValue():Number {
			return Number(_dices[1].text);
		}
		
		public function set sfsObject(value:ISFSObject):void {
			_dices[0].text = value.getInt("leftValue");
			_dices[1].text = value.getInt("rightValue");
		}
	
	}
}