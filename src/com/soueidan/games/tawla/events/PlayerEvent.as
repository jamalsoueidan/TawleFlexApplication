package com.soueidan.games.tawla.events
{
	import com.soueidan.games.tawla.core.IPlayer;
	
	import flash.events.Event;
	
	public class PlayerEvent extends Event
	{
		static public const TURN_CHANGE:String = "turn_change";
		
		private var _player:IPlayer;
		
		public function get player():IPlayer {
			return _player;
		}
		
		public function PlayerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, player:IPlayer=null)
		{
			super(type, bubbles, cancelable);
			_player = player;
		}
	}
}