package com.soueidan.games.tawla.components.interfaces
{
	import com.soueidan.games.tawla.core.IPlayer;
	
	import flash.display.DisplayObject;
	
	import mx.core.IVisualElement;

	public interface IChip extends IVisualElement
	{
		function get num():Number;
		function get color():int;
		function get position():Number;
		function set position(value:Number):void;
		function get isFreezed():Boolean;
		function hitTestObject(obj:DisplayObject):Boolean;
		function get player():IPlayer; 
	}
}