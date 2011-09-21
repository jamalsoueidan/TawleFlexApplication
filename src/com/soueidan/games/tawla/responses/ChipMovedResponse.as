package com.soueidan.games.tawla.responses
{
	import com.gskinner.motion.GTween;
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.soueidan.games.tawla.components.Board;
	import com.soueidan.games.tawla.components.interfaces.*;
	import com.soueidan.games.tawla.managers.*;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	public class ChipMovedResponse extends DefaultResponse
	{
		static public const CHIP_MOVED:String = "chip_moved";
		private var oldTriangle:ITriangle;
		private var triangle:ITriangle;
		private var chip:IChip;
		
		override public function handleServerResponse(event:SFSEvent):void {
			var object:SFSObject = event.params.params as SFSObject;
			
			var move:int = object.getInt("move");
			var chipNum:int = object.getInt("chipNum");
			
			trace("movement", move,"chip num", chipNum);
			
			chip = PlayerManager.getChip(chipNum);
			var position:int = chip.position + ( chip.player.direction * move);
			oldTriangle = chip.triangle;

			if ( position == 0 ) {
				triangle = PlayerManager.player.cup;	
			} else {
			 	triangle = TriangleManager.getFromChipToPosition(chip, move);
			}
			
			oldTriangle.remove(chip);
			triangle.add(chip);
			
			/*_game.addElement(chip);
			
			var board:Board = _game.board;
			var point:Point = triangle.chipPosition(chip);
			
			var tween:GTween = new GTween(chip, 1, {x:point.x, y:point.y});
			tween.duration = 5
			tween.onComplete = handleTweenComplete;*/
		}
		
		private function handleTweenComplete(event:GTween):void {			
		}
	}
}