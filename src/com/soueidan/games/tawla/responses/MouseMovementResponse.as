package com.soueidan.games.tawla.responses
{
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.soueidan.games.engine.net.responses.ServerResponseHandler;
	
	public class MouseMovementResponse extends DefaultResponse
	{
		static public const MOVE:String = "mouse_movement";
		
		override public function handleServerResponse(event:SFSEvent):void {
			var object:SFSObject = event.params.params as SFSObject;
			trace(object.getInt("mouseX"));
			trace(object.getInt("mouseY"));
		}
	}
}