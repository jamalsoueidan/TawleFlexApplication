package com.soueidan.games.tawla.core
{
	import com.soueidan.games.tawla.components.*;
	import com.soueidan.games.tawla.components.interfaces.*;
	import com.soueidan.games.tawla.core.*;
	import com.soueidan.games.tawla.events.*;
	import com.soueidan.games.tawla.handlers.*;
	import com.soueidan.games.tawla.managers.*;
	import com.soueidan.games.tawla.modes.IMode;
	import com.soueidan.games.tawla.modes.Network;
	import com.soueidan.games.tawla.requests.*;
	import com.soueidan.games.tawla.responses.*;
	import com.soueidan.games.tawla.types.*;
	import com.soueidan.games.tawla.utils.*;
	import com.soueidan.smartfoxclient.core.SmartFoxClient;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;
	
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	import org.osflash.thunderbolt.Logger;
	
	import spark.components.Application;
	import spark.components.Button;
	import spark.components.VGroup;

	
	public class Game extends Application
	{
		private var _board:Board;
		private var _dice:IDice;
	
		static private var _instance:Game;
		
		static public const TOTAL_PLAYER:Number = 2;
		static public const TOTAL_CHIPS:Number = 1; // how many chips to create
		
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
		
		public function createCupsForPlayers():void {
			for each(var player:IPlayer in PlayerManager.all ) {
				var cup:ICup;
				cup = player.cup;
				cup.setStyle("left", 150);
				if ( player.direction == PlacementTypes.BOTTOM ) {
					cup.setStyle("top",160);
				} else {
					cup.setStyle("bottom",160);
				}
				addElement(cup);
			}
		}
		
		private function applicationReady(evt:FlexEvent):void {						
			MouseManager.init(this);
			MouseManager.addHandler(new DiceHandler);
			MouseManager.addHandler(new TriangleHandler);
			
			var mode:IMode = new Network(this);
			mode.start();
		}
		
		public function startGame():void
		{
			createCupsForPlayers();
			_board.setupChips();
			
			var controls:Controls = new Controls();
			addElement(controls);
		}
	}
}