package com.soueidan.games.tawla.components.interfaces
{
	import flash.geom.Point;
	
	import mx.core.IVisualElement;

	public interface IDice extends IVisualElement
	{
		function shuffle():void;
		function get isDouble():Boolean;
		function get total():Number;
		function get all():Array;
		function get combinations():Array;
		function get leftValue():Number;
		function get rightValue():Number;
	}
}