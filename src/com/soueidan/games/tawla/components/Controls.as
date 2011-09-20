package com.soueidan.games.tawla.components
{
	import com.soueidan.games.engine.components.PanelContainer;
	import com.soueidan.games.engine.components.chat.ChatPanel;
	import com.soueidan.games.engine.managers.EngineApplicationManager;
	import com.soueidan.games.engine.managers.ResourceManager;
	import com.soueidan.games.tawla.core.IPlayer;
	import com.soueidan.games.tawla.events.PlayerEvent;
	import com.soueidan.games.tawla.managers.GameManager;
	import com.soueidan.games.tawla.managers.PlayerManager;
	
	import spark.components.VGroup;
	
	public class Controls extends VGroup
	{
		private var _player1:PlayerPanel;
		private var _player2:PlayerPanel;
		
		private var _chatPanel:PanelContainer;
		
		public function Controls():void {
			super();
			
			setStyle("verticalCenter", 0);
			setStyle("right", 0);
			
			width = 200;
			percentHeight = 100;
			
			EngineApplicationManager.getInstance().addEventListener(PlayerEvent.TURN_CHANGE, turnChange);
		}
		
		protected function turnChange(event:PlayerEvent):void
		{
			_player1.enabled = false;
			_player2.enabled = false;
			
			//trace(event.player.name, _player1.player.name, _player2.player.name);
			if ( event.player.id == _player1.player.id ) {
				_player1.enabled = true;
			}
			
			if ( event.player.id == _player2.player.id ) {
				_player2.enabled = true;
			}
		}		
		
		
		override protected function createChildren():void {
			super.createChildren();
			
			var opponnent:IPlayer; 
			var myself:IPlayer;
			
			/*if ( GameManager.getInstance().parameters.debug == "true" ) {
				opponnent = PlayerManager.all[0];
				myself = PlayerManager.all[1];
			} else {*/
				opponnent = PlayerManager.opponent;
				myself = PlayerManager.myself;
			//}
			
			_player1 = new PlayerPanel();
			_player1.title = ResourceManager.getString("opponent");
			_player1.player = opponnent;
			addElement(_player1);
			
			// add chat to controls
			if ( !_chatPanel ){
				_chatPanel = new ChatPanel();
				addElement(_chatPanel);
			}
			
			// player 2 add chip tot titlebar
			_player2 = new PlayerPanel();
			_player2.title = ResourceManager.getString("myself");
			_player2.player = myself;
			_player2.setStyle("bottom", 0);
			addElement(_player2);
		}
	}
}