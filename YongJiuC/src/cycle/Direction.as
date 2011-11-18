package cycle
{
	import fl.motion.AdjustColor;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	public class Direction extends Sprite implements IDirection
	{
		private var _dir:uint;
		private var posList0:Object = {"body":{"com":null, "pos":new Point(99, 63)}, "hand":{"com":null, "pos":new Point(313, 0)}, "group":{"com":null, "pos":new Point(14, 1)}, "round":{"com":null, "pos":new Point(0, 103)}, "innerRound":{"com":null, "pos":new Point(8, 112)}, "crankset":{"com":null, "pos":new Point(222, 199)}, "seat":{"com":null, "pos":new Point(140, 13)}, "brake":{"com":null, "pos":new Point(357, 1)}, "chain":{"com":null, "pos":new Point(93, 197)}};
		private var posList1:Object = {"body":{"com":null, "pos":new Point(96, 65)}, "hand":{"com":null, "pos":new Point(199, 1)}, "group":{"com":null, "pos":new Point(64, 1)}, "round":{"com":null, "pos":new Point(23, 100)}, "innerRound":{"com":null, "pos":new Point(56, 107)}, "crankset":{"com":null, "pos":new Point(179, 200)}, "seat":{"com":null, "pos":new Point(125, 16)}, "brake":{"com":null, "pos":new Point(238, 1)}, "chain":{"com":null, "pos":new Point(97, 189)}};
		private var posList2:Object = {"body":{"com":null, "pos":new Point(87, 62)}, "hand":{"com":null, "pos":new Point(138, 1)}, "group":{"com":null, "pos":new Point(15, 1)}, "round":{"com":null, "pos":new Point(1, 99)}, "innerRound":{"com":null, "pos":new Point(13, 107)}, "crankset":{"com":null, "pos":new Point(226, 196)}, "seat":{"com":null, "pos":new Point(268, 17)}, "brake":{"com":null, "pos":new Point(103, 1)}, "chain":{"com":null, "pos":new Point(221, 186)}};
		private var posList3:Object = {"body":{"com":null, "pos":new Point(104, 63)}, "hand":{"com":null, "pos":new Point(210, 0)}, "group":{"com":null, "pos":new Point(13, 1)}, "round":{"com":null, "pos":new Point(0, 103)}, "innerRound":{"com":null, "pos":new Point(9, 113)}, "crankset":{"com":null, "pos":new Point(283, 196)}, "seat":{"com":null, "pos":new Point(330, 15)}, "brake":{"com":null, "pos":new Point(130, 5)}, "chain":{"com":null, "pos":new Point(280, 195)}};
		private var posList4:Object = {"body":{"com":null, "pos":new Point(45, 61)}, "hand":{"com":null, "pos":new Point(72, 0)}, "group":{"com":null, "pos":new Point(9, 1)}, "round":{"com":null, "pos":new Point(0, 99)}, "innerRound":{"com":null, "pos":new Point(4, 107)}, "crankset":{"com":null, "pos":new Point(186, 202)}, "seat":{"com":null, "pos":new Point(207, 12)}, "brake":{"com":null, "pos":new Point(59, 1)}, "chain":{"com":null, "pos":new Point(183, 200)}};
		private var posList5:Object = {"body":{"com":null, "pos":new Point(115, 68)}, "hand":{"com":null, "pos":new Point(239, 1)}, "group":{"com":null, "pos":new Point(51, 3)}, "round":{"com":null, "pos":new Point(38, 100)}, "innerRound":{"com":null, "pos":new Point(46, 108)}, "crankset":{"com":null, "pos":new Point(239, 207)}, "seat":{"com":null, "pos":new Point(154, 14)}, "brake":{"com":null, "pos":new Point(274, 4)}, "chain":{"com":null, "pos":new Point(136, 205)}};
		
		private var highlightFilter:ColorMatrixFilter;
		public function Direction()
		{
			super();
			this.mouseEnabled = false;
			this.mouseChildren = true;
			addEventListener(Event.REMOVED_FROM_STAGE, clearSelf);
		}
		private function clearSelf(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, clearSelf);
			while(this.numChildren){
				
				removeListener(this.getChildAt(0));
				this.removeChildAt(0);
				
			}
			posList0 = null;
			posList1 = null;
			posList2 = null;
			posList3 = null;
			posList4 = null;
			posList5 = null;
			highlightFilter = null;
		}
		public function addComponents(dir:uint, list:Object):void{
			
			while(this.numChildren){
				
				removeListener(this.getChildAt(0));
				this.removeChildAt(0);
				
			}
			_dir = dir;
			var pList:Object = this["posList" + _dir];
			
			if(list["brake"]){
				
				addListener(list["brake"]);
				addChild(list["brake"]);
				list["brake"].x = pList["brake"]["pos"].x;
				list["brake"].y = pList["brake"]["pos"].y;
				cacheComponent("brake", list["brake"]);
				
			}
			if(list["group"]){
				
				addListener(list["group"]);
				addChild(list["group"]);
				list["group"].x = pList["group"]["pos"].x;
				list["group"].y = pList["group"]["pos"].y;
				cacheComponent("group", list["group"]);
				
			}
			if(list["innerRound"]){
				
				addListener(list["innerRound"]);
				addChild(list["innerRound"]);
				list["innerRound"].x = pList["innerRound"]["pos"].x;
				list["innerRound"].y = pList["innerRound"]["pos"].y;
				cacheComponent("innerRound", list["innerRound"]);
				
			}
			if(list["round"]){
				
				addListener(list["round"]);
				addChild(list["round"]);
				list["round"].x = pList["round"]["pos"].x;
				list["round"].y = pList["round"]["pos"].y;
				cacheComponent("round", list["round"]);
				
			}
			if(list["crankset"]){
				
				addListener(list["crankset"]);
				addChild(list["crankset"]);
				list["crankset"].x = pList["crankset"]["pos"].x;
				list["crankset"].y = pList["crankset"]["pos"].y;
				cacheComponent("crankset", list["crankset"]);
				
			}
			if(list["chain"]){
				
				addListener(list["chain"]);
				addChild(list["chain"]);
				list["chain"].x = pList["chain"]["pos"].x;
				list["chain"].y = pList["chain"]["pos"].y;
				cacheComponent("chain", list["chain"]);
				
			}
			if(list["seat"]){
				
				addListener(list["seat"]);
				addChild(list["seat"]);
				list["seat"].x = pList["seat"]["pos"].x;
				list["seat"].y = pList["seat"]["pos"].y;
				cacheComponent("seat", list["seat"]);
				
			}
			if(list["hand"]){
				
				addListener(list["hand"]);
				addChild(list["hand"]);
				list["hand"].x = pList["hand"]["pos"].x;
				list["hand"].y = pList["hand"]["pos"].y;
				cacheComponent("hand", list["hand"]);
				
			}
			if(list["body"]){
				
				addListener(list["body"]);
				addChild(list["body"]);
				list["body"].x = pList["body"]["pos"].x;
				list["body"].y = pList["body"]["pos"].y;
				cacheComponent("body", list["body"]);
				
			}
			
		}
		private function addListener(obj:DisplayObject):void
		{
//			obj.addEventListener(MouseEvent.MOUSE_OVER, highlightMC);
//			obj.addEventListener(MouseEvent.MOUSE_OUT, removeHightlight);
//			obj.addEventListener(MouseEvent.CLICK, showColorHad);
		}
		private function removeListener(obj:DisplayObject):void
		{
			obj.removeEventListener(MouseEvent.MOUSE_OVER, highlightMC);
			obj.removeEventListener(MouseEvent.MOUSE_OUT, removeHightlight);
			obj.removeEventListener(MouseEvent.CLICK, showColorHad);
		}
		public function highlightMC(mc:Sprite):void
		{
//			var mc:Sprite = event.currentTarget as Sprite;
			if(!highlightFilter){
				
				var adjustColor:AdjustColor = new AdjustColor();
				adjustColor.brightness = 50;
				adjustColor.contrast = 0;
				adjustColor.hue = 0;
				adjustColor.saturation = 0;
				highlightFilter = new ColorMatrixFilter(adjustColor.CalculateFinalFlatArray());
				
			}
			mc.filters = [highlightFilter];
		}
		
		public function removeHightlight():void
		{
			var num:int = this.numChildren;
			for(var i:int = 0; i<num; i++){
				var sp:Sprite = this.getChildAt(i) as Sprite;
				if(sp){
					sp.filters = null;
				}
			}
		}
		
		public function removeHightlightSprite(mc:Sprite):void
		{
//			var mc:Sprite = event.currentTarget as Sprite;
			mc.filters = null;
		}
		public function showColorHad(mc:Sprite):void
		{
//			var mc:Sprite = event.currentTarget as Sprite;
			var partName:String = getPartName(mc);
			if(!partName){
				return;
			}
			YongJiuC.app.showColorPickr(partName);
		}
		private function getPartName(mc:Sprite):String
		{
			var pList:Object = this["posList" + _dir];
			for (var key:String in pList){
				
				if(pList[key]["com"] == mc){
					
					return key;
					
				}
				
			}
			return null;
		}
		public function replaceComponent(name:String, mc:Sprite):void
		{
			var pList:Object = this["posList" + _dir];
			var oindex:uint;
			if(pList[name]["com"]){
				
				oindex = this.getChildIndex(pList[name]["com"]);
				this.removeChild(pList[name]["com"]);
				removeListener(pList[name]["com"]);
				pList[name]["com"] = null;
				
			}
			addChildAt(mc, oindex);
			addListener(mc);
			if(pList[name]["pos"]){
				
				mc.x = pList[name]["pos"].x;
				mc.y = pList[name]["pos"].y;
				
			}
			cacheComponent(name, mc);
		}
		private function cacheComponent(str:String, mc:DisplayObject):void
		{
			this["posList" + _dir][str]["com"] = mc;
		}
	}
}