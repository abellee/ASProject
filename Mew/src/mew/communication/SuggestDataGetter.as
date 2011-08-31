package mew.communication {
	import flash.events.EventDispatcher;
	import com.sina.microblog.events.MicroBlogErrorEvent;
	import mew.events.MewEvent;
	import com.sina.microblog.events.MicroBlogEvent;
	import system.MewSystem;
	import config.Config;
	import flash.net.URLRequest;
	import flash.events.Event;
	import mew.data.SuggestData;
	import mew.modules.IEmotionCorrelation;
	import flash.net.URLLoader;
	/**
	 * @author abellee
	 */
	public class SuggestDataGetter extends EventDispatcher {
		private var path:String = "search/suggestions/at_users.xml";
		public var data:Vector.<SuggestData> = null;
		public function SuggestDataGetter(){
			
		}
		public function getData(q:String, type:int = 0):void
		{
			var obj:Object = {};
			obj.q = q;
			obj.type = type;
			MewSystem.microBlog.addEventListener(MewEvent.SUGGESTION_SUCCESS, getSuggestionDataSuccess);
			MewSystem.microBlog.addEventListener(MewEvent.SUGGESTION_FAILED, getSuggestionDataFailed);
			MewSystem.microBlog.callGeneralApi(path, obj, MewEvent.SUGGESTION_SUCCESS, MewEvent.SUGGESTION_FAILED);
		}
		
		private function getSuggestionDataSuccess(event:MicroBlogEvent):void
		{
			MewSystem.microBlog.removeEventListener(MewEvent.SUGGESTION_SUCCESS, getSuggestionDataSuccess);
			MewSystem.microBlog.removeEventListener(MewEvent.SUGGESTION_FAILED, getSuggestionDataFailed);
			
			var xmlList:XML = XML(event.result).children();
			if(xmlList && xmlList.children().length()){
				for each (var xml : XML in xmlList) {
					var suggestData:SuggestData = new SuggestData();
					
				}
			}
			
			this.dispatchEvent(new MewEvent(MewEvent.SUGGESTION_SUCCESS));
		}
		
		private function getSuggestionDataFailed(event:MicroBlogErrorEvent):void
		{
			MewSystem.microBlog.removeEventListener(MewEvent.SUGGESTION_SUCCESS, getSuggestionDataSuccess);
			MewSystem.microBlog.removeEventListener(MewEvent.SUGGESTION_FAILED, getSuggestionDataFailed);
			this.dispatchEvent(new MewEvent(MewEvent.SUGGESTION_FAILED));
		}
	}
}
