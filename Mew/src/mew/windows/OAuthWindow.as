package mew.windows
{
	import com.adobe.crypto.HMAC;
	import com.adobe.crypto.SHA1;
	import com.dynamicflash.util.Base64;
	import com.greensock.TweenLite;
	import com.iabel.util.URLDetector;
	import com.sina.microblog.MicroBlog;
	import com.sina.microblog.events.MicroBlogEvent;
	import com.sina.microblog.utils.GUID;
	import com.sina.microblog.utils.StringEncoders;
	
	import config.Config;
	
	import flash.display.NativeWindowInitOptions;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.html.HTMLLoader;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import mew.data.SystemSettingData;
	
	public class OAuthWindow extends ALNativeWindow
	{
		private var oauthLoader:URLLoader;
		private var _html:HTMLLoader;
		private var _pin:String = "";
		public function OAuthWindow(initOptions:NativeWindowInitOptions)
		{
			super(initOptions);
		}
		
		override protected function init():void
		{
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.nativeWindow.alwaysInFront = SystemSettingData.alwaysInfront;
			
			this.stage.nativeWindow.width = 780;
			this.stage.nativeWindow.height = 400;
			
			if(!oauthLoader) oauthLoader = new URLLoader();
			oauthLoader.addEventListener(Event.COMPLETE, oauthLoader_loadCompleteHandler);
			var req:URLRequest = new URLRequest("http://api.t.sina.com.cn/oauth/request_token");
			req.method = URLRequestMethod.POST;
			var params:URLVariables = new URLVariables();
			var now:Date = new Date();
			params["oauth_consumer_key"] = Config.appKey;
			params["oauth_signature_method"] = "HMAC-SHA1";
			params["oauth_timestamp"] = now.time.toString().substr(0, 10);
			params["oauth_nonce"] = GUID.createGUID();
			params["oauth_version"]="1.0";
			params["oauth_callback"] = "http://api.t.sina.com.cn/flash/callback.htm";
			var retParams:Array=[];
			for (var param:String in params)
			{
				if(params[param] != null) retParams.push(param + "=" + StringEncoders.urlEncodeUtf8String(params[param].toString()));
			}
			retParams.sort();
			var paramsStr:String = retParams.join("&");
			var msgStr:String=StringEncoders.urlEncodeUtf8String(URLRequestMethod.POST.toUpperCase()) + "&";
			msgStr+=StringEncoders.urlEncodeUtf8String("http://api.t.sina.com.cn/oauth/request_token");
			msgStr+="&";
			msgStr += StringEncoders.urlEncodeUtf8String(paramsStr);    
			var secrectStr:String = Config.appSecret + "&";
			var sig:String = Base64.encode(HMAC.hash(secrectStr, msgStr, SHA1));        
			params["oauth_signature"] = sig;
			req.data = params;
			oauthLoader.load(req);
		}
		
		private function oauthLoader_loadCompleteHandler(event:Event):void
		{
			var needRequestAuthorize:Boolean = Config._accessTokenKey.length == 0;
			var result:String = oauthLoader.data as String;
			
			if (result.length > 0)
			{
				var urlVar:URLVariables = new URLVariables(oauthLoader.data);
				Config._accessTokenKey = urlVar.oauth_token;
				Config._accessTokenSecret = urlVar.oauth_token_secret;
				
				if (needRequestAuthorize)
				{
					var url:String = "http://api.t.sina.com.cn/oauth/authorize";
					url+="?oauth_token=" + StringEncoders.urlEncodeUtf8String(Config._accessTokenKey);
					url += "&oauth_callback=http://api.t.sina.com.cn/flash/callback.htm";
					if(!_html) _html = new HTMLLoader();
					var urlReq:URLRequest = new URLRequest(url);
					_html.addEventListener(Event.COMPLETE, htmlLoad_completeHandler);
					_html.addEventListener(Event.LOCATION_CHANGE, onLocationChange);
					_html.width = 780;
					_html.height = 400;
					_html.load(urlReq); 
					this.stage.stageWidth = _html.width;
					this.stage.stageHeight = _html.height;
					needRequestAuthorize=false;
				}else {
					if(this.stage.contains(_html)) removeChild(_html);
					if(_html){
						_html.removeEventListener(Event.COMPLETE, htmlLoad_completeHandler);
						_html.removeEventListener(Event.LOCATION_CHANGE, onLocationChange);
					}
					if(oauthLoader) oauthLoader.removeEventListener(Event.COMPLETE, oauthLoader_loadCompleteHandler);
					_html = null;
					oauthLoader = null;
					LoginWindow.instance.verifyCredential();
				}
			}
			
		}
		
		private function htmlLoad_completeHandler(event:Event):void
		{
			_html.removeEventListener(Event.COMPLETE, htmlLoad_completeHandler);
			_html.alpha = 0;
			addChild(_html);
			TweenLite.to(_html, .3, {alpha:1});
		}
		
		private function onLocationChange(event:Event):void
		{
			var lc:String = _html.location;
			var arr:Array = String(lc.split("?")[1]).split("&");
			var oauth_token:String = "";
			var oauth_verifier:String = "";
			for (var i:int = 0 ; i < arr.length; i ++)
			{
				var str:String = arr[i];
				if (str.indexOf("oauth_token=") >= 0) oauth_token = str.split("=")[1];
				if (str.indexOf("oauth_verifier=") >= 0) oauth_verifier = str.split("=")[1];
			}
			
			if (oauth_verifier != "") {
				
				_pin = oauth_verifier;
				
				var req:URLRequest = new URLRequest("http://api.t.sina.com.cn/oauth/access_token");
				req.method = URLRequestMethod.POST;
				
				var params:URLVariables = new URLVariables;
				var now:Date=new Date();
				params["oauth_consumer_key"]=Config.appKey;
				if (Config._accessTokenKey.length > 0)	params["oauth_token"] = Config._accessTokenKey;
				if (_pin && _pin.length > 0) params["oauth_verifier"] = _pin;
				params["oauth_signature_method"]="HMAC-SHA1";
				params["oauth_timestamp"]=now.time.toString().substr(0, 10);
				params["oauth_nonce"]=GUID.createGUID();
				params["oauth_version"]="1.0";
				params["oauth_callback"] = "oob";
				
				var retParams:Array=[];
				for (var param:String in params)
				{
					if(params[param] != null) retParams.push(param + "=" + StringEncoders.urlEncodeUtf8String(params[param].toString()));
				}
				retParams.sort();
				var paramsStr:String =  retParams.join("&");
				
				var msgStr:String=StringEncoders.urlEncodeUtf8String(URLRequestMethod.POST.toUpperCase()) + "&";
				msgStr+=StringEncoders.urlEncodeUtf8String("http://api.t.sina.com.cn/oauth/access_token");
				msgStr+="&";
				msgStr += StringEncoders.urlEncodeUtf8String(paramsStr);		
				var secrectStr:String = Config.appSecret + "&";		
				secrectStr += Config._accessTokenSecret;		
				var sig:String = Base64.encode(HMAC.hash(secrectStr, msgStr, SHA1));
				params["oauth_signature"] = sig;			
				req.data = params;
				oauthLoader.load(req);
			}
		}
		
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
			if(_html){
				_html.removeEventListener(Event.COMPLETE, htmlLoad_completeHandler);
				_html.removeEventListener(Event.LOCATION_CHANGE, onLocationChange);
				_html = null;
			}
			if(oauthLoader) oauthLoader.removeEventListener(Event.COMPLETE, oauthLoader_loadCompleteHandler);
			oauthLoader = null;
			_pin = null;
		}
	}
}