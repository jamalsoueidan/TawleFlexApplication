package com.soueidan.games.tawla.assets
{
	import mx.core.BitmapAsset;
	
	public class UserAsset
	{
		[Embed(source="assets/white.png")] 
		private static var _white:Class;
		public static function get white():BitmapAsset { return new _white();}
		
		[Embed(source="assets/black.png")] 
		private static var _black:Class;
		public static function get black():BitmapAsset { return new _black();}
	}
}