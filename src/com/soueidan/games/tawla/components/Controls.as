package com.soueidan.games.tawla.components
{
	import com.smartfoxserver.v2.entities.SFSUser;
	import com.soueidan.games.engine.components.TabContainer;
	import com.soueidan.games.engine.core.EngineApplication;
	import com.soueidan.games.engine.managers.ClientManager;
	import com.soueidan.games.tawla.core.IPlayer;
	import com.soueidan.games.tawla.managers.GameManager;
	import com.soueidan.games.tawla.managers.PlayerManager;
	
	import spark.components.VGroup;
	
	public class Controls extends VGroup
	{
		private var _player1:TabContainer;
		private var _player2:TabContainer;
		
		private var _chat:TabContainer;
		
		public function Controls():void {
			super();
			
			setStyle("top", 5);
			setStyle("right", 0);
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			_player1 = new TabContainer();
			_player2 = new TabContainer();
			_player1.title = "Oppount";
			_player2.title = "Me";
			
			if ( GameManager.getInstance().parameters.debug == "true" ) {
				_player1.addElement(new Profile(PlayerManager.all[0]));
				_player2.addElement(new Profile(PlayerManager.all[1]));
			} else {
				_player1.addElement(new Profile(PlayerManager.opponent));
				_player2.addElement(new Profile(PlayerManager.myself));
			}
			
			addElement(_player1);
			
			if ( !_chat ){
				_chat = new TabContainer();
				_chat.title = "Chat";
				addElement(_chat);
			}
			
			addElement(_player2);
		}
	}
}