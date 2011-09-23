package com.soueidan.games.tawla.handlers
{
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.smartfoxserver.v2.requests.IRequest;
	import com.smartfoxserver.v2.requests.ObjectMessageRequest;
	import com.soueidan.games.engine.managers.ServerManager;
	import com.soueidan.games.engine.managers.ToolTipManager;
	import com.soueidan.games.tawla.components.Chip;
	import com.soueidan.games.tawla.components.interfaces.IChip;
	import com.soueidan.games.tawla.components.interfaces.ITriangle;
	import com.soueidan.games.tawla.core.Game;
	import com.soueidan.games.tawla.events.ChipEvent;
	import com.soueidan.games.tawla.managers.DiceManager;
	import com.soueidan.games.tawla.managers.PlayerManager;
	import com.soueidan.games.tawla.managers.TriangleManager;
	import com.soueidan.games.tawla.requests.ChipMovedRequest;
	import com.soueidan.games.tawla.requests.MouseMovementRequest;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	
	import mx.core.FlexGlobals;
	import mx.events.Request;

	public class TriangleHandler implements IHandler
	{
		private var _game:Game;
		
		private var _chip:IChip; // current chip that we have catched from mouse down
		
		private var _oldTriangle:ITriangle;
		private var _oldNumChildren:int;
		
		private var _newTriangle:ITriangle; // current triangle the mouse is over at the moment in the enter_frame

		public function TriangleHandler():void {
			super();
			
			_game = FlexGlobals.topLevelApplication as Game;
		}
		
		public function down(evt:MouseEvent):void
		{
			var check:Boolean = evt.target is Chip;
			if ( !check ) {
				return;
			}
			
			// check if the checker belongs to this current player who turn is on
			var chip:IChip = evt.target as IChip;
			if ( !PlayerManager.currentPlayerTurnBelongsThisChipTo(chip) ) {
				return;
			}
			
			if ( chip.isFreezed ) {
				return;
			}
			
			ToolTipManager.hide();
			
			_chip = chip;
			
			_oldTriangle = _chip.triangle;
			_oldNumChildren = _oldTriangle.getElementIndex(_chip);
			
			// cannot be moved below next linies because we use parent in the register method
			TriangleManager.showMovementsOnBoard(chip);
			
			_oldTriangle.remove(_chip);
			_game.addElement(_chip);
			
			var params:ISFSObject = new SFSObject();
			params.putUtfString("cmd", ChipMovedRequest.action);
			params.putUtfString("action", "down");
			params.putInt("chip_num", _chip.num);
			var request:IRequest = new ObjectMessageRequest(params);
			ServerManager.getInstance().send(request);
		}
		
		public function up(evt:MouseEvent):void
		{			
			if ( !_chip ) {
				return;
			}
			
			TriangleManager.removeAllMovementsOnBoard();
						
			if ( _newTriangle ) {
				// CANNOT BE CHANGED BELOW _newTriangle.add(_chip); BECAUSE add METHOD CHANGE CHIP POSITION
				// AND THEN WE CANNOT KNOW FROM TO WHERE THE CHIP WAS MOVED
				var move:int = DiceManager.registerMovement(_newTriangle, _chip);
				
				_newTriangle.add(_chip);
				_oldTriangle.remove(_chip);
				
				_game.dispatchEvent(new ChipEvent(ChipEvent.MOVED, false, false, _chip.num, move));
				
				// you cannot move these two lines below to the end of this method because we 
				// need to ensure which method gets called this or next.
				
				_chip = null;
				_newTriangle = null;
				_oldTriangle = null;
			}
			
			if ( _chip ) {
				var params:ISFSObject = new SFSObject();
				params.putUtfString("cmd", ChipMovedRequest.action); 
				params.putUtfString("action", "up");
				params.putInt("chip_num", _chip.num);
				var request:IRequest = new ObjectMessageRequest(params);
				ServerManager.getInstance().send(request);
				
				
				_oldTriangle.add(_chip);
				
				_chip.x = _game.board.mouseX - 34;
				_chip.y = _game.board.mouseY - 34;
				
				_chip = null;
			}
			
		}
		
		public function update(evt:Event):void
		{
			if ( !_chip ) {
				return;
			}
			
			_chip.x = _game.mouseX - (_chip.width/2);
			_chip.y = _game.mouseY - (_chip.height/2);
			
			var hitAnything:Boolean;
			for each(var triangle:ITriangle in TriangleManager.movements ) {
				if ( _chip.hitTestObject(triangle as DisplayObject)) {
					_newTriangle = triangle;
					hitAnything = true;
				}
			}
			
			if ( !hitAnything || _newTriangle.position == _oldTriangle.position ) {
				_newTriangle = null;
			}
		}
	}
}