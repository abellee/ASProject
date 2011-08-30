package
{
	import fl.controls.Button;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.text.TextFieldAutoSize;
	import flash.utils.ByteArray;
	
	public class ImageItem extends Sprite
	{
		public var byteArray:ByteArray = null;
		private var loader:Loader = null;
		private var background:Shape = null;
		private var removeButton:Button = null;
		public var w:int = 60;
		public var h:int = 60;
		private var fileRef:FileReference = null;
		private var uploadingBar:Sprite = null;
		public var size:int = 0;
		public function ImageItem()
		{
			super();
			
			drawBorder();
			removeButton = new Button();
			removeButton.textField.autoSize = TextFieldAutoSize.LEFT;
			removeButton.label = "X";
			removeButton.width = 30;
			removeButton.height = 30;
			removeButton.setStyle("upSkin", getSprite());
			removeButton.setStyle("downSkin", getSprite());
			removeButton.setStyle("overSkin", getSprite());
			removeButton.setStyle("disabledSkin", getSprite());
			addChild(removeButton);
			removeButton.x = (w - removeButton.width) / 2;
			removeButton.y = (h - removeButton.height) / 2;
			
			uploadingBar = getSprite(50, 30, 1);
			addChild(uploadingBar);
			uploadingBar.visible = false;
			uploadingBar.x = (w - uploadingBar.width) / 2;
			uploadingBar.y = (h - uploadingBar.height) / 2;
			
			removeButton.addEventListener(MouseEvent.CLICK, removeImage);
			
			addEventListener(Event.REMOVED_FROM_STAGE, dealloc);
		}
		
		public function upload():void
		{
			fileRef.addEventListener(ProgressEvent.PROGRESS, uploadingFiles);
			fileRef.addEventListener(Event.COMPLETE, uploadingFileSuccess);
			fileRef.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadCompleteDataHandler);
			removeButton.visible = false;
			uploadingBar.scaleX = 0;
			uploadingBar.visible = true;
			var str:String = FileUploador.serverURLParams["url"] + "?";
			for(var key:String in FileUploador.serverURLParams){
				if(key == "url") continue;
				str += key + "=" + FileUploador.serverURLParams[key] + "&";
			}
			fileRef.upload(new URLRequest(str));
		}
		
		private function uploadCompleteDataHandler(event:DataEvent):void
		{
			fileRef.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadCompleteDataHandler);
			if(event.data == "1"){
				size = (event.target as FileReference).size;
				this.dispatchEvent(new Event("remove_image"));
			}else{
				upload();
			}
		}
		
		private function uploadingFiles(event:ProgressEvent):void
		{
			uploadingBar.scaleX = event.bytesLoaded / event.bytesTotal;
		}
		
		private function uploadingFileSuccess(event:Event):void
		{
			fileRef.removeEventListener(Event.COMPLETE, uploadingFileSuccess);
			fileRef.removeEventListener(ProgressEvent.PROGRESS, uploadingFiles);
		}
		
		private function dealloc(evnet:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, dealloc);
			removeButton.removeEventListener(MouseEvent.CLICK, removeImage);
			while(this.numChildren) this.removeChildAt(0);
			if(loader) loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, byteArrayLoadComplete);
			loader = null;
			removeButton = null;
			background = null;
			if(byteArray) byteArray.clear();
			byteArray = null;
			if(uploadingBar) uploadingBar = null;
			if(fileRef){
				fileRef.removeEventListener(Event.COMPLETE, uploadingFileSuccess);
				fileRef.removeEventListener(ProgressEvent.PROGRESS, uploadingFiles);
				fileRef = null;
			}
		}
		
		private function removeImage(event:MouseEvent):void
		{
			this.dispatchEvent(new Event("remove_image"));
		}
		
		public function initImage(ba:ByteArray, file:FileReference):void
		{
			byteArray = ba;
			fileRef = file;
			if(!loader) loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, byteArrayLoadComplete);
			loader.loadBytes(ba);
		}
		private function byteArrayLoadComplete(event:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, byteArrayLoadComplete);
			var bitmap:Bitmap = event.target.content as Bitmap;
			loader = null;
			var realW:int = bitmap.width;
			var realH:int = bitmap.height;
			var scaleSize:Number;
			if(bitmap.width > w && bitmap.width >= bitmap.height){
				scaleSize = w / bitmap.width;
				realH = bitmap.height * scaleSize;
				realW = bitmap.width * scaleSize;
			}else if(bitmap.height > h && bitmap.height >= bitmap.width){
				scaleSize = h / bitmap.height;
				realW = bitmap.width * scaleSize;
				realH = bitmap.height * scaleSize;
			}
			bitmap.width = realW - 4;
			bitmap.height = realH - 4;
			addChildAt(bitmap, this.numChildren - 2);
			bitmap.x = (w - bitmap.width) / 2;
			bitmap.y = (h - bitmap.height) / 2;
		}
		
		private function drawBorder():void
		{
			background = new Shape();
			background.graphics.lineStyle(1, 0x000000);
			background.graphics.beginFill(0x000000, 0);
			background.graphics.drawRect(0, 0, w, h);
			background.graphics.endFill();
			addChild(background);
		}
		private function getSprite(wnum:int = 30, hnum:int = 30, anum:Number = .5):Sprite
		{
			var background:Sprite = new Sprite();
			background.graphics.beginFill(0xff0000, anum);
			background.graphics.drawRect(0, 0, wnum, hnum);
			background.graphics.endFill();
			
			return background;
		}
	}
}