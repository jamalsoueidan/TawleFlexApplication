package com.soueidan.games.tawla.components
{
	import com.soueidan.games.tawla.core.IPlayer;
	import com.soueidan.games.tawla.managers.PlayerManager;
	
	import spark.components.HGroup;
	
	public class Controls extends HGroup
	{
		public function Controls():void {
			super();
			
			percentWidth = 100;
			
			setStyle("bottom", 0);
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