package com.soueidan.games.tawla.managers
{
	import com.soueidan.games.tawla.components.Cup;
	import com.soueidan.games.tawla.components.interfaces.IChip;
	import com.soueidan.games.tawla.components.interfaces.ICup;
	import com.soueidan.games.tawla.core.IPlayer;

	public class CupManager
	{
		static private var _cup:ICup;
		
		static public function create():ICup {
			if ( !_cup ) {
				_cup = new Cup();
			}
			
			return _cup;
		}
		
		static public function get cup():ICup {
			return create();
		}
	}
}