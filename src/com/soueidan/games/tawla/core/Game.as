package com.soueidan.games.tawla.core
{
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.SFSUser;
	import com.smartfoxserver.v2.entities.User;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.smartfoxserver.v2.requests.ExtensionRequest;
	import com.soueidan.games.tawla.components.*;
	import com.soueidan.games.tawla.components.interfaces.*;
	import com.soueidan.games.tawla.core.*;
	import com.soueidan.games.tawla.events.*;
	import com.soueidan.games.tawla.handlers.*;
	import com.soueidan.games.tawla.managers.*;
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
		
		private var _server:SmartFoxClient;
		
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
		
		public function addListener():void {
			addEventListener(DiceEvent.CHANGED, diceChanged);
			addEventListener(ChipEvent.MOVED, chipMoved);
			addEventListener(PlayerEvent.TURN_CHANGE, playerTurnChanged);
			addEventListener(PlayerEvent.IS_HOME, playerIsHome);
			addEventListener(PlayerEvent.HAVE_A_WINNER, haveAWinner);
			addEventListener(PlayerEvent.FINISHED_PLAYING, finishedPlaying);
			addEventListener(PlayerEvent.NO_CHIP_MOVEMENTS, noChipMovements);
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
			_server = SmartFoxClient.getInstance();
			
			_server.addResponseHandler(StartGameResponse.START_GAME, StartGameResponse);
			_server.addResponseHandler(EndGameResponse.END_GAME, EndGameResponse);
			
			_server.addResponseHandler(ChipMovedResponse.CHIP_MOVED, ChipMovedResponse);
			_server.addResponseHandler(NextPlayerTurnResponse.NEXT_PLAYER_TURN, NextPlayerTurnResponse);
			_server.addResponseHandler(PlayerIsHomeResponse.PLAYER_IS_HOME, PlayerIsHomeResponse);
			_server.addResponseHandler(PlayerIsWinnerResponse.PLAYER_WIN_ROUND, PlayerIsWinnerResponse);
			_server.addResponseHandler(PlayerIsWinnerResponse.PLAYER_WIN_GAME, PlayerIsWinnerResponse);
			
			MouseManager.init(this);
			MouseManager.addHandler(new DiceHandler);
			MouseManager.addHandler(new TriangleHandler);
			
			addListener();
		}
		
		private function playerTurnChanged(evt:PlayerEvent):void {
			trace("player turn changed");
			if ( _server.mySelf.id == evt.player.id ) {
				MouseManager.listen();
			} else {
				MouseManager.stop();
			}
		}
		
		private function diceChanged(evt:DiceEvent):void {
			trace("player cannot move");
			if ( !GameManager.canPlay ) {
				nextTurn();
			}
		}
		
		private function chipMoved(evt:ChipEvent):void {
			trace("chip moved");
			var extension:ChipMovedRequest = new ChipMovedRequest(evt);
			_server.send(extension);
			
			GameManager.finishedPlaying();
			TriangleManager.removeAllMovementsOnBoard();
		}
		
		private function playerIsHome(evt:PlayerEvent):void {
			trace("player is home");
			var playerHomeRequest:PlayerIsHomeRequest = new PlayerIsHomeRequest(evt);
			_server.send(playerHomeRequest);
		}
		
		
		private function haveAWinner(evt:PlayerEvent):void {			
			if ( GameManager.winnerExists ) {
				trace("I won the round");
				var request:PlayerIsWinnerRequest = new PlayerIsWinnerRequest(evt);
				_server.send(request);
			} else {
				noChipMovements(evt);	
			}
		}
		
		private function finishedPlaying(evt:PlayerEvent):void {
			trace("=====> no left movements");
			haveAWinner(evt);	
		}
		
		private function noChipMovements(evt:PlayerEvent):void {
			trace("=====> no chip movements anymore");
			nextTurn();
		}			
		
		private function nextTurn():void
		{
			MouseManager.stop();
			
			var request:PlayerTurnIsFinishedRequest = new PlayerTurnIsFinishedRequest();
			_server.send(request);
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