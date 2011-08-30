package mew.utils
{
	import com.iabel.util.StringDetector;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.utils.ByteArray;
	
	public class VideoChecker extends EventDispatcher
	{
		private var urlsCache:Array = null;
		private var urlLoader:URLLoader = null;
		
		private var num:int = 0;
		private var index:int = 0;
		public var videoURLs:Array = null;
		public function VideoChecker(target:IEventDispatcher=null)
		{
			super(target);
		}
		public function isVideoURL(arr:Array):void
		{
			urlsCache = arr;
			num = urlsCache.length;
			index = 0;
			videoURLs = [];
			
			checkURL();
		}
		
		private function checkURL():void
		{
			if(index >= num){
				if(urlLoader){
					urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
					urlLoader = null;
				}
				urlsCache = null;
				this.dispatchEvent(new Event(Event.COMPLETE));
				return;
			}
			if(!urlLoader) urlLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onHttpStatus);
			urlLoader.load(new URLRequest(urlsCache[index]));
		}
		
		private function onIOError(event:IOErrorEvent):void
		{
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			urlLoader.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onHttpStatus);
			if(!videoURLs[index]) videoURLs[index] = {};
			videoURLs[index]["site"] = urlsCache[index];
			next();
		}
		
		private function onHttpStatus(event:HTTPStatusEvent):void
		{
			urlLoader.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onHttpStatus);
			var realURL:String = event.responseURL;
			var isYouKu:int = realURL.search(/http:\/\/v.youku.com/);
			if(!videoURLs[index]) videoURLs[index] = {};
			videoURLs[index]["site"] = urlsCache[index];
			var arr:Array;
			if(isYouKu != -1){                                            // is youku video
				videoURLs[index]["source"] = "youku";
				arr = realURL.match(/id_(?P<id>.+?).html/);
				if(arr && arr["id"]) videoURLs[index]["id"] = arr["id"];
				urlLoader.addEventListener(Event.COMPLETE, urlLoadComplete);
				return;
			}
			var isTudou:int = realURL.search(/http:\/\/www.tudou.com/);
			if(isTudou != -1){                                            // is tudou video
				videoURLs[index]["source"] = "tudou";
				arr = realURL.match(/\/p\/[a-z]\d+i(?P<id>\d+).*\.html/);
				if(!arr || !arr.length){
					arr = realURL.match(/[&#\?]iid=(?P<id>\d+)/);
					if(arr) videoURLs[index]["id"] = arr["id"];
				}else videoURLs[index]["id"] = arr["id"];
				urlLoader.addEventListener(Event.COMPLETE, urlLoadComplete);
				return;
			}
			var isKu6:int = realURL.search(/http:\/\/v.ku6.com/);
			if(isKu6 != -1){                                            // is ku6 video
				videoURLs[index]["source"] = "ku6";
				urlLoader.addEventListener(Event.COMPLETE, urlLoadComplete);
				return;
			}
			var isSina:int = realURL.search(/http:\/\/video.sina.com.cn/);
			if(isSina != -1){                                            // is sina video
				videoURLs[index]["source"] = "sina";
				urlLoader.addEventListener(Event.COMPLETE, urlLoadComplete);
				return;
			}
			var is56:int = realURL.search(/http:\/\/www.56.com/);
			if(is56 != -1){                                            // is 56 video
				videoURLs[index]["source"] = "56";
				var slashIndex:int = realURL.lastIndexOf("/");
				var pointIndex:int = realURL.lastIndexOf(".");
				var ida:String = realURL.substring(slashIndex+1, pointIndex);
				if(ida) videoURLs[index]["id"] = ida;
				urlLoader.addEventListener(Event.COMPLETE, urlLoadComplete);
				return;
			}
			var isSohu:int = realURL.search(/http:\/\/tv.sohu.com/);
			if(isSohu != -1){                                            // is sohu video
				videoURLs[index]["source"] = "sohu";
				urlLoader.addEventListener(Event.COMPLETE, urlLoadComplete);
				return;
			}
			var isYinYueTai:int = realURL.search(/http:\/\/www.yinyuetai.com/);
			if(isYinYueTai != -1){                                       // is yinyuetai video
				videoURLs[index]["source"] = "yinyuetai";
				urlLoader.addEventListener(Event.COMPLETE, urlLoadComplete);
				return;
			}
			var isV1:int = realURL.search(/http:\/\/[a-zA-z\d]+.v1.cn/);
			if(isV1 != -1){                                             // is v1 video
				videoURLs[index]["source"] = "v1";
				urlLoader.addEventListener(Event.COMPLETE, urlLoadComplete);
				return;
			}
			var isCNTV:int = realURL.search(/http:\/\/bugu.cntv.cn/);
			if(isCNTV != -1){                                          // is cntv video
				videoURLs[index]["source"] = "cntv";
				urlLoader.addEventListener(Event.COMPLETE, urlLoadComplete);
				return;
			}
			var isJoy:int = realURL.search(/http:\/\/[a-zA-z\d]+.joy.cn/);
			if(isJoy != -1){                                          // is joy video
				videoURLs[index]["source"] = "joy";
				urlLoader.addEventListener(Event.COMPLETE, urlLoadComplete);
				return;
			}
			var isQiyi:int = realURL.search(/http:\/\/[a-zA-z\d]+.qiyi.com/);
			if(isQiyi != -1){                                         // is qiyi video
				videoURLs[index]["source"] = "qiyi";
				urlLoader.addEventListener(Event.COMPLETE, urlLoadComplete);
				return;
			}
			next();
		}
		private function urlLoadComplete(event:Event):void
		{
			urlLoader.removeEventListener(Event.COMPLETE, urlLoadComplete);
			var ba:ByteArray = event.target.data;
			var str:String = ba.readMultiByte(ba.length, "gb2312");
			var value:String = "";
			switch(videoURLs[index]["source"]){
				case "youku":
					if(!videoURLs[index]["id"]){
						value = StringDetector.getParam("videoId2"," '", "';", str);
						videoURLs[index]["src"] = "http://player.youku.com/player.php/sid/" + value + "/v.swf";
					}else{
						videoURLs[index]["src"] = "http://player.youku.com/player.php/sid/" + videoURLs[index]["id"] + "/v.swf";
					}
					var imgArr:Array = str.match(/pic=(?P<img>.+?)\"/);
					if(imgArr && imgArr["img"]) videoURLs[index]["image"] = imgArr["img"];
					var tta:Array = str.match(/<title>(?P<title>.+?)<\/title>/);
					//(?:\s*)(?:-+?)(?:\s*)(?:视频*)(?:\s*)(?:-+?)(?:\s*)(?:优酷视频*)(?:\s*)(?:-+?)(?:\s*)(?:在线观看*)
					if(tta && tta["title"]) videoURLs[index]["title"] = tta["title"];
					break;
				case "tudou":
					if(!videoURLs[index]["id"]){
						var a:Array = str.match(/defaultIid(?:\s*)=(?:\s*)(?P<id>\d+)/);
						if(a && a["id"]) videoURLs[index]["id"] = a["id"];
					}
					var codeArray:Array = str.match(/lcode(?:\s*)=(?:\s*)\'(?P<code>.+?)(?:\s*)\'/);
					if(!codeArray || !codeArray.length){
						var icodeArray:Array = str.match(/icode(?:\s*)=(?:\s*)\'(?P<code>.+?)(?:\s*)\'/);
						if(icodeArray && icodeArray["code"]) videoURLs[index]["code"] = icodeArray["code"];
					}else if(codeArray["code"]) videoURLs[index]["code"] = codeArray["code"];
					if(videoURLs[index]["id"]) videoURLs[index]["src"] = "http://www.tudou.com/l/" + videoURLs[index]["code"] + "/&iid=" + videoURLs[index]["id"] + "/v.swf";
					else videoURLs[index]["src"] = "http://www.tudou.com/v/" + videoURLs[index]["code"] + "/v.swf";
					var imgs:Array = str.match(/pic(?:\s*)[=:](?:\s*)[\'\"](?:\s*)(?P<img>.+?)(?:\s*)[\'\"]/);
					if(imgs && imgs["img"]) videoURLs[index]["image"] = imgs["img"];
					var ta:Array = str.match(/<title>(?P<title>.+?)<\/title>/);
					//(?:\s*)(?:_+?)(?:\s*)(?:在线观看*).+
					if(ta && ta["title"]) videoURLs[index]["title"] = ta["title"];
					break;
				case "ku6":
					var resultArr:Array = str.match(/[\$nsA]\.VideoInfo(?:\s*)=(?:\s*){.+id(?:\s*):(?:\s*)\"(?:\s*)(?P<id>.+?)(?:\s*)\"(?:\s*),(?:\s*)uid.+cover(?:\s*):(?:\s*)\"(?:\s*)(?P<img>.+?)(?:\s*)\"/);
					if(resultArr){
						if(resultArr["id"]) videoURLs[index]["id"] = resultArr["id"];
						if(resultArr["img"]) videoURLs[index]["image"] = resultArr["img"];
						videoURLs[index]["src"] = "http://player.ku6.com/refer/" + videoURLs[index]["id"] + "/v.swf";
					}
					var tArr:Array = str.match(/<title>(?P<title>.+?)<\/title>/);
					//(?:\s*)(?:-+?)(?:\s*)(?:在线观看*).+
					if(tArr && tArr["title"]) videoURLs[index]["title"] = tArr["title"];
					break;
				case "sina":
					var videoArr:Array = str.match(/swfOutsideUrl(?:\s*):(?:\s*)\'(?:\s*)(?P<src>.+?)(?:\s*)\'(?:\s*),/);
					var imgaArr:Array = str.match(/pic(?:\s*):(?:\s*)'(?:\s*)(?P<img>.+?)(?:\s*)\'(?:\s*),/);
					var titleArr:Array = str.match(/title(?:\s*):(?:\s*)\'(?:\s*)(?P<title>.+?)\',/);
					if(videoArr && videoArr["src"]) videoURLs[index]["src"] = videoArr["src"];
					if(imgaArr && imgaArr["img"]) videoURLs[index]["image"] = imgaArr["img"];
					if(titleArr && titleArr["title"]) videoURLs[index]["title"] = titleArr["title"];
					break;
				case "56":
					if(videoURLs[index]["id"]) videoURLs[index]["src"] = "http://player.56.com/" + videoURLs[index]["id"] + ".swf";
					var imga:Array = str.match(/img(?:\s*)\"(?:\s*):(?:\s*)\"(?:\s*)(?P<img>.+?)(?:\s*)\"(?:\s*)}(?:\s*);/);
					if(imga && imga["img"]) videoURLs[index]["image"] = imga["img"];
					var titleRes:Array = str.match(/<title>(?P<title>.+?)<\/title>/);
					//(?:\s*)-(?:\s*).+
					if(titleRes && titleRes["title"]) videoURLs[index]["title"] = titleRes["title"];
					break;
				case "sohu":
					var arr0:Array = str.match(/var(?:\s*)vid(?:\s*)=(?:\s*)\"(?:\s*)(?P<id>.+?)(?:\s*)\"(?:\s*);/);
					if(arr0 && arr0["id"]){
						videoURLs[index]["id"] = arr0["id"];
						videoURLs[index]["src"] = "http://share.vrs.sohu.com/" + videoURLs[index]["id"] + "/v.swf";
					}
					var arr1:Array = str.match(/var(?:\s*)cover(?:\s*)=(?:\s*)\"(?:\s*)(?P<img>.+?)(?:\s*)\"(?:\s*);/);
					if(arr1 && arr1["img"]) videoURLs[index]["image"] = arr1["img"];
					var arr2:Array = str.match(/<title>(?P<title>.+?)<\/title>/);
					//(?:\s*)-(?:\s*).+
					if(arr2 && arr2["title"]) videoURLs[index]["title"] = arr2["title"];
					break;
				case "yinyuetai":
					var arr3:Array = str.match(/<meta(?:\s*)property=\"og:videosrc\"(?:\s*)content=\"(?P<src>.+?)\"(?:\s*)\/>/);
					if(arr3 && arr3["src"]) videoURLs[index]["src"] = arr3["src"];
					var arr4:Array = str.match(/<meta(?:\s*)property(?:\s*)=(?:\s*)\"og:image\"(?:\s*)content=\"(?P<img>.+?)\"(?:\s*)\/>/);
					if(arr4 && arr4["img"]) videoURLs[index]["image"] = arr4["img"];
					var arr5:Array = str.match(/<title>(?P<title>.+?)<\/title>/);
					//(?:[\r\n\t]*)-MV.+
					if(arr5 && arr5["title"]) videoURLs[index]["title"] = arr5["title"];
					break;
				case "v1":
					var arr6:Array = str.match(/<script(?:\s*)type=\"text\/javascript\"(?:\s*)src=\"(?P<jssrc>.+?)\">(?:\s*)<\/script>(?:\s*)<script>writeAlbumHtml\(\{id:\"(?P<id>.+?)\"\}\);<\/script>/);
					if(arr6 && arr6["jssrc"] && arr6["id"]){
						videoURLs[index]["js"] = arr6["jssrc"];
						videoURLs[index]["id"] = arr6["id"];
						urlLoader.addEventListener(Event.COMPLETE, jsLoadComplete);
						urlLoader.load(new URLRequest(videoURLs[index]["js"]));
					}
					var arr7:Array = str.match(/<div class=\"content\">(?:\s*)<h2>(?:\s*)(?P<title>.+?)(?:\s*)<\/h2>/);
					if(arr7 && arr7["title"]) videoURLs[index]["title"] = arr7["title"];
					return;
					break;
				case "cntv":
					var vidArr:Array = str.match(/var(?:\s*)videoCenterId(?:\s*)=(?:\s*)\"(?P<videoCenterId>.+?)\";/);
					var arr8:Array = str.match(/var(?:\s*)videoImage(?:\s*)=(?:\s*)\"(?P<img>.+?)\";/);
					var arr9:Array = str.match(/fo\.addVariable\(\"videoId\"\,(?:\s*)\"(?P<videoId>.+?)\"\)\;/);
					var videoId:String = "";
					if(arr9 && arr9["videoId"]) videoId = arr9["videoId"];
					var filePath:String = "";
					arr9 = str.match(/fo\.addVariable\(\"filePath\"\,(?:\s*)\"(?P<filePath>.+?)\"\)\;/);
					if(arr9 && arr9["filePath"]) filePath = arr9["filePath"];
					var urlStr:String = "";
					arr9 = str.match(/fo\.addVariable\(\"url\"\,(?:\s*)\"(?P<url>.+?)\"\)\;/);
					if(arr9 && arr9["url"]) urlStr = arr9["url"];
					if(arr8 && arr8["img"]) videoURLs[index]["img"] = arr8["img"];
					if(vidArr && vidArr["videoCenterId"]){
						videoURLs[index]["src"] = "http://player.cntv.cn/standard/cntvOutSidePlayer.swf?videoId=" + videoId + "&filePath=" + filePath + "&isAutoPlay=false&url=" + urlStr + "&tai=bugu&configPath=http://bugu.cntv.cn/nettv/Library/ibugu/player/config.xml&widgetsConfig=http://bugu.cntv.cn/nettv/Library/ibugu/player/widgetsConfig.xml&languageConfig=http://bugu.cntv.cn/nettv/Library/ibugu/player/zh_cn.xml&hour24DataURL=&outsideChannelId=channelBugu&videoCenterId=" + vidArr["videoCenterId"];
					}
					var arr10:Array = str.match(/<title>(?P<title>.+?)<\/title>/);
					// _(?:.+?)_中国网络电视台
					if(arr10 && arr10["title"]) videoURLs[index]["title"] = arr10["title"];
					break;
				case "joy":
					var arr11:Array = str.match(/var(?:\s*)\_video\_obj\=\{id\:\"(?P<id>.+?)\"\,.+\,cover\:\"(?P<img>.+?)\"\,.+\,title\:\"(?P<title>.+?)"\,.+\,playUrl\:\".+\"\,sharable\:.+\,pId\:.+\,cId\:.+\,vId\:.+\}\;/);
					if(arr11 && arr11["id"]){
						videoURLs[index]["id"] = arr11["id"];
						videoURLs[index]["image"] = arr11["img"];
						videoURLs[index]["title"] = arr11["title"];
						videoURLs[index]["src"] = "http://client.joy.cn/flvplayer/kx_" + arr11["id"] + "_1_1_1.swf";
					}
					break;
				case "qiyi":
					var vid:String = "";
					var vidaArr:Array = str.match(/videoId(?:\s*):(?:\s*)\"(?P<vid>.+?)\",/);
					if(vidaArr && vidaArr["vid"]) vid = vidaArr["vid"];
					var pid:String = "";
					var pidArr:Array = str.match(/pid(?:\s*):(?:\s*)\"(?P<pid>.+?)\",/);
					if(pidArr && pidArr["pid"]) pid = pidArr["pid"];
					var ptype:String = "";
					var ptypeArr:Array = str.match(/ptype(?:\s*):(?:\s*)\"(?P<ptype>.+?)\",/);
					if(ptypeArr && ptypeArr["ptype"]) ptype = ptypeArr["ptype"];
					var albumId:String = "";
					var albumIdArr:Array = str.match(/albumId(?:\s*):(?:\s*)\"(?P<albumId>.+?)\",/);
					if(albumIdArr && albumIdArr["albumId"]) albumId = albumIdArr["albumId"];
					var tvId:String = "";
					var tvIdArray:Array = str.match(/tvId(?:\s*):(?:\s*)\"(?P<tvId>.+?)\",/);
					if(tvIdArray && tvIdArray["tvId"]) tvId = tvIdArray["tvId"];
					var urlArr:Array = str.match(/var(?:\s*)flashUrl(?:\s*)=(?:\s*)\'(?P<url>.+?)\';/);
					var titleArr0:Array = str.match(/title(?:\s*):(?:\s*)\"(?P<title>.+?)\",/);
					if(titleArr0 && titleArr0["title"]) videoURLs[index]["title"] = titleArr0["title"];
					if(urlArr && urlArr["url"]){
						videoURLs[index]["src"] = urlArr["url"] + "?vid=" + vid + "&pid=" + pid + "&ptype=" + ptype + "&albumId=" + albumId + "&tvId=" + tvId;
					}
					break;
			}
			next();
		}
		private function next():void
		{
			index++;
			checkURL();
		}
		private function jsLoadComplete(event:Event):void
		{
			urlLoader.removeEventListener(Event.COMPLETE, jsLoadComplete);
			var ba:ByteArray = event.target.data;
			var str:String = ba.readMultiByte(ba.length, "gb2312");
			var resArr:Array = str.match(/html8(?:\s*)\+=(?:\s*)\"<embed(?:\s*)src=(?P<src>.+?)(?:\s*)FlashVars=id=\"(?:\s*).+<\/object>\";/);
			if(resArr && resArr["src"]){
				if(videoURLs[index]["id"]) videoURLs[index]["src"] = resArr["src"] + "&id=" + videoURLs[index]["id"];
				if(videoURLs[index]["title"]){
					urlLoader.addEventListener(Event.COMPLETE, wdFileLoadComplete);
					urlLoader.load(new URLRequest("http://search.v1.cn/sRC.action?wd=" + videoURLs[index]["title"]));
				}else{
					next();
				}
			}else{
				next();
			}
		}
		private function wdFileLoadComplete(event:Event):void
		{
			urlLoader.removeEventListener(Event.COMPLETE, wdFileLoadComplete);
			var ba:ByteArray = event.target.data;
			var str:String = ba.readMultiByte(ba.length, "gb2312");
			var arr:Array = str.match(/photo(?:\s*):(?:\s*)\'(?:\s*)(?P<img>.+?)(?:\s*)\'/);
			if(arr && arr["img"]) videoURLs[index]["image"] = arr["img"];
			next();
		}
	}
}