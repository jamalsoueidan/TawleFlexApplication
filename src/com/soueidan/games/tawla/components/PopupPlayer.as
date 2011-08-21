package com.soueidan.games.tawla.components
{
	import com.soueidan.games.tawla.core.IPlayer;
	import com.soueidan.games.tawla.managers.PlayerManager;
	import com.soueidan.games.tawla.types.ColorTypes;
	import com.soueidan.games.tawla.types.PlacementTypes;
	
	import flash.events.MouseEvent;
	
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.Button;
	import spark.components.List;
	import spark.components.TextInput;
	import spark.components.TitleWindow;
	import spark.components.VGroup;
	import spark.layouts.supportClasses.LayoutBase;

	public class PopupPlayer extends TitleWindow
	{
		private var _container:VGroup;
		
		private var _textField:TextInput;
		private var _submit:Button;
		private var _colorList:List;
		private var _placementList:List;
		
		public function PopupPlayer():void {
			super();
			
			title = "New player";
			
			addEventListener(CloseEvent.CLOSE, submitted);
		}
		
		override protected function childrenCreated():void
		{
			if ( !_container ) {
				_container = new VGroup;
				addElement(_container);
			}
			
			if ( !_textField ) {
				_textField = new TextInput();
				_container.addElement(_textField);
			}
			
			if (!_colorList ) {
				_colorList = new List();
				_colorList.dataProvider = ColorTypes.ALL;
				_container.addElement(_colorList);
			}
			
			if ( !_placementList ){
				_placementList = new List();
				_placementList.dataProvider = PlacementTypes.ALL;
				_container.addElement(_placementList);
			}
			
			if ( !_submit ) {
				_submit = new Button();
				_submit.label = "Submit";
				_submit.addEventListener(MouseEvent.CLICK, submitted);
				_container.addElement(_submit);
			}
			
			super.childrenCreated();
		}
		
		private function submitted(evt:*):void {
			/*var player:IPlayer = PlayerManager.create();
			player.name = _textField.text;
			
			player.color = _colorList.selectedItem;
			//player.placement = _placementList.selectedItem;
			
			PlayerManager.add(player);
			
			PopUpManager.removePopUp(this);*/
		}
		
	}
}