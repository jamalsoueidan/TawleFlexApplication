package com.soueidan.games.tawla.events
{
	import flash.events.Event;
	
	public class ChipEvent extends Event
	{
		static public const MOVED:String = "Moved";
		private var _moves:Number;
		
		public function get moves():Number {
			return _moves;
		}
		
		public function ChipEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, moves:Number=0):void
		{
			_moves = moves;
			super(type, bubbles, cancelable);
		}
	}
}