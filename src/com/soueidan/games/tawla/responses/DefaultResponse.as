package com.soueidan.games.tawla.responses
{
	import com.soueidan.games.tawla.core.Game;
	import com.soueidan.smartfoxclient.responses.ServerResponseHandler;
	
	public class DefaultResponse extends ServerResponseHandler
	{
		protected var _game:Game = Game.getInstance();
	}
}