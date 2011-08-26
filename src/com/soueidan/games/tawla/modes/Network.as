package com.soueidan.games.tawla.modes
{
	import com.soueidan.games.tawla.components.interfaces.IChip;
	import com.soueidan.games.tawla.components.interfaces.ITriangle;
	import com.soueidan.games.tawla.core.*;
	import com.soueidan.games.tawla.events.*;
	import com.soueidan.games.tawla.managers.*;
	import com.soueidan.games.tawla.requests.*;
	import com.soueidan.games.tawla.responses.*;
	import com.soueidan.games.tawla.utils.ArrayUtil;
	import com.soueidan.smartfoxclient.core.SmartFoxClient;

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
			_game.startGame();
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
			if ( !GameManager.canPlayerMoveAnyChip ) {
				trace("player cannot move");
				nextTurn();
			} else {
				TestingManager.moveRandomChip();
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
			var request:PlayerIsWinnerRequest = new PlayerIsWinnerRequest(evt);
			_server.send(request);
		}
		
		private function finishedPlaying(evt:PlayerEvent):void {
			trace("=====> no left movements");
			nextTurn();	
		}
		
		private function noChipMovements(evt:PlayerEvent):void {
			trace("=====> no chip movements anymore");
			finishedPlaying(evt);
		}			
		
		private function nextTurn():void
		{
			MouseManager.stop();
			
			var request:PlayerTurnIsFinishedRequest = new PlayerTurnIsFinishedRequest();
			_server.send(request);
		}
		
	}
}