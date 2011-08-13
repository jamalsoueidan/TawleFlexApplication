package com.soueidan.games.tawla.handlers
{
	import com.soueidan.games.tawla.components.*;
	import com.soueidan.games.tawla.components.interfaces.*;
	import com.soueidan.games.tawla.core.*;
	import com.soueidan.games.tawla.managers.*;
	import com.soueidan.games.tawla.types.*;
	import com.soueidan.games.tawla.utils.*;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class CupHandler implements IHandler
	{
		private var _cup:ICup = CupManager.cup;
		private var _chip:IChip;
		
		public function down(evt:MouseEvent):void
		{
			var check:Boolean = evt.target is IChip;
			if ( !check ) {
				return;
			}
			
			_chip = evt.target as IChip;;
		}
		
		public function up(evt:MouseEvent):void
		{
			var player:IPlayer = PlayerManager.player;
			if ( !player.isHome ) {
				return;
			}
			
		}
		
		public function update(evt:Event):void
		{
			var player:IPlayer = PlayerManager.player;
			if ( !player.isHome ) {
				return;
			}
			
			if ( _chip.hitTestObject(_cup as DisplayObject)) {
				_cup.alert();
			}  else {
				_cup.unalert();
			}
		}
		
	}
}