package com.soueidan.games.tawla.core
{
	import com.soueidan.games.tawla.components.*;
	import com.soueidan.games.tawla.components.interfaces.*;
	import com.soueidan.games.tawla.core.*;
	import com.soueidan.games.tawla.events.*;
	import com.soueidan.games.tawla.handlers.*;
	import com.soueidan.games.tawla.managers.*;
	import com.soueidan.games.tawla.types.*;
	import com.soueidan.games.tawla.utils.*;
	
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
		private var _cup:ICup;
		
		static public const TOTAL_PLAYER:Number = 2;
		static public const TOTAL_CHIPS:Number = 4; // how many chips to create
		
		static private var _instance:Game;
		static public function getInstance():Game {
			return _instance;
		}
		
		public function Game() {	
			_instance = this;
			
			Logger.includeTime = false;
			Logger.showCaller = false;
			Logger.console = true;
			
			addEventListener(FlexEvent.APPLICATION_COMPLETE, applicationComplete);
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
			
			if ( !_cup ) {
				_cup = CupManager.create();
				addElement(_cup);
			}
		}
		
		public function get board():Board {
			return _board;
		}
		
		public function applicationComplete(evt:FlexEvent):void {
			removeEventListener(FlexEvent.APPLICATION_COMPLETE, applicationComplete);
			
			AutoPlayManager.start();
			
			MouseManager.init(this);
			MouseManager.addHandler(new DiceHandler);
			MouseManager.addHandler(new TriangleHandler);
			MouseManager.addHandler(new CupHandler);
			/*
			addEventListener(PlayerEvent.TURN_CHANGE, playerTurnChange);
			addEventListener(DiceEvent.CHANGED, diceChanged);
			addEventListener(ChipEvent.MOVED, movedChip);
			
			AutoPlayManager.createPlayers();
			_board.setupChips();
			PlayerManager.next();*/
			
		}
		
		private function createPlayer():void {
			if ( PlayerManager.total != TOTAL_PLAYER ) {
				var popup:PopupPlayer = new PopupPlayer();
				popup.addEventListener(FlexEvent.REMOVE, closeWindow);
				PopUpManager.addPopUp(popup, this, true);
				PopUpManager.centerPopUp(popup);
			}
		}
		
		private function closeWindow(evt:FlexEvent):void {
			createPlayer();
		}
		
		private function playerTurnChange(evt:PlayerEvent):void {
			_dice.shuffle();
			DiceManager.reset();
		}
		
		private function diceChanged(evt:DiceEvent):void {
			if ( !GameManager.canPlay ) {
				PlayerManager.next();
			}
		}
		
		private function movedChip(evt:ChipEvent):void {			
			if ( GameManager.finishedPlaying ) {
				PlayerManager.next();
			}
		}
	}
}