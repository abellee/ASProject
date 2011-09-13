package {
	import flash.net.URLRequest;
	import flash.events.ProgressEvent;
	import fl.events.DataChangeEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextField;
	import fl.containers.ScrollPane;
	import fl.controls.Button;
	import fl.controls.DataGrid;
	import fl.controls.dataGridClasses.DataGridColumn;
	import fl.data.DataProvider;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	import flash.text.TextFormat;
	
	[SWF(width="680", height="450", backgroundColor="#e8f0f9")]
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
		private var dp:DataProvider = new DataProvider();
		
		public static var serverURLParams:Object = {};
		
		private var imageList:DataGrid = null;
		private var curRow:int = 0;
		private var statusCell:int = 2;
		
		private var totalNum:int = 0;
		private var totalSize:Number = 0;
		private var limitNum:int = 30;
		
		private var text1:TextField = new TextField();
		private var text2:TextField = new TextField();
		private var uploading:Boolean = false;
		public function FileUploador()
		{
			this.loaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			for(var key:String in this.loaderInfo.parameters){
				serverURLParams[key] = this.loaderInfo.parameters[key];
			}
//			scrollList = new ScrollPane();
//			scrollList.setSize(400, 260);
//			scrollList.verticalScrollPolicy = ScrollPolicy.ON;
//			scrollList.setStyle("upSkin", getSprite());
//			addChild(scrollList);
//			
//			scrollContent = new FileContainer();
//			scrollList.source = scrollContent;
//			scrollContent.addEventListener("remove_image", updateScrollList);

			text1.defaultTextFormat = new TextFormat("宋体", 12, 0x7e8496);
			text1.autoSize = TextFieldAutoSize.LEFT;
			text1.selectable = false;
			text1.mouseEnabled = false;
			text1.text = "已添加0张图片(大小0MB)";
			
			text2.defaultTextFormat = new TextFormat("宋体", 12, 0xff0000);
			text2.autoSize = TextFieldAutoSize.LEFT;
			text2.selectable = false;
			text2.mouseEnabled = false;
			text2.text = "您还可以上传" + (limitNum - totalNum) + "张图片";

			deleteAll = new Button();
			deleteAll.setStyle("upSkin", Resource.DELETEALL);
			deleteAll.setStyle("downSkin", Resource.DELETEALL);
			deleteAll.setStyle("overSkin", Resource.DELETEALL);
			deleteAll.setStyle("disabledSkin", Resource.DELETEALL);
			deleteAll.setStyle("focusedSkin", new Sprite());
			deleteAll.width = 84;
			deleteAll.height = 22;
			deleteAll.label = "";
			
			browseButton = new Button();
			browseButton.setStyle("upSkin", Resource.ADDIMAGE);
			browseButton.setStyle("downSkin", Resource.ADDIMAGE);
			browseButton.setStyle("overSkin", Resource.ADDIMAGE);
			browseButton.setStyle("disabledSkin", Resource.ADDIMAGE);
			browseButton.setStyle("focusedSkin", new Sprite());
			browseButton.width = 84;
			browseButton.height = 22;
			browseButton.label = "";
			
			uploadButton = new Button();
			uploadButton.setStyle("upSkin", Resource.UPLOAD);
			uploadButton.setStyle("downSkin", Resource.UPLOAD);
			uploadButton.setStyle("overSkin", Resource.UPLOAD);
			uploadButton.setStyle("disabledSkin", Resource.UPLOAD);
			uploadButton.setStyle("focusedSkin", new Sprite());
			uploadButton.width = 84;
			uploadButton.height = 22;
			uploadButton.label = "";
			
			browseButton.x = 10;
			browseButton.y = 10;
			addChild(browseButton);
			
			uploadButton.x = browseButton.x + browseButton.width + 10;
			uploadButton.y = 10;
			addChild(uploadButton);
			
			deleteAll.x = this.stage.stageWidth - 10 - uploadButton.width;
			deleteAll.y = 10;
			addChild(deleteAll);
			
			text1.x = browseButton.x;
			text1.y = browseButton.y + browseButton.height + 7;
			addChild(text1);
			
			text2.x = deleteAll.x + deleteAll.width - text2.textWidth;
			text2.y = browseButton.y + browseButton.height + 7;
			addChild(text2);
			
			var textFormat:TextFormat = new TextFormat("宋体", 12, 0x6c8092);
			var thumbColumn:DataGridColumn = new DataGridColumn();
			thumbColumn.width = 150;
			thumbColumn.headerText = "缩略图";
			thumbColumn.cellRenderer = DataGridColumnCellRenderer;
			var fileNameColumn:DataGridColumn = new DataGridColumn();
			fileNameColumn.headerText = "文件名";
			fileNameColumn.cellRenderer = DataGridFileNameCellRenderer;
			var statusColumn:DataGridColumn = new DataGridColumn();
			statusColumn.width = 80;
			statusColumn.headerText = "状态";
			statusColumn.cellRenderer = DataGridStatusCellRenderer;
			var operationColumn:DataGridColumn = new DataGridColumn();
			operationColumn.width = 50;
			operationColumn.headerText = "操作";
			operationColumn.cellRenderer = DataGridDeleteColumnCellRenderer;
			imageList = new DataGrid();
			imageList.headerHeight = 23;
			imageList.rowHeight = 50;
			imageList.addColumn(thumbColumn);
			imageList.addColumn(fileNameColumn);
			imageList.addColumn(statusColumn);
			imageList.addColumn(operationColumn);
//			imageList.getColumnAt(0).headerText = "缩略图";
//			imageList.getColumnAt(0).dataField = "data";
//			imageList.getColumnAt(0).cellRenderer = DataGridColumnCellRenderer;
//			imageList.getColumnAt(1).headerText = "文件名";
//			imageList.getColumnAt(1).dataField = "fileName";
//			imageList.getColumnAt(1).cellRenderer = DataGridFileNameCellRenderer;
//			imageList.getColumnAt(2).headerText = "状态";
//			imageList.getColumnAt(2).dataField = "status";
//			imageList.getColumnAt(2).cellRenderer = DataGridStatusCellRenderer;
//			imageList.getColumnAt(3).headerText = "操作";
//			imageList.getColumnAt(3).dataField = "operation";
//			imageList.getColumnAt(3).cellRenderer = DataGridDeleteColumnCellRenderer;
			imageList.setStyle("textFormat", textFormat);
			imageList.setStyle("headerTextFormat", textFormat);
			imageList.setStyle("headerRenderer", DataGridColumnRenderer);
			imageList.setStyle("cellRenderer", DataGridFileNameCellRenderer);
			imageList.resizableColumns = false;
			imageList.setSize(660, 370);
			addChild(imageList);
			imageList.x = browseButton.x;
			imageList.y = browseButton.y + browseButton.height + 30;
			dp.addEventListener(DataChangeEvent.DATA_CHANGE, onListChange);
			
			deleteAll.addEventListener(MouseEvent.CLICK, removeAllItems);
			uploadButton.addEventListener(MouseEvent.CLICK, uploadFiles);
			browseButton.addEventListener(MouseEvent.CLICK, browseFiles);
		}
		
		private function onListChange(event:DataChangeEvent):void
		{
			if(event.changeType == "remove"){
				totalNum = dp.length;
				totalSize -= event.items[0].file.size / 1024 / 1024;
				totalSize = Number(totalSize.toFixed(2));
				totalSize = totalSize < 0 ? 0 : totalSize;
				text1.text = "已添加" + dp.length + "张图片(大小" + totalSize + "MB)";
				text2.text = "您还可以上传" + (limitNum - totalNum) + "张图片";
			}
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
			dp = new DataProvider();
			imageList.dataProvider = dp;
			totalNum = dp.length;
			totalSize = 0;
			text1.text = "已添加" + dp.length + "张图片(大小" + totalSize + "MB)";
			text2.text = "您还可以上传" + (limitNum - totalNum) + "张图片";
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
			var imgLoader:Loader = new Loader();
			var func:Function = function(event:Event):void
			{
				imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, func);
				var bitmap:Bitmap = event.target.content as Bitmap;
				dp.addItem({thumb:bitmap, fileName: file.name, status: "等待上传", operation: "", file: file, uploaded:false});
				imageList.dataProvider = dp;
				totalNum = dp.length;
				totalSize += file.size / 1024 / 1024;
				totalSize = Number(totalSize.toFixed(2));
				text1.text = "已添加" + dp.length + "张图片(大小" + totalSize + "MB)";
				text2.text = "您还可以上传" + (limitNum - totalNum) + "张图片";
			};
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, func);
			imgLoader.loadBytes(file.data);
//			var imageItem:ImageItem = new ImageItem();
//			imageItem.initImage(file.data, file);
//			scrollContent.addImage(imageItem);
//			scrollList.update();
//			scrollList.drawNow();
		}
		private function fileRefOpenHandler(event:Event):void
		{
			trace(event);
		}
		
		private function uploadFiles(event:MouseEvent):void
		{
//			if(scrollContent.numChildren) scrollContent.upload();
			if(uploading) return;
			uploading = true;
			uploadFile(curRow);
		}
		
		private function uploadFile(index:int):void
		{
			var obj:Object = dp.getItemAt(index);
			if(obj.uploaded){
				uploadFile(++curRow);
				return;
			}
			var file:FileReference = obj.file;
			file.addEventListener(ProgressEvent.PROGRESS, onProgressEvent);
			file.addEventListener(Event.COMPLETE, onComplete);
			var str:String = FileUploador.serverURLParams["url"] + "?";
			for(var key:String in FileUploador.serverURLParams){
				if(key == "url") continue;
				str += key + "=" + FileUploador.serverURLParams[key] + "&";
			}
			file.upload(new URLRequest(str));
		}
		
		private function onProgressEvent(event:ProgressEvent):void
		{
			(imageList.getCellRendererAt(curRow, statusCell) as DataGridStatusCellRenderer).showProgress(int(event.bytesLoaded / event.bytesLoaded * 100));
		}
		
		private function onComplete(event:Event):void
		{
			var obj:Object = dp.getItemAt(curRow);
			var file:FileReference = obj.file;
			file.removeEventListener(ProgressEvent.PROGRESS, onProgressEvent);
			file.removeEventListener(Event.COMPLETE, onComplete);
			obj.uploaded = true;
			curRow++;
			if(curRow >= dp.length){
				curRow = 0;
				uploading = false;
				FileUploador.tellJS("AllComplete", totalNum, totalSize);
				return;
			}
			uploadFile(curRow);
		}
		
//		private function updateScrollList(event:Event):void
//		{
//			scrollList.update();
//			scrollList.drawNow();
//		}
//		
//		private function getSprite():Sprite
//		{
//			var background:Sprite = new Sprite();
//			background.graphics.lineStyle(1, 0x000000, .5);
//			background.graphics.beginFill(0x000000, 0);
//			background.graphics.drawRect(0, 0, scrollList.width + 2, scrollList.height + 2);
//			background.graphics.endFill();
//			
//			return background;
//		}
	}
}