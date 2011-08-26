package com.soueidan.games.tawla.modes
{	
	import com.soueidan.games.tawla.components.*;
	import com.soueidan.games.tawla.components.interfaces.*;
	import com.soueidan.games.tawla.core.*;
	import com.soueidan.games.tawla.events.*;
	import com.soueidan.games.tawla.managers.*;
	import com.soueidan.games.tawla.types.*;
	import com.soueidan.games.tawla.utils.*;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.core.FlexGlobals;
	
	import spark.components.Button;
	import spark.components.VGroup;
	
	public class Local implements IMode
	{
		private var _autoPlay:Boolean = true;
		
		private var _dice:IDice;
		private var _game:Game = FlexGlobals.topLevelApplication as Game;
		
		private var _group:VGroup;
		private var _move:Button;
		private var _update:Button;
		private var _change:Button;
		private var _stop:Button;
		
		private var timer:Timer = new Timer(1000, 1000);
		
		public function Local(game:Game):void {
			_game = game;
			_game.enabled = true;
			
			createComponents();
			createPlayers();
			
			_game.startGame();
			
			_dice = DiceManager.dice;
			
			_game.addEventListener(DiceEvent.SHUFFLED, diceShuffled);
			_game.addEventListener(ChipEvent.MOVED, chipMoved);
			_game.addEventListener(PlayerEvent.TURN_CHANGE, playerTurnChanged);
			_game.addEventListener(PlayerEvent.IS_HOME, playerIsHome);
			_game.addEventListener(PlayerEvent.HAVE_A_WINNER, haveAWinner);
			_game.addEventListener(PlayerEvent.FINISHED_PLAYING, finishedPlaying);
			_game.addEventListener(PlayerEvent.NO_CHIP_MOVEMENTS, noChipMovements);
			
			timer.addEventListener(TimerEvent.TIMER, function():void {
				if ( _autoPlay ) {
					TestingManager.moveRandomChip();
				}
			});
		}
		
		public function start():void {
			MouseManager.listen();
			
			PlayerManager.next();
			timer.start();
		}
		
		private function stopAutoPlay(evt:MouseEvent):void {
			if ( _autoPlay ) {
				_stop.label = "Start";
				_autoPlay = false;
				timer.stop();
			} else {
				_stop.label = "Stop";
				_autoPlay = true;
				timer.start();
				
			}
		}
		
		private function createComponents():void {
			_group = new VGroup();
			_group.setStyle("right",0);
			_game.addElement(_group);
			
			_move = new Button();
			_move.label = "Move Random Chip";
			_move.setStyle("fontSize", 22);
			_move.addEventListener(MouseEvent.CLICK, function():void {
				TestingManager.moveRandomChip();
			});
			_group.addElement(_move);
			
			_change = new Button();
			_change.label = "Change Player";
			_change.setStyle("fontSize", 22);
			_change.addEventListener(MouseEvent.CLICK, function():void {
				PlayerManager.next();
			});
			_group.addElement(_change);
			
			_update = new Button();
			_update.label = "Update dice";
			_update.setStyle("fontSize", 22);
			_update.addEventListener(MouseEvent.CLICK, function():void {
				_dice.shuffle();
			});
			
			_group.addElement(_update);
			
			_stop = new Button();
			_stop.label = "Stop autoplay";
			_stop.setStyle("fontSize", 22);
			_stop.addEventListener(MouseEvent.CLICK, stopAutoPlay);
			_group.addElement(_stop);
		}
		
		static public function createPlayers():void {
			var player:IPlayer = PlayerManager.create();
			player.name = "jamal";
			player.color = ColorTypes.BLACK;
			player.direction = PlacementTypes.TOP;
			PlayerManager.add(player);
			
			player = PlayerManager.create();
			player.name = "well";
			player.color = ColorTypes.WHITE;
			player.direction = PlacementTypes.BOTTOM;
			PlayerManager.add(player);
		}
		
		private function playerTurnChanged(evt:PlayerEvent):void {
			trace("playerTurnChanged");
			TriangleManager.removeAllMovementsOnBoard();
			_dice.shuffle();
		}
		
		private function diceShuffled(evt:DiceEvent):void {
			trace("dices values", _dice.leftValue, _dice.rightValue);
			if ( GameManager.canPlayerMoveAnyChip == false ) {
				trace("cannot play, next player");
				PlayerManager.next();
			}
		}
		
		private function chipMoved(evt:ChipEvent):void {
			trace("chipMoved");
			GameManager.finishedPlaying();
		}
		
		private function playerIsHome(evt:PlayerEvent):void {
			trace("player is home now");
		}
		
		
		private function haveAWinner(evt:PlayerEvent):void {
			trace("we have a winner");
			timer.stop();
			_game.reset();
		}
		
		private function finishedPlaying(evt:PlayerEvent):void {
			trace("=====> no left movements");
			PlayerManager.next();
		}
		
		private function noChipMovements(evt:PlayerEvent):void {
			trace("=====> no chip movements anymore");
			noChipMovements(evt);
		}
	}
}