package com.soueidan.games.tawla.types
{
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;

	public class ColorTypes
	{
		static public const WHITE:int = 0xFFFFFF;
		static public const BLACK:int = 0x000000;
		
		static public function get ALL():ArrayList {
			var all:ArrayList = new ArrayList();
			all.addItem(WHITE);
			all.addItem(BLACK);
			return all;
		}
	}
}