package com.soueidan.games.tawla.core
{
	import com.soueidan.games.engine.core.EngineApplication;
	import com.soueidan.games.tawla.components.*;
	import com.soueidan.games.tawla.components.interfaces.*;
	import com.soueidan.games.tawla.core.*;
	import com.soueidan.games.tawla.events.*;
	import com.soueidan.games.tawla.handlers.*;
	import com.soueidan.games.tawla.managers.*;
	import com.soueidan.games.tawla.modes.*;
	import com.soueidan.games.tawla.requests.*;
	import com.soueidan.games.tawla.responses.*;
	import com.soueidan.games.tawla.types.*;
	import com.soueidan.games.tawla.utils.*;
	
	import flash.utils.getQualifiedClassName;
	
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;

	[ResourceBundle("resources")] 
	public class Game extends EngineApplication
	{
		private var _board:Board;
		private var _dice:IDice;
		
		static public const TOTAL_PLAYER:Number = 2;
		static public const TOTAL_CHIPS:Number = 2; // how many chips to create
		
		static private var _mode:IMode;
		
		public function Game() {	
			GameManager.setGame(this);
			
			enabled = false;
		
			addEventListener(FlexEvent.APPLICATION_COMPLETE, applicationReady);
			addEventListener(ResizeEvent.RESIZE, resizeApplication);
		}
		
		private function resizeApplication(event:ResizeEvent=null):void
		{
			if (!_board ) {
				return; 
			}
			
			var newHeightSize:int = (height - _board.height);
			var newHeightScale:Number = (newHeightSize/height);
			
			var newWidthSize:int = ((width - _board.width) - 380);
			var newWidthScale:Number = (newWidthSize/width);
			
			//if ( newHeightScale > newWidthScale ) {
				
				_board.setStyle("horizontalCenter", null);
				_board.setStyle("verticalCenter", null);
				
				_board.setStyle("left", 105);
				
				if ( newWidthScale > 0 ) {
					_board.scaleX = _board.scaleY = (1+(newWidthSize/width));
				} else {
					_board.scaleX = _board.scaleY = (1+(newWidthSize/width));
				}
			/*} else {
				_board.setStyle("horizontalCenter", 0);
				_board.setStyle("verticalCenter", 0);
				
				if ( newHeightScale > 0 ) {
					_board.scaleX = _board.scaleY = (1+(newHeightSize/height));
				} else {
					_board.scaleX = _board.scaleY = (1+(newHeightSize/height));
				}
			}*/
			
			var boardHeight:Number = (_board.scaleY*_board.height);
			var cup:ICup;
			for each( var player:IPlayer in PlayerManager.all ) {
				cup = player.cup;
				cup.percentWidth = 100;
				cup.height = (boardHeight/2);
				
				if ( player.direction == PlacementTypes.BOTTOM ) {
					cup.setStyle("top",0);
				} else {
					cup.alert();
					cup.setPosition(25);
					cup.setStyle("top", cup.height);
				}
			}
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			if ( !_board ) {
				
				_board = new Board();
				resizeApplication(null);
				addElement(_board);
			}
			
			if ( !_dice) {
				_dice = DiceManager.create();
				_dice.x = 100;
				_dice.y = 200;
				addElement(_dice);
			}
		}
		
		public function addCupsToStage():void {			
			var cup:ICup;
			for each( var player:IPlayer in PlayerManager.all ) {
				cup = player.cup;
				addElementAt(cup, 0);
			}
			
			resizeApplication(null);
		}
		
		private function applicationReady(evt:FlexEvent):void {	
			MouseManager.init(this);
			MouseManager.addHandler(new DiceHandler);
			MouseManager.addHandler(new TriangleHandler);
			
			/*if ( _parameters.debug == "true" ) {
				_mode = new Local(this);
			} else {*/
				_mode = new Network(this);
			//}
			
			_mode.start();
		}
		
		public function startGame():void
		{
			addCupsToStage();
			_board.setupChips();
			
			var controls:Controls = new Controls();
			addElement(controls);
		}
		
		public function reset():void
		{
			CupManager.reset();
			PlayerManager.reset();
			_board.reset()
			DiceManager.reset();
		}
	}
}