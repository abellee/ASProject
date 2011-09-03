package mew.communication {
	import mew.data.SuggestData;
	import mew.events.MewEvent;

	import system.MewSystem;

	import com.sina.microblog.events.MicroBlogErrorEvent;
	import com.sina.microblog.events.MicroBlogEvent;

	import flash.events.EventDispatcher;
	/**
	 * @author abellee
	 */
	public class SuggestDataGetter extends EventDispatcher {
		private var path:String = "/search/suggestions/at_users.xml";
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
			
			if(!data) data = new Vector.<SuggestData>();
			data.length = 0;
			var xmlList:XMLList = XML(event.result).children();
			if(xmlList && xmlList.children().length()){
				for each (var xml : XML in xmlList) {
					var suggestData:SuggestData = new SuggestData();
					suggestData.id = xml.uid.text();
					suggestData.nickname = xml.nickname.text();
					data.push(suggestData);
				}
			}
			if(data.length) this.dispatchEvent(new MewEvent(MewEvent.SUGGESTION_SUCCESS));
			else this.dispatchEvent(new MewEvent(MewEvent.NO_SUGGESTION));
		}
		
		private function getSuggestionDataFailed(event:MicroBlogErrorEvent):void
		{
			MewSystem.microBlog.removeEventListener(MewEvent.SUGGESTION_SUCCESS, getSuggestionDataSuccess);
			MewSystem.microBlog.removeEventListener(MewEvent.SUGGESTION_FAILED, getSuggestionDataFailed);
			this.dispatchEvent(new MewEvent(MewEvent.SUGGESTION_FAILED));
		}
		
		public function dealloc():void
		{
			path = null;
			data = null;
			MewSystem.microBlog.removeEventListener(MewEvent.SUGGESTION_SUCCESS, getSuggestionDataSuccess);
			MewSystem.microBlog.removeEventListener(MewEvent.SUGGESTION_FAILED, getSuggestionDataFailed);
		}
	}
}
