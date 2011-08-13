package com.soueidan.games.tawla.handlers
{
	import com.soueidan.games.tawla.core.Game;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.IFlexDisplayObject;

	public interface IHandler
	{
		function up(evt:MouseEvent):void;
		function down(evt:MouseEvent):void;
		function update(evt:Event):void;
	}
}