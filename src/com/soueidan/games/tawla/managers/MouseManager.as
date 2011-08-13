package com.soueidan.games.tawla.managers
{

	import com.soueidan.games.tawla.components.Chip;
	import com.soueidan.games.tawla.components.interfaces.IChip;
	import com.soueidan.games.tawla.components.interfaces.ITriangle;
	import com.soueidan.games.tawla.core.Game;
	import com.soueidan.games.tawla.handlers.IHandler;
	import com.soueidan.games.tawla.utils.ArrayUtil;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	
	import mx.core.IVisualElement;
	
	import org.osflash.thunderbolt.Logger;
	
	import spark.components.Application;

	public class MouseManager
	{
		static private var _handlers:Array = [];		
		static private var _game:Game;
		
		static public function init(game:Game):void {
			var instance:MouseManager = new MouseManager();
			instance.game = game;
			instance.execute();
		}
		
		static public function addHandler(handler:IHandler):void {
			_handlers.push(handler);
		}
		
		static public function removeHandler(handler:IHandler):void {
			_handlers = ArrayUtil.remove(_handlers, handler);
		}
		
		private function set game(value:Game):void {
			_game = value;
		}
		
		private function execute():void {
			_game.addEventListener(MouseEvent.MOUSE_DOWN, down);
			_game.addEventListener(MouseEvent.MOUSE_UP, up);
		}
		
		private function down(evt:MouseEvent):void {
			
			for each(var handler:IHandler in _handlers ) {
				handler.down(evt);
			}
			
			_game.addEventListener(Event.ENTER_FRAME, updateScreen);
		}
		
		private function up(evt:MouseEvent):void {
			
			for each(var handler:IHandler in _handlers ) {
				handler.up(evt);
			}
			
			_game.removeEventListener(Event.ENTER_FRAME, updateScreen);
		}
		
		private function updateScreen(evt:Event):void {
			//trace("running");	
			
			for each(var handler:IHandler in _handlers ) {
				handler.update(evt);
			}
		}
	}
}