package com.soueidan.games.tawla.events
{
	import flash.events.Event;
	
	public class DiceEvent extends Event
	{
		static public const CHANGED:String = "done";
		
		public function DiceEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}