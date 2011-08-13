package com.soueidan.games.tawla.types
{
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;

	public class ColorTypes
	{
		static public const WHITE:String = "W";
		static public const BLACK:String = "B";
		
		static public function get ALL():ArrayList {
			var all:ArrayList = new ArrayList();
			all.addItem(WHITE);
			all.addItem(BLACK);
			return all;
		}
	}
}