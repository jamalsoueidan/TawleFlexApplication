package com.soueidan.games.tawla.managers
{
	import com.gskinner.motion.GTween;
	import com.soueidan.games.tawla.components.Triangle;
	import com.soueidan.games.tawla.components.interfaces.*;
	import com.soueidan.games.tawla.core.Game;
	import com.soueidan.games.tawla.events.*;
	import com.soueidan.games.tawla.utils.*;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;

	public class TestingManager
	{
		static private function randomNumber(low:Number=0, high:Number=1):Number {
			return Math.floor(Math.random() * (1+high-low)) + low;
		}
		
		static public function moveRandomChip():void {
			var game:Game = Game.getInstance();
			
			var chips:Array = PlayerManager.player.chips;
			var num:int = randomNumber(0, (chips.length-1));
			var chip:IChip = chips[num];
			
			TriangleManager.showMovementsOnBoard(chip);
			
			if ( !chip.isFreezed && !ArrayUtil.isEmpty(TriangleManager.movements) ) {
				var oldTriangle:ITriangle = chip.parent as ITriangle;
				
				var movementIndex:int = randomNumber(0, (TriangleManager.movements.length-1));
				
				var triangle:ITriangle = TriangleManager.movements[movementIndex];
				if ( PlayerManager.player.isHome ) {
					if ( Math.abs(triangle.position - chip.position) == DiceManager.dice.total ) {
						return;
					}
				}
				
				if ( TriangleManager.canOwnIt(triangle, chip)) {
					oldTriangle.remove(chip);

					var Xx:int = (chip as DisplayObject).localToGlobal(new Point()).x;
					var Yy:int = (chip as DisplayObject).localToGlobal(new Point()).y;
					
					game.addElement(chip);
					
					chip.x = Xx;
					chip.y = Yy; 
					
					if ( (triangle as Triangle).isBottom ) {
						Yy = (triangle as DisplayObject).localToGlobal(new Point()).y + triangle.height - chip.height;
					} else {
						Yy = (triangle as DisplayObject).localToGlobal(new Point()).y;
					}
					
					Xx = (triangle as DisplayObject).localToGlobal(new Point()).x;
					
					var tween:GTween = new GTween(chip, .7, {x:Xx, y:Yy}, {onComplete:function():void {
						num = DiceManager.registerMovement(triangle, chip);
						
						trace("dice value PLAYED", num);
						
						triangle.add(chip);
						
						game.dispatchEvent(new ChipEvent(ChipEvent.MOVED, false, false, chip.num, num));
					}});
				}
			}
		}
	}
}