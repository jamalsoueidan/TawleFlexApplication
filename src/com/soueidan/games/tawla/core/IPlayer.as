package com.soueidan.games.tawla.core
{
	import com.soueidan.games.tawla.components.interfaces.IChip;
	import com.soueidan.games.tawla.components.interfaces.ICup;

	public interface IPlayer
	{
		function set name(value:String):void;
		function get name():String;
		
		function set color(value:String):void;
		function get color():String;
		
		function set direction(value:Number):void;
		function get direction():Number;
		
		function get chips():Array;
		
		function get isHome():Boolean;
		function set isHome(value:Boolean):void;
		
		function get cup():ICup;
		
		function addChip(chip:IChip):void;
		function removeChip(chip:IChip):void;
	}
}