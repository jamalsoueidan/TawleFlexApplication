package com.soueidan.games.tawla.modes
{
	import com.soueidan.games.tawla.core.*;
	import com.soueidan.games.tawla.events.*;
	import com.soueidan.games.tawla.managers.*;
	import com.soueidan.games.tawla.requests.*;
	import com.soueidan.games.tawla.responses.*;
	import com.soueidan.smartfoxclient.core.SmartFoxClient;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class Network implements IMode
	{
		private var _server:SmartFoxClient;
		private var _game:Game;
		
		public function Network(game:Game):void {
			_game = game;
			
			addListener();
			setupServer();
		}
		
		public function addListener():void {
			_game.addEventListener(DiceEvent.SHUFFLED, diceChanged);
			_game.addEventListener(ChipEvent.MOVED, chipMoved);
			_game.addEventListener(PlayerEvent.TURN_CHANGE, playerTurnChanged);
			_game.addEventListener(PlayerEvent.IS_HOME, playerIsHome);
			_game.addEventListener(PlayerEvent.NEW_ROUND, newRound);
			_game.addEventListener(PlayerEvent.HAVE_A_WINNER, haveAWinner);
			_game.addEventListener(PlayerEvent.FINISHED_PLAYING, finishedPlaying);
			_game.addEventListener(PlayerEvent.NO_CHIP_MOVEMENTS, noChipMovements);
		}
		
		private function setupServer():void
		{
			_server = SmartFoxClient.getInstance();
			
			_server.addResponseHandler(StartGameResponse.START_GAME, StartGameResponse);
			_server.addResponseHandler(EndGameResponse.END_GAME, EndGameResponse);
			
			_server.addResponseHandler(ChipMovedResponse.CHIP_MOVED, ChipMovedResponse);
			_server.addResponseHandler(NextPlayerTurnResponse.NEXT_PLAYER_TURN, NextPlayerTurnResponse);
			_server.addResponseHandler(PlayerIsHomeResponse.PLAYER_IS_HOME, PlayerIsHomeResponse);
			_server.addResponseHandler(PlayerIsWinnerResponse.PLAYER_WIN_ROUND, PlayerIsWinnerResponse);
			_server.addResponseHandler(PlayerIsWinnerResponse.PLAYER_WIN_GAME, PlayerIsWinnerResponse);
		}
		
		public function start():void {
			
		}
		
		private function playerTurnChanged(evt:PlayerEvent):void {
			//trace("player turn changed");
		}
		
		private function diceChanged(evt:DiceEvent):void {
			if ( !GameManager.canPlayerMoveAnyChip ) {
				trace("player cannot move");
				nextTurn();
			} else {
				trace("mouseManager listen");
				
				if ( isMyTurn) {
					var timer:Timer = new Timer(1000, 4);
					timer.addEventListener(TimerEvent.TIMER_COMPLETE, function():void {
						if ( isMyTurn ) TestingManager.moveRandomChip();
						else timer.stop();
					}, false, 0, true);
					timer.start();
					MouseManager.listen();
				}
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
			//trace("player is home");
			var playerHomeRequest:PlayerIsHomeRequest = new PlayerIsHomeRequest(evt);
			_server.send(playerHomeRequest);
		}
		
		
		private function haveAWinner(evt:PlayerEvent):void {
			trace(" WE HAVE A WINNNER");
			var request:PlayerIsWinnerRequest = new PlayerIsWinnerRequest(evt);
			_server.send(request);
		}
		
		private function newRound(event:PlayerEvent):void {
			trace(" > NEW ROUND < ");
			var request:PlayerNewRoundRequest = new PlayerNewRoundRequest(event);
			_server.send(request);
		}
		
		private function finishedPlaying(evt:PlayerEvent):void {
			trace("=====> no left movements");
			nextTurn();	
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
		
		public function get isMyTurn():Boolean {
			return ( SmartFoxClient.getInstance().mySelf.id == PlayerManager.player.id ) 
		}
		
	}
}