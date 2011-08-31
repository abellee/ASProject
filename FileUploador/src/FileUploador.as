package {
	import fl.containers.ScrollPane;
	import fl.controls.Button;
	import fl.controls.ScrollPolicy;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	
	[SWF(width="400", height="300")]
	public class FileUploador extends Sprite
	{
		private var scrollList:ScrollPane = null;
		private var scrollContent:FileContainer = null;
		private var browseButton:Button = null;
		private var uploadButton:Button = null;
		private var deleteAll:Button = null;
		private var fileRef:FileReferenceList = null;
//		private var uploadURL:String = "";
		private var fileType:FileFilter = new FileFilter("Image(*.jpg, *.png, *.jpeg, *.gif)", "*.jpg;*.png;*.jpeg;*.gif");
		
		public static var serverURLParams:Object = {};
		public function FileUploador()
		{
			this.loaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			for(var key:String in this.loaderInfo.parameters){
				serverURLParams[key] = this.loaderInfo.parameters[key];
			}
			scrollList = new ScrollPane();
			scrollList.setSize(400, 260);
			scrollList.verticalScrollPolicy = ScrollPolicy.ON;
			scrollList.setStyle("upSkin", getSprite());
			addChild(scrollList);
			
			scrollContent = new FileContainer();
			scrollList.source = scrollContent;
			scrollContent.addEventListener("remove_image", updateScrollList);
			
			deleteAll = new Button();
			deleteAll.label = "全部删除";
			addChild(deleteAll);
			deleteAll.x = 5;
			deleteAll.y = scrollList.height + 10;
			
			browseButton = new Button();
			browseButton.label = "浏览...";
			
			uploadButton = new Button();
			uploadButton.label = "开始上传";
			
			uploadButton.x = this.stage.stageWidth - browseButton.width - 5;
			uploadButton.y = scrollList.height + 10;
			addChild(uploadButton);
			
			browseButton.x = this.stage.stageWidth - browseButton.width - 10 - uploadButton.width;
			browseButton.y = scrollList.height + 10;
			addChild(browseButton);
			
			deleteAll.addEventListener(MouseEvent.CLICK, removeAllItems);
			uploadButton.addEventListener(MouseEvent.CLICK, uploadFiles);
			browseButton.addEventListener(MouseEvent.CLICK, browseFiles);
		}
		
		private function loadComplete(event:Event):void
		{
			this.loaderInfo.removeEventListener(Event.COMPLETE, loadComplete);
			if(ExternalInterface.available){
				ExternalInterface.addCallback("addParams", addParamsFromJS);
				ExternalInterface.call("flashIsReady", true);
			}
		}
		private function addParamsFromJS(key:String, value:String):void
		{
			serverURLParams[key] = value;
		}
		
		public static function tellJS(func:String, num:int, size:int):void
		{
			if(ExternalInterface.available) ExternalInterface.call(func, num, size);
		}
		
		private function browseFiles(event:MouseEvent):void
		{
			if(!fileRef) fileRef = new FileReferenceList();
			fileRef.addEventListener(Event.SELECT, filesSelected);
			fileRef.addEventListener(Event.OPEN, fileRefOpenHandler);
			fileRef.browse([fileType]);
		}
		
		private function removeAllItems(event:MouseEvent):void
		{
			scrollContent.removeAllChildren();
			scrollList.update();
			scrollList.drawNow();
		}
		
		private function filesSelected(event:Event):void
		{
			var list:Array = fileRef.fileList;
			if(list && list.length){
				for each(var file:FileReference in list){
					file.addEventListener(Event.COMPLETE, preloadFileComplete);
					file.load();
				}
			}
		}
		private function preloadFileComplete(event:Event):void
		{
			var file:FileReference = event.currentTarget as FileReference;
			file.removeEventListener(Event.COMPLETE, preloadFileComplete);
			var imageItem:ImageItem = new ImageItem();
			imageItem.initImage(file.data, file);
			scrollContent.addImage(imageItem);
			scrollList.update();
			scrollList.drawNow();
		}
		private function fileRefOpenHandler(event:Event):void
		{
			trace(event);
		}
		
		private function uploadFiles(event:MouseEvent):void
		{
			if(scrollContent.numChildren) scrollContent.upload();
		}
		
		private function updateScrollList(event:Event):void
		{
			scrollList.update();
			scrollList.drawNow();
		}
		
		private function getSprite():Sprite
		{
			var background:Sprite = new Sprite();
			background.graphics.lineStyle(1, 0x000000, .5);
			background.graphics.beginFill(0x000000, 0);
			background.graphics.drawRect(0, 0, scrollList.width + 2, scrollList.height + 2);
			background.graphics.endFill();
			
			return background;
		}
	}
}