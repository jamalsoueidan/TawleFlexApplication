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
		
		private var timer:Timer = new Timer(500, 1000);
		
		static public function start():void
		{
			new AutoPlayManager().play();
		}
		
		private function play():void {
			createComponents();
			createPlayers();
			
			_game.board.setupChips();
			_game.addEventListener(PlayerEvent.TURN_CHANGE, playerTurnChange);
			_game.addEventListener(DiceEvent.CHANGED, afterDiceChanged);
			_game.addEventListener(ChipEvent.MOVED, afterChipMoved);
			
			_dice = DiceManager.dice;

			PlayerManager.next();
			_dice.shuffle();
			
			timer.addEventListener(TimerEvent.TIMER, function():void {
				if ( _autoPlay ) {
					trace("autoplay");
					moveChip();
				}
			});
			timer.start();
		}
		
		private function moveChip(evt:MouseEvent=null):void {
			var chip:IChip = PlayerManager.player.getRandomChip();
			var oldTriangle:ITriangle = chip.parent as ITriangle;
			for each(var movement:Number in DiceManager.leftMovements ) {
				var triangle:ITriangle = TriangleManager.getFromChipPlacementByPosition(chip, movement);
				if ( triangle && TriangleManager.canBeMovedTo(triangle, chip)) {
					DiceManager.registerMovement(triangle, chip);
					triangle.add(chip);
					oldTriangle.remove(chip);
					_game.dispatchEvent(new ChipEvent(ChipEvent.MOVED));
					break;
				}
			}
		}
		
		private function createComponents():void {
			_group = new VGroup();
			_game.addElement(_group);
			
			_move = new Button();
			_move.label = "Move Random Chip";
			_move.setStyle("fontSize", 22);
			_move.addEventListener(MouseEvent.CLICK, moveChip);
			_group.addElement(_move);
			
			_change = new Button();
			_change.label = "Change Player";
			_change.setStyle("fontSize", 22);
			_change.addEventListener(MouseEvent.CLICK, changePlayer);
			_group.addElement(_change);
			
			_update = new Button();
			_update.label = "Update dice";
			_update.setStyle("fontSize", 22);
			_update.addEventListener(MouseEvent.CLICK, updateDice);
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
			player.placement = PlacementTypes.TOP;
			PlayerManager.add(player);
			
			player = PlayerManager.create();
			player.name = "well";
			player.color = ColorTypes.WHITE;
			player.placement = PlacementTypes.BOTTOM;
			PlayerManager.add(player);
		}
		
		private function changePlayer(evt:MouseEvent):void {
			PlayerManager.next();
		} 
		
		private function updateDice(evt:MouseEvent):void {
			_dice.shuffle();
		}
		
		private function playerTurnChange(evt:PlayerEvent):void {
			DiceManager.reset();		
			_dice.shuffle();
		}
		
		private function afterDiceChanged(evt:DiceEvent):void {
			if ( !GameManager.canPlay ) {
				trace("cannot play");
				//PlayerManager.next();
			}
			
			//moveChip();
		}
		
		private function afterChipMoved(evt:ChipEvent):void {			
			if ( GameManager.finishedPlaying ) {
				PlayerManager.next();
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
	}
}