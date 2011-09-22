package com.soueidan.games.tawla.requests
{
	import com.smartfoxserver.v2.entities.Room;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.requests.ExtensionRequest;
	import com.smartfoxserver.v2.requests.IRequest;
	import com.smartfoxserver.v2.requests.ObjectMessageRequest;
	import com.soueidan.games.engine.managers.ServerManager;
	import com.soueidan.games.engine.net.Server;
	
	public class MouseMovementRequest extends ObjectMessageRequest implements IRequest
	{
		protected var _server:Server = ServerManager.getInstance();
		public static const action:String = "mouse_movement";
		
		public function MouseMovementRequest(params:ISFSObject=null)
		{
			params.putUtfString("cmd", action);
			super(params, _server.currentRoom);
		}
	}
}