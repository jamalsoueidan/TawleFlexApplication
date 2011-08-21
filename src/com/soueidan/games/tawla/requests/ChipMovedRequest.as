package com.soueidan.games.tawla.requests
{
	import com.smartfoxserver.v2.entities.Room;
	import com.smartfoxserver.v2.entities.data.ISFSObject;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.smartfoxserver.v2.requests.ExtensionRequest;
	import com.smartfoxserver.v2.requests.IRequest;
	import com.soueidan.games.tawla.events.ChipEvent;
	import com.soueidan.smartfoxserver.core.Connector;
	
	public class ChipMovedRequest extends ExtensionRequest implements IRequest
	{
		protected var _server:Connector = Connector.getInstance();
		
		protected var _params:ISFSObject;
		
		static private const action:String = "chip_moved";
		
		public function ChipMovedRequest(evt:ChipEvent)
		{
			_params = new SFSObject();
			_params.putInt("move", evt.move);
			_params.putInt("chipNum", evt.chipNum);
			
			super(action, _params, _server.currentRoom, false);
		}
	}
}