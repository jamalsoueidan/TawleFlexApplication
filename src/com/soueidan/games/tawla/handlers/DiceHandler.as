package com.soueidan.games.tawla.handlers
{
	import com.soueidan.games.tawla.components.*;
	import com.soueidan.games.tawla.components.interfaces.*;
	import com.soueidan.games.tawla.core.*;
	import com.soueidan.games.tawla.events.*;
	import com.soueidan.games.tawla.managers.*;
	import com.soueidan.games.tawla.types.*;
	import com.soueidan.games.tawla.utils.*;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.FlexGlobals;
	
	// this class only handles the dices on the board, when clicked down it will bound the mouse
	// to the dice component and when mouse up it will call some methods on the dice to shuffle the dice.
	public class DiceHandler implements IHandler
	{
		private var follow:Boolean;
		private var _game:Game;
		private var _dice:IDice;
		
		public function DiceHandler()
		{
			super();
			
			_game = FlexGlobals.topLevelApplication as Game;
			
			_dice = DiceManager.dice;
		}
	
		public function up(evt:MouseEvent):void {
			if ( !follow ) {
				return;
			}
			
			follow = false;
			
			//_dice.shuffle();
		}
		
	
		public function down(evt:MouseEvent):void
		{
			if ( !(evt.target is IDice) ) {
				return;
			}
			
			//follow = true;
		}
		
		public function update(evt:Event):void
		{
			if ( !follow ) {
				return;
			}
			
			_dice.x = _game.mouseX - (_dice.width/2);
			_dice.y = _game.mouseY - (_dice.height/2);
		}
	}
}