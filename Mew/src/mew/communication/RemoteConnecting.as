package mew.communication {
	import mew.windows.IUserSubmmit;
	import system.MewSystem;
	import flash.net.NetConnection;
	import flash.net.Responder;

	public class RemoteConnecting
	{
		private var nc:NetConnection = new NetConnection();
		public var target:IUserSubmmit = null;
		public function RemoteConnecting()
		{
			nc.connect("http://mew.iabel.com/amfphp/gateway.php");
		}
		public function submitBugs(str:String):void{
			
			nc.call("MewCustom.postBugs", new Responder(showConfirmPanel, showConfirmPanel), str, MewSystem.app.userData.username + "(" + MewSystem.app.userData.id + ")");
			
		}
		public function submitSuggestion(str:String):void{
			
			nc.call("MewCustom.postSuggestion", new Responder(showConfirmPanel, showConfirmPanel), str, MewSystem.app.userData.username + "(" + MewSystem.app.userData.id + ")");
			
		}
		private function showConfirmPanel(e:String):void{
			
			if(target){
				if(e == "[object Object]") e = "服务器出错!请联系开发者!\n http://weibo.com/abellee";
				target.showSubmitResult(e);
			}
		}
		
		public function destroy():void
		{
			nc.close();
			nc = null;
		}
	}
}