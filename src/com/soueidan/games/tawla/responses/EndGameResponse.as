package com.soueidan.games.tawla.responses
{
	import com.smartfoxserver.v2.core.SFSEvent;

	public class EndGameResponse extends DefaultResponse
	{
		static public const END_GAME:String = "end_game";
		
		override public function handleServerResponse(event:SFSEvent):void {
			trace("game finished");
		}
	}
}