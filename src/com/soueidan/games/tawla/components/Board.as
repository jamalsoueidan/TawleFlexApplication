package com.soueidan.games.tawla.components
{
	import com.soueidan.games.tawla.components.interfaces.IChip;
	import com.soueidan.games.tawla.components.interfaces.ITriangle;
	import com.soueidan.games.tawla.core.Game;
	import com.soueidan.games.tawla.core.IPlayer;
	import com.soueidan.games.tawla.managers.ChipManager;
	import com.soueidan.games.tawla.managers.PlayerManager;
	import com.soueidan.games.tawla.managers.TriangleManager;
	import com.soueidan.games.tawla.types.PlacementTypes;
	
	import mx.core.BitmapAsset;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.Image;
	import spark.components.SkinnableContainer;
	import spark.primitives.BitmapImage;

	public class Board extends SkinnableContainer
	{
		[Embed(source="assets/board.jpg")] 
		private var _imageSource:Class;
		
		private var _image:Image;
		private var _graphicChanged:Boolean = true;
		
		public function Board():void {
			super();
			
			width = 720;
			height = 700;
		}
		
		override protected function createChildren():void {

			initBackground();
			
			initTriangles();
			
			super.createChildren();
		}
		
		private function initBackground():void {
			if ( !_image ) {		
				_image = new Image();
				_image.source = new _imageSource();
				_image.smooth = true;
				_image.x = _image.y = 0;
				_image.percentWidth = _image.percentHeight = 100;
				addElement(_image);
			}
		}
		
		private function initTriangles():void {				
			var i:int = 0;
			var position:int = 1;
			var total:int = 6;// 6 triangles every round to place on the board		
			var triangle:ITriangle;
			var space:int = 0; 
			
			var fromLeft:int = 24;
			
			for(i=0;i<total;i++) {
				triangle = TriangleManager.create(position);
				triangle.setStyle("top", 18);
				triangle.setStyle("left", fromLeft + space);
				
				space += triangle.width + 1;
				
				addElement(triangle);
				
				position += 1;
			}
			
			
			space = 0;
			fromLeft = 386;
			
			for(i=0;i<total;i++) {
				triangle = TriangleManager.create(position);
				triangle.setStyle("top", 18);
				triangle.setStyle("left", fromLeft + space);
				
				space += triangle.width + 1;
				
				addElement(triangle);
				
				position += 1;
			}
			
			
			space = 0;
			var fromRight:int = 22;
			
			for(i=0;i<total;i++) {
				triangle = TriangleManager.create(position);
				triangle.setStyle("bottom", 20);
				triangle.setStyle("right", fromRight + space);
				
				space += triangle.width + 1;
				
				addElement(triangle);
				
				position += 1;
			}
			
			space = 0;
			fromRight = 384;
			
			for(i=0;i<total;i++) {
				triangle = TriangleManager.create(position);
				triangle.setStyle("bottom", 20);
				triangle.setStyle("right", fromRight + space);
				
				space += triangle.width + 1;
				
				addElement(triangle);
				
				position += 1;
			}
		}
		
		/*override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if ( _graphicChanged ) {
				_graphicChanged = false;

				graphics.beginFill(0xFF0040, 0.3);
				graphics.drawRect(0,0,width,height);
				graphics.endFill();
			}
		}*/
		
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