package com.soueidan.games.tawla.components.interfaces
{
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	
	import flash.geom.Point;
	
	import mx.core.IVisualElement;

	public interface IDice extends IVisualElement
	{
		//function shuffle():void;
		function get isDouble():Boolean;
		function get total():Number;
		function get all():Array;
		function get combinations():Array;
		function get leftValue():Number;
		function get rightValue():Number;
		
		function set sfsObject(value:ISFSObject):void;
	}
}