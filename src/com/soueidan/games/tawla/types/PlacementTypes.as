package com.soueidan.games.tawla.types
{
	import mx.collections.ArrayList;

	public class PlacementTypes
	{
		static public const TOP:Number = 1;
		static public const BOTTOM:Number = -1;
		
		static public function get ALL():ArrayList {
			var all:ArrayList = new ArrayList();
			all.addItem(TOP);
			all.addItem(BOTTOM);
			return all;
		}
	}
}