package com.soueidan.games.tawla.responses
{
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.soueidan.games.tawla.components.interfaces.*;
	import com.soueidan.games.tawla.managers.*;
	
	public class ChipMovedResponse extends DefaultResponse
	{
		static public const CHIP_MOVED:String = "chip_moved";
		
		override public function handleServerResponse(event:SFSEvent):void {
			var object:SFSObject = event.params.params as SFSObject;
			
			var move:int = object.getInt("move");
			var chipNum:int = object.getInt("chipNum");
			
			trace("movement", move,"chip num", chipNum);
			

			
			var chip:IChip = ChipManager.getChip(PlayerManager.player, chipNum);
			var position:int = chip.position + ( chip.player.direction * move);
			var oldTriangle:ITriangle = chip.parent as ITriangle;

			var triangle:ITriangle;
			if ( position == 0 ) {
				triangle = PlayerManager.player.cup;	
			} else {
			 	triangle = TriangleManager.getFromChipToPosition(chip, move);
			}
			
			trace(_server.mySelf.name, oldTriangle.position, triangle.position);
			triangle.add(chip);
			oldTriangle.remove(chip);
		}
	}
}