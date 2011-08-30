package mew.modules
{
	import flash.events.Event;

	public class Alert extends LightAlert
	{
		public function Alert()
		{
			super();
		}
		override protected function dealloc(event:Event):void
		{
			super.dealloc(event);
		}
	}
}