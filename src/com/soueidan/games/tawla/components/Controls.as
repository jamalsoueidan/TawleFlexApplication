package com.soueidan.games.tawla.components
{
	import com.soueidan.games.engine.components.PanelContainer;
	import com.soueidan.games.engine.components.chat.Chat;
	import com.soueidan.games.engine.managers.ResourceManager;
	import com.soueidan.games.tawla.managers.GameManager;
	import com.soueidan.games.tawla.managers.PlayerManager;
	
	import spark.components.VGroup;
	
	public class Controls extends VGroup
	{
		private var _player1:PanelContainer;
		private var _player2:PanelContainer;
		
		private var _chatPanel:PanelContainer;
		
		public function Controls():void {
			super();
			
			setStyle("verticalCenter", 0);
			setStyle("right", 0);
			
			width = 200;
			percentHeight = 100;
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			_player1 = new PanelContainer();
			_player1.title = ResourceManager.getString("opponent");
			
			_player2 = new PanelContainer();
			_player2.title = ResourceManager.getString("myself");
			
			if ( GameManager.getInstance().parameters.debug == "true" ) {
				_player1.addElement(new Profile(PlayerManager.all[0]));
				_player2.addElement(new Profile(PlayerManager.all[1]));
			} else {
				_player1.addElement(new Profile(PlayerManager.opponent));
				_player2.addElement(new Profile(PlayerManager.myself));
			}
			

			addElement(_player1);
			
			if ( !_chatPanel ){
				_chatPanel = new PanelContainer();
				_chatPanel.title = ResourceManager.getString("chat.title");
				_chatPanel.percentHeight = 100;
				addElement(_chatPanel);
				
				var chat:Chat = new Chat();
				chat.percentHeight = 100;
				_chatPanel.addElement(chat);
			}
			
			_player2.setStyle("bottom", 0);
			addElement(_player2);
		}
	}
}