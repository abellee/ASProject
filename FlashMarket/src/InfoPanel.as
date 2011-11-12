package {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class InfoPanel extends Sprite
	{
		private var background:Shape = null;
		private var w:int = 435;
		private var numPerRow:int = 4;
		private var imageWidth:int = 85;
		private var imageHeight:int = 86;
		private var line:int;
		private var textHeight:int = 0;
		public function InfoPanel()
		{
			super();
			
			addEventListener(Event.REMOVED_FROM_STAGE, dealloc);
		}
		
		public function initInfoPanel(xml:XML):void
		{
			var imageLine:int = 0;
			var numberTF:TextField = new TextField();
			numberTF.defaultTextFormat = new TextFormat("宋体", 13, 0x000000, true);
			numberTF.autoSize = TextFieldAutoSize.LEFT;
			numberTF.wordWrap = false;
			numberTF.mouseWheelEnabled = false;
			numberTF.htmlText = "摊位号: <font color=\"#FF0000\">" + xml.number + "</font>";
			addChild(numberTF);
			numberTF.x = 10;
			numberTF.y = 10;
			
			var detailPage:String = xml.detailPage;
			if(detailPage && detailPage != ""){
				var detailTF:TextField = new TextField();
				detailTF.defaultTextFormat = new TextFormat("宋体", 13, 0x001cff, true);
				detailTF.autoSize = TextFieldAutoSize.LEFT;
				detailTF.wordWrap = false;
				detailTF.mouseWheelEnabled = false;
				detailTF.htmlText = "<font color=\"#f6a61a\" fontWeight=\"bold\"><a href=\"" + detailPage + "\" target=\"_blank\">详情>></a></font>";;
				addChild(detailTF);
				detailTF.x = w - detailTF.textWidth - 10;
				detailTF.y = textHeight + 10;
			}
			textHeight = numberTF.y + numberTF.textHeight;
			
			var nameTF:TextField = new TextField();
			nameTF.defaultTextFormat = new TextFormat("宋体", 13, 0x000000, true);
			nameTF.autoSize = TextFieldAutoSize.LEFT;
			nameTF.wordWrap = false;
			nameTF.mouseWheelEnabled = false;
			nameTF.htmlText = "摊位名称: <font color=\"#09c8ff\">" + String(xml.name) + "</font>";
			addChild(nameTF);
			nameTF.x = numberTF.x + numberTF.textWidth + 10;
			nameTF.y = numberTF.y;
			
			textHeight = nameTF.y + nameTF.textHeight;
			
			if(xml.info){
				var infoTF:TextField = new TextField();
				infoTF.defaultTextFormat = new TextFormat("宋体", 13, 0x5a8504, true);
				infoTF.autoSize = TextFieldAutoSize.LEFT;
				infoTF.wordWrap = false;
				infoTF.mouseWheelEnabled = false;
				infoTF.text = "店铺信息";
				addChild(infoTF);
				infoTF.x = numberTF.x;
				infoTF.y = textHeight + 20;
				
				var morePage:String = xml.info.detailPage;
				if(morePage && morePage != ""){
					var moreTF:TextField = new TextField();
					moreTF.defaultTextFormat = new TextFormat("宋体", 13, 0x5a8504, true);
					moreTF.autoSize = TextFieldAutoSize.LEFT;
					moreTF.wordWrap = false;
					moreTF.mouseWheelEnabled = false;
					moreTF.htmlText = "<a href=\"" + morePage + "\" target=\"_blank\">更多>>></a>";
					addChild(moreTF);
					moreTF.x = w - moreTF.textWidth - 10;
					moreTF.y = textHeight + 20;
					textHeight = moreTF.y + moreTF.textHeight;
				}
				
				textHeight = infoTF.y + infoTF.textHeight;
				
				var xmlList:XMLList = XMLList(xml.info.entry);
				if(xmlList && xmlList.length()){
					var len:int = xmlList.length();
					for(var i:int = 0; i<len; i++){
						var infoNameTF:TextField = new TextField();
						infoNameTF.defaultTextFormat = new TextFormat("宋体", 12, 0x565656);
						infoNameTF.autoSize = TextFieldAutoSize.LEFT;
						infoNameTF.wordWrap = false;
						infoNameTF.mouseWheelEnabled = false;
						infoNameTF.htmlText = "<a href=\"" + xmlList[i].url + "\">" + xmlList[i].name + "</a>";
						addChild(infoNameTF);
						infoNameTF.x = numberTF.x;
						infoNameTF.y = textHeight + 10;
						
						var timeTF:TextField = new TextField();
						timeTF.defaultTextFormat = new TextFormat("宋体", 12, 0x565656);
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
				productTF.defaultTextFormat = new TextFormat("宋体", 13, 0x565656, true);
				productTF.autoSize = TextFieldAutoSize.LEFT;
				productTF.wordWrap = false;
				productTF.mouseWheelEnabled = false;
				productTF.text = "店铺产品";
				addChild(productTF);
				productTF.x = numberTF.x;
				productTF.y = textHeight + 20;
				
				var proMorePage:String = xml.products.detailPage;
				if(proMorePage && proMorePage != ""){
					var proMoreTF:TextField = new TextField();
					proMoreTF.defaultTextFormat = new TextFormat("宋体", 13, 0x565656, true);
					proMoreTF.autoSize = TextFieldAutoSize.LEFT;
					proMoreTF.wordWrap = false;
					proMoreTF.mouseWheelEnabled = false;
					proMoreTF.htmlText = "<a href=\"" + proMorePage + "\" target=\"_blank\">更多>>></a>";
					addChild(proMoreTF);
					proMoreTF.x = w - proMoreTF.textWidth - 10;
					proMoreTF.y = textHeight + 20;
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
						imageItem.x = (j % numPerRow) * (imageWidth + 20) + 10;
						imageItem.y = int(j / numPerRow) * imageHeight + textHeight + 10;
					}
				}
			}
			
			line = Math.ceil(imageLine / numPerRow);
			line = line < 0 ? 0 : line;
			
		}
		
		public function drawBackground(dir:String):void
		{
			if(!background) background = new Shape();
			background.graphics.clear();
			background.graphics.lineStyle(3, 0x484848);
			background.graphics.beginFill(0xFFFFFF);
			switch(dir){
				case "lt":
					background.graphics.moveTo(-15, -5);
					background.graphics.lineTo(0, 0);
					background.graphics.lineTo(w, 0);
					background.graphics.lineTo(w, line * imageHeight + textHeight + (line - 1) * 10 + 20);
					background.graphics.lineTo(0, line * imageHeight + textHeight + (line - 1) * 10 + 20);
					background.graphics.lineTo(0, 10);
					background.graphics.lineTo(-15, -5);
					break;
				case "rt":
					background.graphics.moveTo(w + 15, -5);
					background.graphics.lineTo(w, 0);
					background.graphics.lineTo(0, 0);
					background.graphics.lineTo(0, line * imageHeight + textHeight + (line - 1) * 10 + 20);
					background.graphics.lineTo(w, line * imageHeight + textHeight + (line - 1) * 10 + 20);
					background.graphics.lineTo(w, 10);
					background.graphics.lineTo(w + 15, -5);
					break;
				case "bl":
					background.graphics.moveTo(-15, line * imageHeight + textHeight + (line - 1) * 10 + 25);
					background.graphics.lineTo(0, line * imageHeight + textHeight + (line - 1) * 10 + 15);
					background.graphics.lineTo(0, 0);
					background.graphics.lineTo(w, 0);
					background.graphics.lineTo(w, line * imageHeight + textHeight + (line - 1) * 10 + 20);
					background.graphics.lineTo(10, line * imageHeight + textHeight + (line - 1) * 10 + 20);
					background.graphics.lineTo(-15, line * imageHeight + textHeight + (line - 1) * 10 + 25);
					break;
				case "br":
					background.graphics.moveTo(w + 15, line * imageHeight + textHeight + (line - 1) * 10 + 25);
					background.graphics.lineTo(w, line * imageHeight + textHeight + (line - 1) * 10 + 15);
					background.graphics.lineTo(w, 0);
					background.graphics.lineTo(0, 0);
					background.graphics.lineTo(0, line * imageHeight + textHeight + (line - 1) * 10 + 20);
					background.graphics.lineTo(w - 10, line * imageHeight + textHeight + (line - 1) * 10 + 20);
					background.graphics.lineTo(w + 15, line * imageHeight + textHeight + (line - 1) * 10 + 25);
					break;
			}
//			background.graphics.drawRect(0, 0, w, line * imageHeight + textHeight + (line - 1) * 10 + 20);
			background.graphics.endFill();
			background.alpha = .8;
			addChildAt(background, 0);
		}
		
//		private function getShadow():BitmapFilter
//		{
//			var color:Number = 0x000000;
//            var alpha:Number = 1;
//            var blurX:Number = 1;
//            var blurY:Number = 1;
//            var strength:Number = 1;
//            var inner:Boolean = false;
//            var knockout:Boolean = false;
//            var quality:Number = BitmapFilterQuality.HIGH;
//
//            return new GlowFilter(color,
//                                  alpha,
//                                  blurX,
//                                  blurY,
//                                  strength,
//                                  quality,
//                                  inner,
//                                  knockout);
//		}
		
		private function dealloc(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, dealloc);
			while(this.numChildren) this.removeChildAt(0);
			this.filters = null;
			background = null;
		}
	}
}