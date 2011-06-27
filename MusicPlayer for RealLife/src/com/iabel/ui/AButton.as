package com.iabel.ui
{
	import fl.controls.Button;
	
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	
	public class AButton extends Button
	{
		private var _tooltip:Tooltip;
		public function AButton(upSkin:Class, overSkin:Class, downSkin:Class, selectDownSkin:Class)
		{
			super();
			
			this.setStyle("upSkin", upSkin);
			this.setStyle("overSkin", overSkin);
			this.setStyle("downSkin", downSkin);
			this.setStyle("selectedDownSkin", selectDownSkin);
			this.setStyle("selectedUpSkin", selectDownSkin);
			this.setStyle("selectedOverSkin", selectDownSkin);
			
		}
		public function set toolTip(str:String):void{
			
			if(str == "" || !str){
				
				if(_tooltip){
					
					Main.instance.removeToolTip(_tooltip);
					this.removeEventListener(MouseEvent.ROLL_OVER, showToolTip);
					this.removeEventListener(MouseEvent.ROLL_OUT, hideToolTip);
					_tooltip.clearSelf();
					_tooltip = null;
					
				}
				return;
				
			}
			if(!_tooltip){
				
				_tooltip = new Tooltip(str);
				
				var filter:BitmapFilter = getBitmapFilter();
				var myFilters:Array = new Array();
				myFilters.push(filter);
				_tooltip.filters = myFilters;
				
				Main.instance.addToolTip(_tooltip);
				this.addEventListener(MouseEvent.ROLL_OVER, showToolTip);
				this.addEventListener(MouseEvent.ROLL_OUT, hideToolTip);
				
			}
			
		}
		private function showToolTip(event:MouseEvent):void{
			
			if(_tooltip){
				
				Main.instance.addToolTip(_tooltip);
				
			}
			
		}
		private function hideToolTip(event:MouseEvent):void{
			
			if(_tooltip){
				
				Main.instance.removeToolTip(_tooltip);
				
			}
			
		}
		public function get toolTip():String{
			
			return _tooltip.toolTip;
			
		}
		
		private function getBitmapFilter(co:Number = 0x000000, an:Number = 0, al:Number = 0.8, bx:Number = 8, by:Number = 8, dis:Number = 1, str:Number = 0.65):BitmapFilter {
			var color:Number = co;
			var angle:Number = an;
			var alpha:Number = al;
			var blurX:Number = bx;
			var blurY:Number = by;
			var distance:Number = dis;
			var strength:Number = str;
			var inner:Boolean = false;
			var knockout:Boolean = false;
			var quality:Number = BitmapFilterQuality.HIGH;
			return new DropShadowFilter(distance,
				angle,
				color,
				alpha,
				blurX,
				blurY,
				strength,
				quality,
				inner,
				knockout);
		}
	}
}