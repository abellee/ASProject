package com.iabel
{
	import com.iabel.bridge.JSBridge;
	import com.iabel.command.Command;
	import com.iabel.command.CommandType;
	import com.iabel.config.Config;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.Security;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import org.igniterealtime.xiff.core.EscapedJID;
	import org.igniterealtime.xiff.core.XMPPConnection;
	import org.igniterealtime.xiff.data.Message;
	import org.igniterealtime.xiff.data.Presence;
	import org.igniterealtime.xiff.events.ConnectionSuccessEvent;
	import org.igniterealtime.xiff.events.DisconnectionEvent;
	import org.igniterealtime.xiff.events.IncomingDataEvent;
	import org.igniterealtime.xiff.events.LoginEvent;
	import org.igniterealtime.xiff.events.MessageEvent;
	import org.igniterealtime.xiff.events.OutgoingDataEvent;
	import org.igniterealtime.xiff.events.PresenceEvent;
	import org.igniterealtime.xiff.events.RosterEvent;
	import org.igniterealtime.xiff.events.XIFFErrorEvent;
	import org.igniterealtime.xiff.im.Roster;
	
	/**
	 * ...
	 * @author AbelLee
	 */
	[SWF(width="10", height="10")]
	public class Main extends Sprite 
	{
		private var connection:XMPPConnection;
		private var _roster:Roster;
		
		public function Main():void 
		{
			this.loaderInfo.addEventListener(Event.COMPLETE, selfLoadComplete);
		}
		
		private function selfLoadComplete(event:Event):void {
			this.loaderInfo.removeEventListener(Event.COMPLETE, selfLoadComplete);
			
			var server:String = this.loaderInfo.parameters["server"];
			var port:int = int(this.loaderInfo.parameters["port"]);
			var crossdomainPort:int = int(this.loaderInfo.parameters["cdp"]);
			var domain:String = this.loaderInfo.parameters["domain"];
			Config.host = server ? server : Config.host;
			Config.port = port ? port : Config.port;
			Config.domain = domain ? domain : Config.domain;
			Config.crossdomain_port = crossdomainPort ? crossdomainPort : Config.crossdomain_port;
			
			init();
		}
		
		private function init() : void {
			System.useCodePage = true;
			Security.loadPolicyFile(Config.host + ":" + Config.crossdomain_port);
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			connection = new XMPPConnection();
			connection.addEventListener(ConnectionSuccessEvent.CONNECT_SUCCESS, onConnectionSuccess);
			connection.addEventListener(DisconnectionEvent.DISCONNECT, onDisconnection);
			connection.addEventListener(LoginEvent.LOGIN, onLogin);
			connection.addEventListener(IncomingDataEvent.INCOMING_DATA, onInCommingData);
			connection.addEventListener(MessageEvent.MESSAGE, onMessage);
			connection.addEventListener(OutgoingDataEvent.OUTGOING_DATA, onOutgoingData);
			connection.addEventListener(PresenceEvent.PRESENCE, onPresence);
			connection.addEventListener(XIFFErrorEvent.XIFF_ERROR, onError);
			
			_roster = new Roster();
			_roster.connection = connection;
			
			JSBridge.addInterface("connect", connect);
			JSBridge.addInterface("sendMessage", sendMessage);
			JSBridge.addInterface("disconnect", disconnect);
		}
		
		private function connect(username:String, password:String):void {
			if (connection.loggedIn) return;
			connection.port = Config.port;
			connection.server = Config.host;
			connection.domain = Config.domain;
			connection.username = username;
			connection.password = password;
			connection.resource = "XIFF";
			connection.connect(XMPPConnection.STREAM_TYPE_STANDARD);
		}
		
		private function sendMessage(to:String, content:String):void {
			var msg:Message = new Message();
			msg.to = new EscapedJID(to);
			msg.body = content;
			connection.send(msg);
		}
		
		private function disconnect():void {
			connection.disconnect();
		}
		
		private function onConnectionSuccess(event:ConnectionSuccessEvent):void {
			JSBridge.call(new Command(CommandType.CONNECT_SUCCESS));
		}
		
		private function onDisconnection(event:DisconnectionEvent):void {
			JSBridge.call(new Command(CommandType.DISCONNECT));
		}
		
		private function onLogin(event:LoginEvent):void {
			JSBridge.call(new Command(CommandType.LOGIN));
		}
		
		private function onInCommingData(event:IncomingDataEvent):void {
			trace(event.data.toString());
		}
		
		private function onMessage(event:MessageEvent):void {
			var msg:Message = event.data;
			JSBridge.call(new Command(CommandType.MESSAGE, {from: msg.from.bareJID, to: msg.to.bareJID, msg: msg.body} ));
		}
		
		private function onOutgoingData(event:OutgoingDataEvent):void {
		}
		
		private function onPresence(event:PresenceEvent):void {
		}
		
		private function onError(event:XIFFErrorEvent):void {
			JSBridge.call(new Command(CommandType.ERROR, { errorCode: event.errorCode, errorMessage: event.errorMessage } ));
		}
	}
	
}