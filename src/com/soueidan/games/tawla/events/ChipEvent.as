package com.soueidan.games.tawla.events
{
	import flash.events.Event;
	
	public class ChipEvent extends Event
	{
		static public const MOVED:String = "Moved";
		
		private var _move:int;
		private var _chipNum:int;
		
		public function ChipEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, chipNum:int=0, move:int=0):void
		{
			_move = move;
			_chipNum = chipNum;
			super(type, bubbles, cancelable);
		}
		
		
		public function get move():int
		{
			return _move;
		}

		public function get chipNum():int
		{
			return _chipNum;
		}

		
	}
}