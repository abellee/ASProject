package
{
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	
	public class FileContainer extends Sprite
	{
		private var totalSize:int = 0;
		private var totalNum:int = 0;
		public function FileContainer()
		{
			super();
		}
		
		public function addImage(image:ImageItem):void
		{
			var num:int = this.numChildren;
			addChild(image);
			image.addEventListener("remove_image", removeImage);
			image.x = (num % 5) * (image.w + 10) + 10;
			image.y = int(num / 5) * (image.h + 10);
		}
		
		public function upload():void
		{
			if(this.numChildren){
				var image:ImageItem = this.getChildAt(0) as ImageItem;
				image.upload();
			}else{
				FileUploador.tellJS("AllComplete", totalNum, totalSize);
				totalSize = 0;
				totalNum = 0;
			}
		}
		
		public function removeAllChildren():void
		{
			while(this.numChildren) this.removeChildAt(0);
		}
		
		private function removeImage(event:Event):void
		{
			var image:ImageItem = event.currentTarget as ImageItem;
			totalSize += image.size;
			totalNum ++;
			TweenLite.to(image, .3, {alpha: 0, onComplete: removeSuccess, onCompleteParams:[image]});
		}
		private function removeSuccess(image:ImageItem):void
		{
			if(this.contains(image)) this.removeChild(image);
			image.removeEventListener("remove_image", removeImage);
			layout();
			this.dispatchEvent(new Event("remove_image"));
			upload();
		}
		private function layout():void
		{
			var num:int = this.numChildren;
			for(var i:int = 0; i<num; i++){
				var child:ImageItem = this.getChildAt(i) as ImageItem;
				child.x = (i % 5) * (child.w + 10) + 10;
				child.y = int(i / 5) * (child.h + 10);
			}
		}
	}
}