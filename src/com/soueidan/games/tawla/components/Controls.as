package com.soueidan.games.tawla.components
{
	import com.soueidan.games.tawla.core.IPlayer;
	import com.soueidan.games.tawla.managers.PlayerManager;
	
	import spark.components.VGroup;
	
	public class Controls extends VGroup
	{
		public function Controls():void {
			super();
			
			setStyle("right", 0);
			setStyle("top", 0);
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			var profile:Profile;
			for each(var player:IPlayer in PlayerManager.all ) {
				profile = new Profile(player);
				addElement(profile);
			}
		}
	}
}