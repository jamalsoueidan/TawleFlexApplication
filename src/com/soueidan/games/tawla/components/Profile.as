package com.soueidan.games.tawla.components
{
	import com.soueidan.games.tawla.core.IPlayer;
	import com.soueidan.games.tawla.types.ColorTypes;
	
	import spark.components.Label;
	import spark.components.VGroup;
	
	public class Profile extends VGroup
	{
		private var _player:IPlayer;
		private var _playerChanged:Boolean;
		
		private var _nickname:Label;
		private var _isRegistered:Label;
		private var _score:Label;
		
		public function Profile(player:IPlayer):void
		{
			super();
			
			
			paddingLeft = paddingTop = paddingBottom = paddingRight = 20;
			
			_player = player;
			_playerChanged = true;
			invalidateProperties();
		}
		
		override protected function childrenCreated():void {
			super.createChildren();
			
			if ( !_nickname ) {
				_nickname = new Label();
				_nickname.setStyle("fontSize", 18);
				addElement(_nickname);
			}
			
			if ( !_isRegistered ) {
				_isRegistered = new Label();
				_isRegistered.setStyle("fontSize", 18);
				addElement(_isRegistered);
			}
			
			if (!_score ) {
				_score = new Label();
				_score.setStyle("fontSize", 18);
				addElement(_score);
			}
			
			if ( _player.color == ColorTypes.BLACK ) {
				_nickname.setStyle("color", "#FFFFFF");
				_isRegistered.setStyle("color", "#FFFFFF");
				_score.setStyle("color", "#FFFFFF");
			}
			
		}
		
		override protected function commitProperties():void {
			if ( _playerChanged ) {
				_playerChanged = false;
				
				_nickname.text = "Nickname: " + _player.name;
				if ( _player.isRegistered ) {
					_isRegistered.text = "Status: Registered";
				} else {
					_isRegistered.text = "Status: Guest";
				}
								
				_score.text = "Score: " + _player.score.toString();
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			if ( _player ) {
				graphics.beginFill(_player.color);
				graphics.drawRect(0,0,unscaledWidth, unscaledHeight);
				graphics.endFill();
			}
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
	}
}