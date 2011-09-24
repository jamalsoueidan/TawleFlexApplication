package com.soueidan.games.tawla.components.interfaces
{
	import flash.geom.Point;
	
	import mx.core.IFlexDisplayObject;
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;

	public interface ITriangle extends IVisualElement, IVisualElementContainer
	{
		// don't remove these methods and use addElement and removeelement,
		// it's because when we need to use tween we can actually benefit of these two methods below
		function add(chip:IChip, travelBack:Boolean=false):void;
		function remove(chip:IChip):void;
		function removeAllChips():void;
		
		function get chips():Array;
		
		// show background color in case we can add the chip on this triangle
		function alert():void;
		
		// remove background color in case we cannot add the chip on this triangle
		function unalert():void;
		
		function get lastChip():IChip;
		function get firstChip():IChip;
		
		function get position():Number;
		
		function get isBottom():Boolean;

		//function getPositionXY(chip:IChip):Point;
		
		function setStyle(styleProp:String, newValue:*):void;
	}
}