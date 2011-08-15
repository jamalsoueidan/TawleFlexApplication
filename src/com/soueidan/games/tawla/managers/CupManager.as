package com.soueidan.games.tawla.managers
{
	import com.soueidan.games.tawla.components.Cup;
	import com.soueidan.games.tawla.components.interfaces.IChip;
	import com.soueidan.games.tawla.components.interfaces.ICup;
	import com.soueidan.games.tawla.core.IPlayer;

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
	}
}