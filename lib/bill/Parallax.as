package lib.bill
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import lib.charge.ChargeGame;
	
	public class Parallax extends MovieClip
	{
		public var easing:Number;
		private var chargeGame:ChargeGame;
		
		public function Parallax()
		{
			easing = .2;
			//addEventListener(Event.ENTER_FRAME, update);
		}
		
		/*private function scrollBarHandler(evt:MouseEvent):void {
			scrollBar.x = mouseX;
		}*/
		
		public function update():void
		{
			var i:int;

			for (i = 0; i < numChildren; i++)
			{				
				var child:MovieClip = MovieClip(getChildAt(i));
				//trace(getChildAt(i));
////////////////
				
				if (child.x < stage.stageWidth - child.width)
				{
					child.x = stage.stageWidth - child.width;
				}
				else if (child.x > 0)
				{
					child.x = 0;
				}
				var tarX:Number = stage.mouseX - x;
				//var tarX:Number = scrollBarX - x;
				if (tarX < 0)
				{
					tarX = 0;
				}
				else if (tarX > stage.stageWidth)
				{
					tarX = stage.stageWidth;
				}
				child.x += ((tarX / stage.stageWidth) * (stage.stageWidth - child.width) - child.x) * easing;
				
				
				/*if (child.y < stage.stageHeight - child.height)
				{
					child.y = stage.stageHeight - child.height;
				}
				else if (child.y > 0)
				{
					child.y = 0;
				}
				
				var tarY:Number = stage.mouseY - y;
				if (tarY < 0)
				{
					tarY = 0;
				}
				else if (tarY > stage.stageWidth)
				{
					tarY = stage.stageWidth;
				}
				child.y += ((tarY / stage.stageHeight) * (stage.stageHeight - child.height) - child.y) * easing;*/
			}
		}
	}
}