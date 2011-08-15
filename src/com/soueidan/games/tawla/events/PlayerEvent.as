package com.soueidan.games.tawla.events
{
	import com.soueidan.games.tawla.core.IPlayer;
	
	import flash.events.Event;
	
	public class PlayerEvent extends Event
	{
		static public const TURN_CHANGE:String = "turn_change";
		static public const IS_HOME:String = "is_home";
		static public const FINISHED_PLAYING:String = "finished_playing"; // player have no left movements in the pocket :D
		static public const NO_CHIP_MOVEMENTS:String = "no_chip_movements"; // cannot find any movements for his chip
		static public const HAVE_A_WINNER:String = "WE_have_winner";
		
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