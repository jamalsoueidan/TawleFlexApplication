package com.soueidan.games.tawla.managers
{

	import com.gskinner.motion.GTween;
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.smartfoxserver.v2.requests.IRequest;
	import com.soueidan.games.engine.managers.ResourceManager;
	import com.soueidan.games.engine.managers.ServerManager;
	import com.soueidan.games.tawla.components.interfaces.IChip;
	import com.soueidan.games.tawla.core.Game;
	import com.soueidan.games.tawla.handlers.IHandler;
	import com.soueidan.games.tawla.requests.ChipMovedRequest;
	import com.soueidan.games.tawla.requests.MouseMovementRequest;
	import com.soueidan.games.tawla.responses.MouseMovementResponse;
	import com.soueidan.games.tawla.utils.ArrayUtil;
	
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.ui.MouseCursor;
	import flash.utils.Timer;
	
	import spark.components.Group;
	import spark.components.Image;
	import spark.components.SkinnableContainer;
	import spark.components.VGroup;

	public class MouseManager
	{
		static private var _instance:MouseManager;
		static private var _handlers:Array = [];		
		static private var _game:Game;
		static private var _stopped:Boolean; 
		
		[Embed(source="assets/arrow.png")] 
		private var _arrow:Class;
		
		private var _cursor:Image;
		private var _cursorContainer:SkinnableContainer;
		
		private var _timer:Timer;
		private var chip:IChip;
		
		static public function init(game:Game):void {
			_instance = new MouseManager();
			_instance.game = game;
			_instance.startTimer();	
		}
		
		static public function listen():void {
			_instance.wake();
		}
		
		static public function stop():void {
			_instance.die();
		}
		
		static public function get isStopped():Boolean {
			return _stopped;
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
		
		private function wake():void {
			_stopped = false;
			_game.addEventListener(MouseEvent.MOUSE_DOWN, down);
			_game.addEventListener(MouseEvent.MOUSE_UP, up);
		}
		
		private function startTimer():void {
			if ( !_timer ) {
				ServerManager.getInstance().addEventListener(SFSEvent.OBJECT_MESSAGE, opponentMouseMovement);
				
				_cursor = new Image();
				_cursor.source = new _arrow();
				_cursorContainer = new SkinnableContainer();
				_cursorContainer.addElement(_cursor);
				_cursorContainer.alpha = .7;
				/*_cursorContainer.graphics.beginFill(0xFF0040,1);
				_cursorContainer.graphics.drawRect(0,0,10,10);
				_cursorContainer.graphics.endFill();*/
				_game.addElement(_cursorContainer);
				
				/*
				 *	if you change the timer 300 to something else, 
				 *	then remember to also update the tween timer .3 to the same
				 *	at line 155.
				 *	var tween:GTween = new GTween(_cursorContainer, .3);
				 */
				_timer = new Timer(300); 
				_timer.addEventListener(TimerEvent.TIMER, sendMouseMovement);
				_timer.start();
			}
		}
		
		private function opponentMouseMovement(event:SFSEvent):void {
			var object:SFSObject = event.params.message as SFSObject;
			var cmd:String = object.getUtfString("cmd");
			if ( cmd == MouseMovementRequest.action ) {
				cursorUpdatePosition(object);
			} else if( cmd == ChipMovedRequest.action ) {
				chipMoveAlongCursor(object);
			}	
		}
		
		private function chipMoveAlongCursor(object:SFSObject):void
		{
			var action:String = object.getUtfString("action");
			var chipNum:int = object.getInt("chip_num");
			
			if ( action == "down" ) {
				chip = PlayerManager.getChip(chipNum);
				chip.triangle.remove(chip);
				_cursorContainer.addElementAt(chip, 0);
				if ( ResourceManager.isRTL ) {
					chip.x = -16;
				} else {
					chip.x = -7;
				}
				chip.y = 0;
			}
			
			if ( action == "up" ) {
				chip.triangle.add(chip);
				chip = null;
			}
		}
		
		private function cursorUpdatePosition(object:SFSObject):void
		{
			var mouseX:int = object.getInt("mouseX") * _game.scaleX;
			var mouseY:int = object.getInt("mouseY") * _game.scaleY;
			
			if ( ResourceManager.isRTL ) {
				mouseX += _cursor.width;
				mouseY -= _cursor.height;
			} else {
				mouseX -= _cursor.width;
				mouseY += _cursor.height;
			}
			
			var tween:GTween = new GTween(_cursorContainer, .3);
			tween.proxy.x = Math.abs(mouseX)
			tween.proxy.y = Math.abs(mouseY-_game.height);
		}
		
		private function sendMouseMovement(event:TimerEvent):void
		{
			var newMouseX:int = (_game.mouseX - ((_game.scaleX - 1) / _game.mouseX));
			var newMouseY:int = (_game.mouseY - ((_game.scaleY - 1) / _game.mouseY));
			
			var params:ISFSObject = new SFSObject();
			params.putInt("mouseX", newMouseX);
			params.putInt("mouseY", newMouseY);
			
			var request:IRequest = new MouseMovementRequest(params);
			ServerManager.getInstance().send(request);
		}
		
		private function die():void {
			_game.removeEventListener(MouseEvent.MOUSE_DOWN, down);
			_game.removeEventListener(MouseEvent.MOUSE_UP, up);
			_game.removeEventListener(Event.ENTER_FRAME, updateScreen);
			_stopped = true;
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