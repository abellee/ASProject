package mew.factory
{
	import fl.controls.Button;
	import fl.controls.CheckBox;
	import fl.controls.NumericStepper;
	
	import flash.text.TextFieldAutoSize;
	
	import widget.Widget;

	public class ButtonFactory
	{
		public function ButtonFactory()
		{
		}
		
		public static function RepostButton():Button
		{
			var btn:Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = 10;
			return btn;
		}
		
		public static function DeleteButton():Button
		{
			var btn:Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = 10;
			return btn;
		}
		
		public static function CollectionButton():Button
		{
			var btn:Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = 10;
			return btn;
		}
		
		public static function CommentButton():Button
		{
			var btn:Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = 10;
			return btn;
		}
		
		public static function PlayButton():Button
		{
			var btn:Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = 10;
			return btn;
		}
		
		public static function CloseButton():Button
		{
			var btn:Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = 20;
			return btn;
		}
		
		public static function EnterButton():Button
		{
			var btn:Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.label = "确定";
			btn.width = 60;
			return btn;
		}
		
		public static function CancelButton():Button
		{
			var btn:Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.label = "取消";
			btn.width = 60;
			return btn;
		}
		
		public static function DefaultButton():Button
		{
			var btn:Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.label = "恢复默认";
			btn.width = 100;
			return btn;
		}
		
		public static function SystemSettingTab():Button
		{
			var btn:Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.label = "系统设置";
			btn.width = 100;
			return btn;
		}
		
		public static function NoticeSettingTab():Button
		{
			var btn:Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.label = "提示设置";
			btn.width = 100;
			return btn;
		}
		
		public static function AccountSettingTab():Button
		{
			var btn:Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.label = "帐号设置";
			btn.width = 100;
			return btn;
		}
		
		public static function ClearAccountCacheButton():Button
		{
			var btn:Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.label = "清除帐号缓存";
			btn.width = 120;
			return btn;
		}
		
		public static function UpdateButton():Button
		{
			var btn:Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.label = "更新";
			btn.width = 60;
			return btn;
		}
		
		public static function SkipButton():Button
		{
			var btn:Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.label = "跳过些版本";
			btn.width = 100;
			return btn;
		}
		
		public static function SendButton():Button
		{
			var btn:Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.label = "发送";
			btn.width = 60;
			return btn;
		}
		
		public static function ScreenShotButton():Button
		{
			var btn:Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.label = "截图";
			btn.width = 60;
			return btn;
		}
		
		public static function EmotionButton():Button
		{
			var btn:Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.label = "表情";
			btn.width = 60;
			return btn;
		}
		
		public static function TopicButton():Button
		{
			var btn:Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.label = "话题";
			btn.width = 60;
			return btn;
		}
		
		public static function ClearButton():Button
		{
			var btn:Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.label = "清空";
			btn.width = 60;
			return btn;
		}
		
		public static function ShortURLButton():Button
		{
			var btn:Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.label = "短网址";
			btn.width = 60;
			return btn;
		}
		
		public static function PageButton():Button
		{
			var btn:Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.label = "翻页";
			btn.width = 50;
			return btn;
		}
		
		public static function ClockButton():Button
		{
			var btn:Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.label = "时间";
			btn.width = 50;
			return btn;
		}
		
		public static function TimingArrow(rotate:int=0):Button
		{
			var btn:Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = 20;
			return btn;
		}
		
		public static function TimingClockButton():Button
		{
			var btn:Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = 40;
			return btn;
		}
		
		public static function EmotionTabButton():Button
		{
			var btn:Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = 60;
			return btn;
		}
		
		public static function ArrowButton():Button
		{
			var btn:Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = 30;
			return btn;
		}
		
		public static function UserHomeButton():Button
		{
			var btn:Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = 60;
			return btn;
		}
		
		public static function UserProfileButton():Button
		{
			var btn:Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = 60;
			return btn;
		}
		
		public static function UserFollowButton():Button
		{
			var btn:Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = 60;
			return btn;
		}
		
		public static function UserFansButton():Button
		{
			var btn:Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = 60;
			return btn;
		}
		
		public static function UserCollectionButton():Button
		{
			var btn:Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = 60;
			return btn;
		}
		
		public static function SystemCheckBox():CheckBox
		{
			var cb:CheckBox = new CheckBox();
			cb.textField.autoSize = TextFieldAutoSize.LEFT;
			cb.setStyle("textFormat", Widget.normalFormat);
			return cb;
		}
		
		public static function SystemNummericStepper():NumericStepper
		{
			var ns:NumericStepper = new NumericStepper();
			ns.textField.textField.autoSize = TextFieldAutoSize.LEFT;
			ns.setStyle("textFormat", Widget.normalFormat);
			return ns;
		}
	}
}