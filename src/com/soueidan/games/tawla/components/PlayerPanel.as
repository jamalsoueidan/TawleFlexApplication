package com.soueidan.games.tawla.components
{
	import com.soueidan.games.engine.components.PanelContainer;
	import com.soueidan.games.tawla.assets.UserAsset;
	import com.soueidan.games.tawla.core.IPlayer;
	import com.soueidan.games.tawla.types.ColorTypes;
	
	import spark.components.HGroup;
	import spark.components.Image;

	public class PlayerPanel extends PanelContainer 
	{
		private var _profile:Profile;
		
		private var _player:IPlayer;
		private var _playerChanged:Boolean;

		public function get player():IPlayer
		{
			return _player;
		}

		public function set player(value:IPlayer):void
		{
			_player = value;
			_playerChanged = true;
			invalidateDisplayList();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if ( _playerChanged ) {
				_playerChanged = false;

				var content:HGroup = titleGroupContent;
				
				var imageChip:Image = new Image();
				if ( _player.color == ColorTypes.BLACK ) {
					imageChip.source = UserAsset.black;
				} else {
					imageChip.source = UserAsset.white;
				}
				content.addElementAt(imageChip, 0);
				
				_profile = new Profile(_player);
				
				addElement(_profile);

			}
		}

	}
}