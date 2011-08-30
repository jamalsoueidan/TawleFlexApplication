package com.soueidan.games.tawla.core
{
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
	
	import mx.events.FlexEvent;
	
	import org.osflash.thunderbolt.Logger;
	
	import spark.components.Application;

	
	public class Game extends Application
	{
		private var _board:Board;
		private var _dice:IDice;
	
		static private var _instance:Game;
		
		static public const TOTAL_PLAYER:Number = 2;
		static public const TOTAL_CHIPS:Number = 5; // how many chips to create
		
		static private var _mode:IMode;
		
		static public function getInstance():Game {
			return _instance;
		}
		
		public function Game() {	
			_instance = this;
			
			Logger.includeTime = false;
			Logger.showCaller = false;
			Logger.console = true;
			
			enabled = false;
			
			addEventListener(FlexEvent.APPLICATION_COMPLETE, applicationReady);
		}
		
		override protected function createChildren():void {
			super.createChildren();
			
			if ( !_board ) {
				_board = new Board();
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
				if ( player.direction == PlacementTypes.BOTTOM ) {
					cup.setStyle("top",100);
				} else {
					cup.setPosition(25);
					cup.setStyle("bottom",200);
				}
				addElement(cup);
			}
		}
		
		private function applicationReady(evt:FlexEvent):void {						
			MouseManager.init(this);
			MouseManager.addHandler(new DiceHandler);
			MouseManager.addHandler(new TriangleHandler);
			
			_mode = new Network(this);
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