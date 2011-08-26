package com.soueidan.games.tawla.core
{
	import com.smartfoxserver.v2.entities.SFSUser;
	import com.soueidan.games.tawla.components.interfaces.IChip;
	import com.soueidan.games.tawla.components.interfaces.ICup;
	
	import flash.events.IEventDispatcher;

	public interface IPlayer extends IEventDispatcher
	{
		function get sfsUser():SFSUser;
		
		function get name():String;
		function set name(value:String):void;
		
		function get isRegistered():Boolean;
		function get id():int;
		
		function set color(value:int):void;
		function get color():int;
		
		function set direction(value:Number):void;
		function get direction():Number;
		
		function get chips():Array;
		
		function get endPosition():int;
		function get startPosition():int;
		
		function get isHome():Boolean;
		function set isHome(value:Boolean):void;
		
		function addScore(value:int):void;
		
		function get score():int;
		function get cup():ICup;
		
		function addChip(chip:IChip):void;
		function removeChip(chip:IChip):void;
		
		function removeAllChips():void;
	}
}