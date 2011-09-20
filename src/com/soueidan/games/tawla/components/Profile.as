package com.soueidan.games.tawla.components
{
	import com.soueidan.games.engine.components.user.UserBase;
	import com.soueidan.games.engine.managers.ResourceManager;
	import com.soueidan.games.engine.skins.HContainerSkin;
	import com.soueidan.games.tawla.assets.UserAsset;
	import com.soueidan.games.tawla.core.IPlayer;
	import com.soueidan.games.tawla.types.ColorTypes;
	
	import flash.events.Event;
	
	import spark.components.Image;
	import spark.components.Label;
	import spark.components.SkinnableContainer;
	import spark.components.VGroup;
	
	public class Profile extends UserBase
	{
		private var _imageGroup:SkinnableContainer;
		private var _imageChip:Image;
		
		private var _player:IPlayer;
		private var _playerChanged:Boolean;

		private var _score:Label;
		
		public function Profile(player:IPlayer):void
		{
			super();
			
			user = player.sfsUser;
			
			_player = player;
			_player.addEventListener("SCORE", updateScore);
			_playerChanged = true;
			
			invalidateProperties();
		}
		
		private function updateScore(evt:Event):void
		{
			_playerChanged = true;
			invalidateProperties();
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			_restTextGroup.removeAllElements();
			
			if (!_score ) {
				_score = new Label();
				_restTextGroup.addElement(_score);
			}
		}
		
		override protected function commitProperties():void {
			super.commitProperties();
			
			if ( _playerChanged ) {
				_playerChanged = false;
				
				_score.text = ResourceManager.getString("user.score") + ": " + _player.score.toString();
			}
		}
		
	
	}
}