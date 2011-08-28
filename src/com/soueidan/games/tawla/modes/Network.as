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
			trace("player turn changed", evt.player.id);
			
			// you must set it to listen because we use the stopped boolean value to check 
			// against sending player finished playing
			if ( isMyTurn ) {
				MouseManager.listen();
			}
		}
		
		private function diceChanged(evt:DiceEvent):void {
			if ( !GameManager.canPlayerMoveAnyChip ) {
				trace("player cannot move");
				nextTurn();
			} else {				
				if ( isMyTurn) {
					trace("MyTurn", "mouseManager listen");
					autoPlay();
				}
			}
		}
		
		private function chipMoved(evt:ChipEvent):void {
			trace("chip moved");
			var extension:ChipMovedRequest = new ChipMovedRequest(evt);
			_server.send(extension);
			
			GameManager.finishedPlaying();
			TriangleManager.removeAllMovementsOnBoard();
			autoPlay();
		}
		
		private function autoPlay():void
		{
			if ( MouseManager.isStopped ) {
				return;
			}
			
			var timer:Timer = new Timer(1000, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, function():void {
				if ( isMyTurn && DiceManager.anyLeftMovements && GameManager.canPlayerMoveAnyChip ) {
					var keepTrying:Boolean = true;
					do {
						if ( TestingManager.moveRandomChip() ) {
							keepTrying = false;
						}
					} while(keepTrying);		
				}
			}, false, 0, true);
			timer.start();
		}
		
		private function playerIsHome(evt:PlayerEvent):void {
			//trace("player is home");
			var playerHomeRequest:PlayerIsHomeRequest = new PlayerIsHomeRequest(evt);
			_server.send(playerHomeRequest);
		}
		
		
		private function haveAWinner(evt:PlayerEvent):void {
			trace(" WE HAVE A WINNNER");
			
			MouseManager.stop();
			
			var request:PlayerIsWinnerRequest = new PlayerIsWinnerRequest(evt);
			_server.send(request);
		}
		
		private function newRound(event:PlayerEvent):void {
			trace(" > NEW ROUND < ");
			
			MouseManager.stop();
			
			var request:PlayerNewRoundRequest = new PlayerNewRoundRequest(event);
			_server.send(request);
		}
		
		private function finishedPlaying(evt:PlayerEvent):void {
			trace("no LEFT movements");
			nextTurn();	
		}
		
		private function noChipMovements(evt:PlayerEvent):void {
			trace("no chip MOVEMENTS anymore");
			nextTurn();	
		}			
		
		private function nextTurn():void
		{
			// fix to not keep sending player turn finish in case more events had nextTurn();
			if ( MouseManager.isStopped ) {
				return;
			}
			
			trace("send next turn request");
			
			MouseManager.stop();
			
			var request:PlayerTurnIsFinishedRequest = new PlayerTurnIsFinishedRequest();
			_server.send(request);
		}
		
		public function get isMyTurn():Boolean {
			return ( SmartFoxClient.getInstance().mySelf.id == PlayerManager.player.id ) 
		}
		
	}
}