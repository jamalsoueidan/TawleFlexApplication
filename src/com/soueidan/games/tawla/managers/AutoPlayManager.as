package com.soueidan.games.tawla.managers
{
	import com.soueidan.games.tawla.components.*;
	import com.soueidan.games.tawla.components.interfaces.*;
	import com.soueidan.games.tawla.core.*;
	import com.soueidan.games.tawla.events.*;
	import com.soueidan.games.tawla.handlers.CupHandler;
	import com.soueidan.games.tawla.types.*;
	import com.soueidan.games.tawla.utils.*;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.core.FlexGlobals;
	
	import org.osflash.thunderbolt.Logger;
	
	import spark.components.Button;
	import spark.components.VGroup;

	public class AutoPlayManager
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
		
		static public function start():void
		{
			new AutoPlayManager().play();
		}
		
		private function play():void {
			createComponents();
			createPlayers();
			
			_game.board.setupChips();
			
			_game.addEventListener(DiceEvent.CHANGED, diceChanged);
			
			_game.addEventListener(ChipEvent.MOVED, chipMoved);
			
			_game.addEventListener(PlayerEvent.TURN_CHANGE, playerTurnChanged);
			_game.addEventListener(PlayerEvent.IS_HOME, playerIsHome);
			_game.addEventListener(PlayerEvent.HAVE_A_WINNER, haveAWinner);
			_game.addEventListener(PlayerEvent.FINISHED_PLAYING, finishedPlaying);
			_game.addEventListener(PlayerEvent.NO_CHIP_MOVEMENTS, noChipMovements);
			
			_dice = DiceManager.dice;

			PlayerManager.next();
			_dice.shuffle();
			
			timer.addEventListener(TimerEvent.TIMER, function():void {
				if ( _autoPlay ) {
					autoSelectedMoveChip();
				}
			});
			timer.start();
		}
		
		private function autoSelectedMoveChip():void {
			var chips:Array = PlayerManager.player.chips;
			var num:int = Math.floor(Math.random() * (1+(chips.length-1)-0)) + 0;
			var chip:IChip = chips[num];

			TriangleManager.showMovementsOnBoard(chip);
			
			if ( !ArrayUtil.isEmpty(TriangleManager.movements) ) {
				var oldTriangle:ITriangle = chip.parent as ITriangle;
				var triangle:ITriangle = TriangleManager.movements[0];
				
				DiceManager.registerMovement(triangle, chip);
					
				triangle.add(chip);
				oldTriangle.remove(chip);
				
				_game.dispatchEvent(new ChipEvent(ChipEvent.MOVED));
			}
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
			_game.addElement(_group);
			
			_move = new Button();
			_move.label = "Move Random Chip";
			_move.setStyle("fontSize", 22);
			_move.addEventListener(MouseEvent.CLICK, function():void {
				autoSelectedMoveChip();
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
			_dice.shuffle();
		}
		
		private function diceChanged(evt:DiceEvent):void {
			if ( !GameManager.canPlay ) {
				PlayerManager.next();
			}
		}
		
		private function chipMoved(evt:ChipEvent):void {
			GameManager.finishedPlaying();
			TriangleManager.removeAllMovementsOnBoard();
		}
		
		private function playerIsHome(evt:PlayerEvent):void {
			trace("player is home now");
			timer.stop();
		}
		
	
		private function haveAWinner(evt:PlayerEvent):void {
			if ( GameManager.winnerExists ) {
				trace("we have a winner");
				timer.stop();
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
			PlayerManager.next();
		}
	}
}