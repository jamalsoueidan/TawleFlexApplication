package com.soueidan.games.tawla.responses
{
	import com.soueidan.games.engine.net.responses.ServerResponseHandler;
	import com.soueidan.games.tawla.core.Game;
	import com.soueidan.games.tawla.managers.GameManager;
	
	public class DefaultResponse extends ServerResponseHandler
	{
		protected var _game:Game = GameManager.getInstance();
	}
}