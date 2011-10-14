package {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class InfoPanel extends Sprite
	{
		private var background:Shape = null;
		private var w:int = 220;
		public function InfoPanel()
		{
			super();
			
			addEventListener(Event.REMOVED_FROM_STAGE, dealloc);
		}
		
		public function initInfoPanel(xml:XML):void
		{
			var textHeight:int = 0;
			var imageLine:int = 0;
			var numberTF:TextField = new TextField();
			numberTF.defaultTextFormat = new TextFormat("宋体", 12, 0x000000);
			numberTF.autoSize = TextFieldAutoSize.LEFT;
			numberTF.wordWrap = false;
			numberTF.mouseWheelEnabled = false;
			numberTF.text = "摊位号: " + xml.number;
			addChild(numberTF);
			numberTF.x = 10;
			numberTF.y = 10;
			
			var detailPage:String = xml.detailPage;
			if(detailPage && detailPage != ""){
				var detailTF:TextField = new TextField();
				detailTF.defaultTextFormat = new TextFormat("宋体", 12, 0x001cff);
				detailTF.autoSize = TextFieldAutoSize.LEFT;
				detailTF.wordWrap = false;
				detailTF.mouseWheelEnabled = false;
				detailTF.htmlText = "<a href=\"" + detailPage + "\" target=\"_blank\">详情</a>";;
				addChild(detailTF);
				detailTF.x = w - detailTF.textWidth - 10;
				detailTF.y = textHeight + 10;
			}
			textHeight = numberTF.y + numberTF.textHeight;
			
			var nameTF:TextField = new TextField();
			nameTF.defaultTextFormat = new TextFormat("宋体", 12, 0x000000);
			nameTF.autoSize = TextFieldAutoSize.LEFT;
			nameTF.wordWrap = false;
			nameTF.mouseWheelEnabled = false;
			nameTF.text = "摊位名称: " + String(xml.name);
			addChild(nameTF);
			nameTF.x = numberTF.x;
			nameTF.y = textHeight + 10;
			
			textHeight = nameTF.y + nameTF.textHeight;
			
			if(xml.info){
				var infoTF:TextField = new TextField();
				infoTF.defaultTextFormat = new TextFormat("宋体", 12, 0x000000);
				infoTF.autoSize = TextFieldAutoSize.LEFT;
				infoTF.wordWrap = false;
				infoTF.mouseWheelEnabled = false;
				infoTF.text = "店铺信息";
				addChild(infoTF);
				infoTF.x = numberTF.x;
				infoTF.y = textHeight + 10;
				
				var morePage:String = xml.info.detailPage;
				if(morePage && morePage != ""){
					var moreTF:TextField = new TextField();
					moreTF.defaultTextFormat = new TextFormat("宋体", 12, 0x000000);
					moreTF.autoSize = TextFieldAutoSize.LEFT;
					moreTF.wordWrap = false;
					moreTF.mouseWheelEnabled = false;
					moreTF.htmlText = "<a href=\"" + morePage + "\" target=\"_blank\">更多>>></a>";
					addChild(moreTF);
					moreTF.x = w - moreTF.textWidth - 10;
					moreTF.y = textHeight + 10;
					textHeight = moreTF.y + moreTF.textHeight;
				}
				
				textHeight = infoTF.y + infoTF.textHeight;
				
				var xmlList:XMLList = XMLList(xml.info.entry);
				if(xmlList && xmlList.length()){
					var len:int = xmlList.length();
					for(var i:int = 0; i<len; i++){
						var infoNameTF:TextField = new TextField();
						infoNameTF.defaultTextFormat = new TextFormat("宋体", 12, 0x000000);
						infoNameTF.autoSize = TextFieldAutoSize.LEFT;
						infoNameTF.wordWrap = false;
						infoNameTF.mouseWheelEnabled = false;
						infoNameTF.text = xmlList[i].name;
						addChild(infoNameTF);
						infoNameTF.x = numberTF.x;
						infoNameTF.y = textHeight + 10;
						
						var timeTF:TextField = new TextField();
						timeTF.defaultTextFormat = new TextFormat("宋体", 12, 0x000000);
						timeTF.autoSize = TextFieldAutoSize.LEFT;
						timeTF.wordWrap = false;
						timeTF.mouseWheelEnabled = false;
						timeTF.text = xmlList[i].time;
						addChild(timeTF);
						timeTF.x = w - timeTF.textWidth - 10;
						timeTF.y = textHeight + 10;
						
						textHeight = infoNameTF.y + infoNameTF.textHeight;
					}
				}
			}
			
			if(xml.products){
				var productTF:TextField = new TextField();
				productTF.defaultTextFormat = new TextFormat("宋体", 12, 0x000000);
				productTF.autoSize = TextFieldAutoSize.LEFT;
				productTF.wordWrap = false;
				productTF.mouseWheelEnabled = false;
				productTF.text = "店铺产品";
				addChild(productTF);
				productTF.x = numberTF.x;
				productTF.y = textHeight + 10;
				
				var proMorePage:String = xml.products.detailPage;
				if(proMorePage && proMorePage != ""){
					var proMoreTF:TextField = new TextField();
					proMoreTF.defaultTextFormat = new TextFormat("宋体", 12, 0x000000);
					proMoreTF.autoSize = TextFieldAutoSize.LEFT;
					proMoreTF.wordWrap = false;
					proMoreTF.mouseWheelEnabled = false;
					proMoreTF.htmlText = "<a href=\"" + proMorePage + "\" target=\"_blank\">更多>>></a>";
					addChild(proMoreTF);
					proMoreTF.x = w - proMoreTF.textWidth - 10;
					proMoreTF.y = textHeight + 10;
				}
				
				textHeight = productTF.y + productTF.textHeight;
				
				var proXMLList:XMLList = XMLList(xml.products.product);
				if(proXMLList && proXMLList.length()){
					var l:int = proXMLList.length();
					imageLine = l;
					for(var j:int = 0; j<l; j++){
						var imageItem:ImageItem = new ImageItem();
						imageItem.initImage(proXMLList[j].url, proXMLList[j].image);
						addChild(imageItem);
						imageItem.x = (j % 3) * 70 + 10;
						imageItem.y = int(j / 3) * 70 + textHeight + 10;
					}
				}
			}
			
			var line:int = Math.ceil(imageLine / 3);
			line = line < 0 ? 0 : line;
			if(!background) background = new Shape();
			background.graphics.lineStyle(2, 0x009d03);
			background.graphics.beginFill(0xFFFFFF);
			background.graphics.drawRect(0, 0, 220, line * 70 + textHeight + (line - 1) * 10 + 10);
			background.graphics.endFill();
			addChildAt(background, 0);
		}
		
		private function dealloc(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, dealloc);
			while(this.numChildren) this.removeChildAt(0);
			this.filters = null;
			background = null;
		}
	}
}