package com.soueidan.games.tawla.events
{
	import flash.events.Event;
	
	public class CupEvent extends Event
	{
		static public const FINISH:String = "finish";
		
		public function CupEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}