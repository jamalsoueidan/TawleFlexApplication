package com.soueidan.games.tawla.types
{
	import mx.collections.ArrayList;

	public class PlacementTypes
	{
		static public const TOP:String = "top";
		static public const BOTTOM:String = "bottom";
		
		static public function get ALL():ArrayList {
			var all:ArrayList = new ArrayList();
			all.addItem(TOP);
			all.addItem(BOTTOM);
			return all;
		}
	}
}