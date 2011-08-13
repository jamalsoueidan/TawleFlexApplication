package com.soueidan.games.tawla.core
{
	import com.soueidan.games.tawla.components.interfaces.IChip;

	public interface IPlayer
	{
		function set name(value:String):void;
		function get name():String;
		function set color(value:String):void;
		function get color():String;
		function set placement(value:String):void;
		function get placement():String;
		function get chips():Array;
		
		function get isHome():Boolean;
		function set isHome(value:Boolean):void;
		
		function addChip(chip:IChip):void;
		function removeChip(chip:IChip):void;
		
		function getRandomChip():IChip;
		
		function play():void;
		function stop():void;
	}
}