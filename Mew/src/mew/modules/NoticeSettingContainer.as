package mew.modules {
	import config.Config;

	import fl.controls.CheckBox;

	import mew.data.SystemSettingData;
	import mew.factory.ButtonFactory;

	import com.iabel.core.UISprite;

	import flash.events.Event;
	import flash.net.SharedObject;
	
	public class NoticeSettingContainer extends UISprite implements ISystemSettingContainer
	{
		private var atNotice:CheckBox = null;
		private var dmNotice:CheckBox = null;
		private var fansNotice:CheckBox = null;
		private var voiceNotice:CheckBox = null;
		private var weiboNotice:CheckBox = null;
		private var commentNotice:CheckBox = null;
		public function NoticeSettingContainer()
		{
			super();
		}
		
		public function init():void
		{
			if(!atNotice) atNotice = ButtonFactory.SystemCheckBox();
			if(!dmNotice) dmNotice = ButtonFactory.SystemCheckBox();
			if(!fansNotice) fansNotice = ButtonFactory.SystemCheckBox();
			if(!voiceNotice) voiceNotice = ButtonFactory.SystemCheckBox();
			if(!weiboNotice) weiboNotice = ButtonFactory.SystemCheckBox();
			if(!commentNotice) commentNotice = ButtonFactory.SystemCheckBox();
			
			atNotice.label = "开启@我提醒";
			dmNotice.label = "开启私信提醒";
			fansNotice.label = "开启粉丝提醒";
			voiceNotice.label = "开启声音提醒";
			weiboNotice.label = "开启微博提醒";
			commentNotice.label = "开启评论提醒";
			
			addChild(atNotice);
			addChild(dmNotice);
			addChild(fansNotice);
			addChild(voiceNotice);
			addChild(weiboNotice);
			addChild(commentNotice);
			
			weiboNotice.x = voiceNotice.x;
			weiboNotice.y = voiceNotice.height + voiceNotice.y + 10;
			atNotice.x = weiboNotice.x + weiboNotice.width + 10;
			atNotice.y = weiboNotice.y;
			commentNotice.x = weiboNotice.x;
			commentNotice.y = weiboNotice.y + weiboNotice.height + 10;
			fansNotice.x = commentNotice.x + commentNotice.width + 10;
			fansNotice.y = commentNotice.y;
			dmNotice.x = weiboNotice.x;
			dmNotice.y = commentNotice.y + commentNotice.height + 10;
			
			customSetting();
		}
		
		private function customSetting():void
		{
			voiceNotice.selected = SystemSettingData.isVoice;
			weiboNotice.selected = SystemSettingData.weiboNotice;
			atNotice.selected = SystemSettingData.atNotice;
			commentNotice.selected = SystemSettingData.commentNotice;
			fansNotice.selected = SystemSettingData.fansNotice;
			dmNotice.selected = SystemSettingData.dmNotice;
		}
		
		public function setDefault():void
		{
			voiceNotice.selected = true;
			weiboNotice.selected = true;
			atNotice.selected = true;
			commentNotice.selected = true;
			fansNotice.selected = true;
			dmNotice.selected = true;
		}
		
		public function get isVoice():Boolean
		{
			return voiceNotice.selected;
		}
		
		public function save():void
		{
			var so:SharedObject = SharedObject.getLocal(Config.MEWCACHE);
			so.data.isVoice = voiceNotice.selected;
			so.data.atNotice = atNotice.selected;
			so.data.dmNotice = dmNotice.selected;
			so.data.fansNotice = fansNotice.selected;
			so.data.weiboNotice = weiboNotice.selected;
			so.data.commentNotice = commentNotice.selected;
			so.flush();
			
			SystemSettingData.isVoice = voiceNotice.selected;
			SystemSettingData.atNotice = atNotice.selected;
			SystemSettingData.dmNotice = dmNotice.selected;
			SystemSettingData.fansNotice = fansNotice.selected;
			SystemSettingData.weiboNotice = weiboNotice.selected;
			SystemSettingData.commentNotice = commentNotice.selected;
		}
		
		public function get isWBNotice():Boolean
		{
			return weiboNotice.selected;
		}
		
		public function get isAtNotice():Boolean
		{
			return atNotice.selected;
		}
		
		public function get isCommentNotice():Boolean
		{
			return commentNotice.selected;
		}
		
		public function get isFansComment():Boolean
		{
			return fansNotice.selected;
		}
		
		public function get isDMNotice():Boolean
		{
			return dmNotice.selected;
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			voiceNotice = null;
			weiboNotice = null;
			atNotice = null;
			commentNotice = null;
			fansNotice = null;
			dmNotice = null;
		}
		
		/**
		 * for interface
		 */
		public function get isAutoLogin():Boolean
		{
			return true;
		}
		
		public function get hideDir():int
		{
			return 1;
		}
		
		public function get updateDelay():int
		{
			return 0;
		}
		
		public function get alwaysInFront():Boolean
		{
			return true;
		}
		
		public function get isAutoHide():Boolean
		{
			return true;
		}
		
		public function get isAutoRun():Boolean
		{
			return true;
		}
	}
}