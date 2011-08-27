package com.soueidan.games.tawla.managers
{
	import com.soueidan.games.tawla.components.Cup;
	import com.soueidan.games.tawla.components.interfaces.ICup;

	public class CupManager
	{
		static private var _cups:Array = [];
		
		static public function create():ICup {
			var _cup:ICup = new Cup();	
			_cups.push(_cup);
			return _cup;
		}
		
		static public function get cups():Array {
			return _cups;
		}
		
		public static function reset():void
		{
			for each(var cup:ICup in _cups ) {
				cup.removeAllChips();
			}
			
		}
	}
}