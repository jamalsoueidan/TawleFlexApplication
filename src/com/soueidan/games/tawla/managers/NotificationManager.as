package com.soueidan.games.tawla.managers
{
	import com.soueidan.games.engine.managers.NotificationManager;
	import com.soueidan.games.engine.managers.ResourceManager;
	import com.soueidan.games.engine.managers.ToolTipManager;
	import com.soueidan.games.tawla.components.Board;
	import com.soueidan.games.tawla.components.interfaces.ITriangle;
	import com.soueidan.games.tawla.core.IPlayer;
	import com.soueidan.games.tawla.types.ColorTypes;
	import com.soueidan.games.tawla.types.PlacementTypes;
	
	import flash.geom.Point;
	
	import mx.controls.ToolTip;
	import mx.core.UIComponent;

	public class NotificationManager
	{
	
		private static var _alreadyShowWaiting:Boolean;
		private static var _alreadyShowTooltip:Boolean;
		
		public static function createWaitingPanel(player:IPlayer, second:Boolean=false):void {
			if ( PlayerManager.isMyTurn || _alreadyShowWaiting)
				return;
			
			_alreadyShowWaiting = true;
			
			com.soueidan.games.engine.managers.NotificationManager.show(null, ResourceManager.getString("start_game.wait_turn"));
		}
		
		public static function createStartTooltip(player:IPlayer, second:Boolean=false):void
		{
			com.soueidan.games.engine.managers.NotificationManager.hide();
			
			if ( !PlayerManager.isMyTurn || _alreadyShowTooltip) 
				return;
			
			_alreadyShowTooltip = true;
			
			var triangle:ITriangle = TriangleManager.getByPosition(player.startPosition);
			var board:Board = GameManager.getInstance().board;
			var position:Point = board.localToGlobal(new Point(triangle.x, triangle.y));
			
			if ( player.direction == PlacementTypes.BOTTOM ) {
				position.y -= 42;
			} else {
				position.y += triangle.height;					
			}
			position.x -= 60;
			
			var msg:String;
			if ( player.color == ColorTypes.BLACK ) {
				msg = ResourceManager.getString("notification.black_first");
				if ( second ) {
					msg = ResourceManager.getString("notification.black_second");
				} 
			} else {
				msg = ResourceManager.getString("notification.white_first");
				if ( second ) {
					msg = ResourceManager.getString("notification.white_second");
				} 
			}
			
			var toolTip:ToolTip = ToolTipManager.show(msg, UIComponent(triangle), board, position);
			toolTip.setStyle("backgroundColor",0xFFCC00);
		}
	}
}