package com.soueidan.games.tawla.responses
{
	import com.soueidan.games.tawla.core.Game;
	import com.soueidan.smartfoxserver.responseHandlers.BaseClientResponseHandler;
	
	public class DefaultResponseHandler extends BaseClientResponseHandler
	{
		protected var _game:Game = Game.getInstance();
	}
}