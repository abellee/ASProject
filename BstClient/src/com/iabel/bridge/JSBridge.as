package com.iabel.bridge 
{
	import com.iabel.command.Command;
	import com.iabel.command.CommandType;
	import flash.external.ExternalInterface;
	/**
	 * ...
	 * @author AbelLee
	 */
	public class JSBridge 
	{
		
		public function JSBridge() 
		{
			
		}
		
		public static function console(data:String):void {
			if (ExternalInterface.available) {
				ExternalInterface.call("onConnectSuccess", data);
			}
		}
		
		public static function addInterface(callback:String, func:Function):void {
			if (!ExternalInterface.available) {
				return;
			}
			ExternalInterface.addCallback(callback, func);
		}
		
		public static function call(cmd:Command):void {
			if (!ExternalInterface.available) {
				return;
			}
			switch(cmd.commandType) {
				case CommandType.CONNECT_SUCCESS:
					ExternalInterface.call("onConnectSuccess", cmd.data);
					break;
				case CommandType.DISCONNECT:
					ExternalInterface.call("onDisconnect", cmd.data);
					break;
				case CommandType.ERROR:
					ExternalInterface.call("onError", cmd.data);
					break;
				case CommandType.INCOMING:
					ExternalInterface.call("onIncoming", cmd.data);
					break;
				case CommandType.LOGIN:
					ExternalInterface.call("onLogin", cmd.data);
					break;
				case CommandType.MESSAGE:
					ExternalInterface.call("onMessage", cmd.data);
					break;
				case CommandType.OUTGOING:
					ExternalInterface.call("onOutgoing", cmd.data);
					break;
				case CommandType.PRESENCE:
					ExternalInterface.call("onPresence", cmd.data);
					break;
			}
		}
		
	}

}