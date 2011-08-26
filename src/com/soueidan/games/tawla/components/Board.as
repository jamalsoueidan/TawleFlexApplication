package com.soueidan.games.tawla.components
{
	import com.soueidan.games.tawla.components.interfaces.IChip;
	import com.soueidan.games.tawla.components.interfaces.ITriangle;
	import com.soueidan.games.tawla.core.Game;
	import com.soueidan.games.tawla.core.IPlayer;
	import com.soueidan.games.tawla.core.Player;
	import com.soueidan.games.tawla.managers.ChipManager;
	import com.soueidan.games.tawla.managers.PlayerManager;
	import com.soueidan.games.tawla.managers.TriangleManager;
	import com.soueidan.games.tawla.types.PlacementTypes;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mx.core.ITransientDeferredInstance;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.primitives.BitmapImage;

	public class Board extends Group
	{
		private var _bitmap:BitmapImage;
		private var _graphicChanged:Boolean = true;
		
		public function Board():void {
			super();
			
			width = 800;
			height = 600;
			
			setStyle("top", 0);
			setStyle("horizontalCenter", 0);
		}
		
		override protected function createChildren():void {
			//initBackground();
			
			initEnglishTriangles();
			
			super.createChildren();
		}
		
		private function initBackground():void {
			if ( !_bitmap ) {
				trace("create image");
				_bitmap = new BitmapImage();
				_bitmap.source = "./assets/board.gif";
				_bitmap.smooth = true;
				_bitmap.verticalCenter = 0;
				_bitmap.horizontalCenter = 0;
				_bitmap.percentWidth = 100;
				_bitmap.percentHeight = 100;
				addElement(_bitmap);
			}
		}
		
		private function initArabicTriangles():void {
			
		}
		
		private function initEnglishTriangles():void {				
			var i:int = 0;
			var position:int = 1;
			var total:int = 6;// 6 triangles every round to place on the board		
			var triangle:ITriangle;
			var space:int = 0; 
			
			var left:Number = 27;
			
			for(i=0;i<total;i++) {
				triangle = TriangleManager.create(position);
				triangle.setStyle("top", 22);
				triangle.setStyle("left", left + space);
				
				space += triangle.width + 10;
				
				addElement(triangle);
				
				position += 1;
			}
			
			space = 0;
			left = 422;
			
			for(i=0;i<total;i++) {
				triangle = TriangleManager.create(position);
				triangle.setStyle("top", 22);
				triangle.setStyle("left", left + space);
				space += triangle.width + 10;
				
				addElement(triangle);
				
				position += 1;
			}
			
			space = 0;
			right = 28;
			
			for(i=0;i<total;i++) {
				triangle = TriangleManager.create(position);
				triangle.setStyle("bottom", 22);
				triangle.setStyle("right", right + space);
				space += triangle.width + 10;
				
				addElement(triangle);
				
				position += 1;
			}
			
			space = 0;
			right = 422;
			
			for(i=0;i<total;i++) {
				triangle = TriangleManager.create(position);
				triangle.setStyle("bottom", 22);
				triangle.setStyle("right", right + space);

				space += triangle.width + 10;
				
				addElement(triangle);
				
				position += 1;
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if ( _graphicChanged ) {
				_graphicChanged = false;

				graphics.beginFill(0xFF0040, 0.3);
				graphics.drawRect(0,0,width,height);
				graphics.endFill();
			}
		}
		
		public function setupChips():void {
			var triangle:ITriangle;
			var chip:IChip;
			var position:int = 0;
			
			for each(var player:IPlayer in PlayerManager.all) {
				if ( player.direction == PlacementTypes.TOP ) {
					triangle = TriangleManager.getByPosition( 1 );	
				} else {
					triangle = TriangleManager.getByPosition( 24 );
				}
				
				for(var i:int=0;i<Game.TOTAL_CHIPS;i++) {
					chip = ChipManager.create(player, i);
					player.addChip(chip);
					triangle.add(chip);
				}	
			}
		}
		
		public function reset():void
		{
			for each(var triangle:ITriangle in TriangleManager.all ) {
				triangle.removeAllChips();
			}
			
			setupChips();
			
		}
	}
}