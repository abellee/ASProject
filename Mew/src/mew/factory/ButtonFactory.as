package mew.factory {
	import fl.controls.Button;
	import fl.controls.CheckBox;
	import fl.controls.ComboBox;
	import fl.controls.NumericStepper;

	import mew.modules.UIButton;

	import resource.Resource;

	import widget.Widget;

	import com.iabel.util.ScaleBitmap;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;

	public class ButtonFactory {
		public function ButtonFactory() {
		}

		public static function MainIndexButton() : UIButton {
			var btn : Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			var upSkin : Bitmap = new Bitmap(StaticAssets.IndexButtonUp());
			var overSkin : Bitmap = new Bitmap(StaticAssets.IndexButtonOver());
			var downSkin : Bitmap = new Bitmap(StaticAssets.IndexButtonDown());
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", overSkin);
			btn.setStyle("downSkin", downSkin);
			btn.setStyle("selectedUpSkin", downSkin);
			btn.setStyle("selectedOverSkin", downSkin);
			btn.setStyle("selectedDownSkin", downSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = upSkin.width;
			btn.height = upSkin.height;
			btn.label = "";
			btn.emphasized = false;
			return new UIButton(btn, "首 页", 4);
		}

		public static function MainAtButton() : UIButton {
			var btn : Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			var upSkin : Bitmap = new Bitmap(StaticAssets.AtButtonUp());
			var overSkin : Bitmap = new Bitmap(StaticAssets.AtButtonOver());
			var downSkin : Bitmap = new Bitmap(StaticAssets.AtButtonDown());
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", overSkin);
			btn.setStyle("downSkin", downSkin);
			btn.setStyle("selectedUpSkin", downSkin);
			btn.setStyle("selectedOverSkin", downSkin);
			btn.setStyle("selectedDownSkin", downSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = upSkin.width;
			btn.height = upSkin.height;
			btn.label = "";
			btn.emphasized = false;
			return new UIButton(btn, "@ 我", 3);
		}

		public static function MainCommentButton() : UIButton {
			var btn : Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			var upSkin : Bitmap = new Bitmap(StaticAssets.CommentButtonUp());
			var overSkin : Bitmap = new Bitmap(StaticAssets.CommentButtonOver());
			var downSkin : Bitmap = new Bitmap(StaticAssets.CommentButtonDown());
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", overSkin);
			btn.setStyle("downSkin", downSkin);
			btn.setStyle("selectedUpSkin", downSkin);
			btn.setStyle("selectedOverSkin", downSkin);
			btn.setStyle("selectedDownSkin", downSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = upSkin.width;
			btn.height = upSkin.height;
			btn.label = "";
			btn.emphasized = false;
			return new UIButton(btn, "评 论", 4);
		}

		public static function MainDMButton() : UIButton {
			var btn : Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			var upSkin : Bitmap = new Bitmap(StaticAssets.DMButtonUp());
			var overSkin : Bitmap = new Bitmap(StaticAssets.DMButtonOver());
			var downSkin : Bitmap = new Bitmap(StaticAssets.DMButtonDown());
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", overSkin);
			btn.setStyle("downSkin", downSkin);
			btn.setStyle("selectedUpSkin", downSkin);
			btn.setStyle("selectedOverSkin", downSkin);
			btn.setStyle("selectedDownSkin", downSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = upSkin.width;
			btn.height = upSkin.height;
			btn.label = "";
			btn.emphasized = false;
			return new UIButton(btn, "私 信", 2);
		}

		public static function MainCollectButton() : UIButton {
			var btn : Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			var upSkin : Bitmap = new Bitmap(StaticAssets.CollectButtonUp());
			var overSkin : Bitmap = new Bitmap(StaticAssets.CollectButtonOver());
			var downSkin : Bitmap = new Bitmap(StaticAssets.CollectButtonDown());
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", overSkin);
			btn.setStyle("downSkin", downSkin);
			btn.setStyle("selectedUpSkin", downSkin);
			btn.setStyle("selectedOverSkin", downSkin);
			btn.setStyle("selectedDownSkin", downSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = upSkin.width;
			btn.height = upSkin.height;
			btn.label = "";
			btn.emphasized = false;
			return new UIButton(btn, "收 藏", 2);
		}

		public static function MainFansButton() : UIButton {
			var btn : Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			var upSkin : Bitmap = new Bitmap(StaticAssets.FansButtonUp());
			var overSkin : Bitmap = new Bitmap(StaticAssets.FansButtonOver());
			var downSkin : Bitmap = new Bitmap(StaticAssets.FansButtonDown());
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", overSkin);
			btn.setStyle("downSkin", downSkin);
			btn.setStyle("selectedUpSkin", downSkin);
			btn.setStyle("selectedOverSkin", downSkin);
			btn.setStyle("selectedDownSkin", downSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = upSkin.width;
			btn.height = upSkin.height;
			btn.label = "";
			btn.emphasized = false;
			return new UIButton(btn, "粉 丝", 2);
		}

		public static function MainFollowButton() : UIButton {
			var btn : Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			var upSkin : Bitmap = new Bitmap(StaticAssets.FollowButtonUp());
			var overSkin : Bitmap = new Bitmap(StaticAssets.FollowButtonOver());
			var downSkin : Bitmap = new Bitmap(StaticAssets.FollowButtonDown());
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", overSkin);
			btn.setStyle("downSkin", downSkin);
			btn.setStyle("selectedUpSkin", downSkin);
			btn.setStyle("selectedOverSkin", downSkin);
			btn.setStyle("selectedDownSkin", downSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = upSkin.width;
			btn.height = upSkin.height;
			btn.label = "";
			btn.emphasized = false;
			return new UIButton(btn, "关 注", 2);
		}

		public static function MainSystemButton() : UIButton {
			var btn : Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			var upSkin : Bitmap = new Bitmap(StaticAssets.SystemButtonUp());
			var overSkin : Bitmap = new Bitmap(StaticAssets.SystemButtonOver());
			var downSkin : Bitmap = new Bitmap(StaticAssets.SystemButtonDown());
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", overSkin);
			btn.setStyle("downSkin", downSkin);
			btn.setStyle("selectedUpSkin", downSkin);
			btn.setStyle("selectedOverSkin", downSkin);
			btn.setStyle("selectedDownSkin", downSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = upSkin.width;
			btn.height = upSkin.height;
			btn.label = "";
			btn.emphasized = false;
			return new UIButton(btn, "系 统", 2);
		}

		public static function MainSearchButton() : UIButton {
			var btn : Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			var upSkin : Bitmap = new Bitmap(StaticAssets.SearchButtonUp());
			var overSkin : Bitmap = new Bitmap(StaticAssets.SearchButtonOver());
			var downSkin : Bitmap = new Bitmap(StaticAssets.SearchButtonDown());
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", overSkin);
			btn.setStyle("downSkin", downSkin);
			btn.setStyle("selectedUpSkin", downSkin);
			btn.setStyle("selectedOverSkin", downSkin);
			btn.setStyle("selectedDownSkin", downSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = upSkin.width;
			btn.height = upSkin.height;
			btn.label = "";
			btn.emphasized = false;
			return new UIButton(btn, "搜 索", 2);
		}

		public static function MainMewButton() : Button {
			var btn : Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			var upSkin : Bitmap = new Bitmap(StaticAssets.MewButtonUp());
			var overSkin : Bitmap = new Bitmap(StaticAssets.MewButtonOver());
			var downSkin : Bitmap = new Bitmap(StaticAssets.MewButtonDown());
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", overSkin);
			btn.setStyle("downSkin", downSkin);
			btn.setStyle("selectedUpSkin", downSkin);
			btn.setStyle("selectedOverSkin", downSkin);
			btn.setStyle("selectedDownSkin", downSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = upSkin.width;
			btn.height = upSkin.height;
			btn.label = "";
			btn.emphasized = false;
			return btn;
		}

		public static function MainPublishButton() : UIButton {
			var btn : Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			var upSkin : Bitmap = new Bitmap(StaticAssets.PublishButtonUp());
			var overSkin : Bitmap = new Bitmap(StaticAssets.PublishButtonOver());
			var downSkin : Bitmap = new Bitmap(StaticAssets.PublishButtonDown());
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", overSkin);
			btn.setStyle("downSkin", downSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = upSkin.width;
			btn.height = upSkin.height;
			btn.label = "";
			btn.emphasized = false;
			return new UIButton(btn, "发微博", 0);
		}

		public static function RepostButton() : Button {
			var btn : Button = new Button();
			var upSkin : Bitmap = new Resource.ReposeMouseUp();
			var overSkin : Bitmap = new Resource.RepostMouseOver();
			var downSkin : Bitmap = new Resource.RepostMouseDown();
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", overSkin);
			btn.setStyle("downSkin", downSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = upSkin.width;
			btn.height = upSkin.height;
			btn.label = "";
			btn.emphasized = false;
			return btn;
		}

		public static function DeleteButton() : Button {
			var btn : Button = new Button();
			var upSkin : Bitmap = new Resource.DeleteButtonUp();
			var overSkin : Bitmap = new Resource.DeleteButtonOver();
			var downSkin : Bitmap = new Resource.DeleteButtonDown();
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", overSkin);
			btn.setStyle("downSkin", downSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = upSkin.width;
			btn.height = upSkin.height;
			btn.label = "";
			btn.emphasized = false;
			return btn;
		}

		public static function CollectionButton() : Button {
			var btn : Button = new Button();
			var upSkin : Bitmap = new Resource.CollectButtonUp();
			var overSkin : Bitmap = new Resource.CollectButtonOver();
			var downSkin : Bitmap = new Resource.CollectButtonDown();
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", overSkin);
			btn.setStyle("downSkin", downSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = upSkin.width;
			btn.height = upSkin.height;
			btn.label = "";
			btn.emphasized = false;
			return btn;
		}

		public static function MessageButton() : Button {
			var btn : Button = new Button();
			var upSkin : Bitmap = new Resource.UserDMMouseUp();
			var overSkin : Bitmap = new Resource.UserDMMouseOver();
			var downSkin : Bitmap = new Resource.UserDMMouseDown();
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", overSkin);
			btn.setStyle("downSkin", downSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = upSkin.width;
			btn.height = upSkin.height;
			btn.label = "";
			btn.emphasized = false;
			return btn;
		}

		public static function CommentButton() : Button {
			var btn : Button = new Button();
			var upSkin : Bitmap = new Resource.CommentButtonUp();
			var overSkin : Bitmap = new Resource.CommentButtonOver();
			var downSkin : Bitmap = new Resource.CommentButtonDown();
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", overSkin);
			btn.setStyle("downSkin", downSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = upSkin.width;
			btn.height = upSkin.height;
			btn.label = "";
			btn.emphasized = false;
			return btn;
		}

		public static function PlayButton() : Button {
			var btn : Button = new Button();
			var upSkin : Bitmap = new Resource.VideoPlayButton();
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", upSkin);
			btn.setStyle("downSkin", upSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = upSkin.width;
			btn.height = upSkin.height;
			btn.label = "";
			btn.emphasized = false;
			return btn;
		}

		public static function CloseButton() : Button {
			var btn : Button = new Button();
			var upSkin : Bitmap = new (Resource.CloseButtonSkin)();
			var overSkin : Bitmap = new (Resource.CloseButtonOverSkin)();
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", overSkin);
			btn.setStyle("downSkin", upSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.label = "";
			btn.width = upSkin.width;
			btn.height = upSkin.height;
			btn.emphasized = false;
			return btn;
		}

		public static function ImageDownloadButton() : Button {
			var btn : Button = new Button();
			var upSkin : Bitmap = new (Resource.ImageDownload)();
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", upSkin);
			btn.setStyle("downSkin", upSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.label = "";
			btn.width = upSkin.width;
			btn.height = upSkin.height;
			btn.emphasized = false;
			return btn;
		}

		public static function WhiteButton() : Button {
			var btn : Button = new Button();
			var upSkin : Bitmap = new ScaleBitmap((new (Resource.WhiteButtonUp)() as Bitmap).bitmapData, "auto", true);
			upSkin.scale9Grid = new Rectangle(6, 6, 10, 12);
			var overSkin : Bitmap = new ScaleBitmap((new (Resource.WhiteButtonOver)() as Bitmap).bitmapData, "auto", true);
			overSkin.scale9Grid = new Rectangle(6, 6, 10, 12);
			var downSkin : Bitmap = new ScaleBitmap((new (Resource.WhiteButtonDown)() as Bitmap).bitmapData, "auto", true);
			downSkin.scale9Grid = new Rectangle(6, 6, 10, 12);
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", overSkin);
			btn.setStyle("downSkin", downSkin);
			btn.setStyle("disabledSkin", downSkin);
			btn.setStyle("selectedUpSkin", downSkin);
			btn.setStyle("selectedOverSkin", downSkin);
			btn.setStyle("selectedDownSkin", downSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.label = "";
			btn.width = upSkin.width;
			btn.height = upSkin.height;
			btn.emphasized = false;
			return btn;
		}

		public static function BlackButton() : Button {
			var btn : Button = new Button();
			var upSkin : Bitmap = new ScaleBitmap((new (Resource.ButtonSkin)() as Bitmap).bitmapData, "auto", true);
			upSkin.scale9Grid = new Rectangle(8, 8, 12, 12);
			var overSkin : Bitmap = new ScaleBitmap((new (Resource.ButtonOverSkin)() as Bitmap).bitmapData, "auto", true);
			overSkin.scale9Grid = new Rectangle(8, 8, 12, 12);
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", overSkin);
			btn.setStyle("downSkin", upSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.label = "";
			btn.emphasized = false;
			return btn;
		}

		public static function OrangeButton() : Button {
			var btn : Button = new Button();
			var upSkin : Bitmap = new ScaleBitmap((new (Resource.OrangeButtonSkin)() as Bitmap).bitmapData, "auto", true);
			upSkin.scale9Grid = new Rectangle(8, 8, 12, 12);
			var overSkin : Bitmap = new ScaleBitmap((new (Resource.OrangeOverSkin)() as Bitmap).bitmapData, "auto", true);
			overSkin.scale9Grid = new Rectangle(8, 8, 12, 12);
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", overSkin);
			btn.setStyle("downSkin", upSkin);
			btn.setStyle("disabledSkin", overSkin);
			btn.setStyle("selectedUpSkin", overSkin);
			btn.setStyle("selectedOverSkin", overSkin);
			btn.setStyle("selectedDownSkin", overSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.label = "";
			btn.emphasized = false;
			return btn;
		}

		public static function SearchButton() : Button {
			var btn : Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			var upSkin : Bitmap = new (Resource.SearchMouseUpSkin)();
			var overSkin : Bitmap = new (Resource.SearchMouseOverSkin)();
			var downSkin : Bitmap = new (Resource.SearchMouseDownSkin)();
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", overSkin);
			btn.setStyle("downSkin", downSkin);
			btn.setStyle("selectedUpSkin", downSkin);
			btn.setStyle("selectedOverSkin", downSkin);
			btn.setStyle("selectedDownSkin", downSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = upSkin.width;
			btn.height = upSkin.height;
			btn.label = "";
			btn.emphasized = false;
			return btn;
		}

		public static function ScreenShotButton() : Button {
			var btn : Button = new Button();
			var upSkin : Bitmap = new Resource.ScreenShotSkin();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", upSkin);
			btn.setStyle("downSkin", upSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.label = "";
			btn.width = upSkin.width;
			btn.height = upSkin.height;
			return btn;
		}

		public static function EmotionButton() : Button {
			var btn : Button = new Button();
			var upSkin : Bitmap = new Resource.EmotionButtonSkin();
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", upSkin);
			btn.setStyle("downSkin", upSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = upSkin.width;
			btn.height = upSkin.height;
			btn.label = "";
			return btn;
		}

		public static function FollowButton() : Button {
			var btn : Button = new Button();
			var upSkin : Bitmap = new (Resource.AddButtonUp)();
			var overSkin : Bitmap = new (Resource.AddButtonOver)();
			var downSkin : Bitmap = new (Resource.AddButtonDown)();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", overSkin);
			btn.setStyle("downSkin", downSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.label = "";
			btn.width = upSkin.width;
			btn.height = upSkin.height;
			return btn;
		}

		public static function MinusButton() : Button {
			var btn : Button = new Button();
			var upSkin : Bitmap = new (Resource.MinusUp)();
			var overSkin : Bitmap = new (Resource.MinusOver)();
			var downSkin : Bitmap = new (Resource.MinusDown)();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", overSkin);
			btn.setStyle("downSkin", downSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.label = "";
			btn.width = upSkin.width;
			btn.height = upSkin.height;
			return btn;
		}

		public static function AtButton() : Button {
			var btn : Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			var upSkin : Bitmap = new (Resource.UserAtMouseUp)();
			var overSkin : Bitmap = new (Resource.UserAtMouseOver)();
			var downSkin : Bitmap = new (Resource.UserAtMouseDown)();
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", overSkin);
			btn.setStyle("downSkin", downSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.label = "";
			btn.width = upSkin.width;
			btn.height = upSkin.height;
			return btn;
		}

		public static function TopicButton() : Button {
			var btn : Button = new Button();
			var upSkin : Bitmap = new Resource.TopicButtonSkin();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", upSkin);
			btn.setStyle("downSkin", upSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.label = "";
			btn.width = upSkin.width;
			btn.height = upSkin.height;
			return btn;
		}

		public static function ClearButton() : Button {
			var btn : Button = new Button();
			var upSkin : Bitmap = new Resource.ClearButtonSkin();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", upSkin);
			btn.setStyle("downSkin", upSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.label = "";
			btn.width = upSkin.width;
			btn.height = upSkin.height;
			return btn;
		}

		public static function ShortURLButton() : Button {
			var btn : Button = new Button();
			var upSkin : Bitmap = new Resource.URLShorttenSkin();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", upSkin);
			btn.setStyle("downSkin", upSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.label = "";
			btn.width = upSkin.width;
			btn.height = upSkin.height;
			return btn;
		}

		public static function PageButton() : Button {
			var btn : Button = new Button();
			var upSkin : Bitmap = new Resource.EmotionFlipperButtonUp();
			var overSkin : Bitmap = new Resource.EmotionFlipperMouseOver();
			var downSkin : Bitmap = new Resource.EmotionFlipperButtonDown();
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", overSkin);
			btn.setStyle("downSkin", downSkin);
			btn.setStyle("disabledSkin", downSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.setStyle("selectedUpSkin", downSkin);
			btn.setStyle("selectedOverSkin", downSkin);
			btn.setStyle("selectedDownSkin", downSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = upSkin.width - 5;
			btn.height = upSkin.height - 5;
			btn.label = "";
			return btn;
		}

		public static function ClockButton() : Button {
			var btn : Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.label = "时间";
			btn.width = 50;
			return btn;
		}

		public static function TimingArrow(scale : int) : Button {
			var btn : Button = new Button();
			var upSkin : Bitmap = new Resource.TimingArrow();
			upSkin.scaleX = scale;
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", upSkin);
			btn.setStyle("downSkin", upSkin);
			btn.setStyle("disabledSkin", upSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.label = "";
			btn.width = upSkin.width;
			btn.height = upSkin.height;
			return btn;
		}

		public static function ReadCommentButton() : Button {
			var btn : Button = new Button();
			var upSkin : Bitmap = new Resource.ReadComments();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", upSkin);
			btn.setStyle("downSkin", upSkin);
			btn.setStyle("disabledSkin", upSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.label = "";
			btn.width = upSkin.width;
			btn.height = upSkin.height;
			return btn;
		}

		public static function TimingComboBox() : ComboBox {
			var cb : ComboBox = new ComboBox();
			var upSkin : ScaleBitmap = new ScaleBitmap((new (Resource.TimingComboBox)() as Bitmap).bitmapData, "auto", true);
			upSkin.scale9Grid = new Rectangle(8, 8, 12, 12);
			cb.setStyle("upSkin", upSkin);
			cb.setStyle("overSkin", upSkin);
			cb.setStyle("downSkin", upSkin);
			cb.setStyle("textPadding", 8);
			cb.setStyle("buttonWidth", cb.width - 5);
			cb.textField.setStyle("textFormat", Widget.normalFormat);
			cb.height = 30;
			return cb;
		}

		public static function ArrowButton(scale : int = 1) : Button {
			var btn : Button = new Button();
			var upSkin : Bitmap = new Resource.ArrowUp();
			var overSkin : Bitmap = new Resource.ArrowOver();
			var downSkin : Bitmap = new Resource.ArrowDown();
			upSkin.scaleX = scale;
			overSkin.scaleX = scale;
			downSkin.scaleX = scale;
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", overSkin);
			btn.setStyle("downSkin", downSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = upSkin.width;
			btn.height = upSkin.height;
			btn.label = "";
			return btn;
		}

		public static function UserHomeButton() : Button {
			var btn : Button = new Button();
			var upSkin : Bitmap = new (Resource.UserHomeButtonUp)();
			var overSkin : Bitmap = new (Resource.UserHomeButtonDown)();
			var downSkin : Bitmap = new (Resource.UserHomeButtonOver)();
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", overSkin);
			btn.setStyle("downSkin", downSkin);
			btn.setStyle("disabledSkin", downSkin);
			btn.setStyle("selectedUpSkin", downSkin);
			btn.setStyle("selectedOverSkin", downSkin);
			btn.setStyle("selectedDownSkin", downSkin);
			btn.setStyle("selectedDisabledSkin", downSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = upSkin.width;
			btn.height = upSkin.height;
			btn.label = "";
			return btn;
		}

		public static function UserFollowButton() : Button {
			var btn : Button = new Button();
			var upSkin : Bitmap = new (Resource.UserFollowButtonUp)();
			var overSkin : Bitmap = new (Resource.UserFollowButtonDown)();
			var downSkin : Bitmap = new (Resource.UserFollowButtonOver)();
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", overSkin);
			btn.setStyle("downSkin", downSkin);
			btn.setStyle("disabledSkin", downSkin);
			btn.setStyle("selectedUpSkin", downSkin);
			btn.setStyle("selectedOverSkin", downSkin);
			btn.setStyle("selectedDownSkin", downSkin);
			btn.setStyle("selectedDisabledSkin", downSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = upSkin.width;
			btn.height = upSkin.height;
			btn.label = "";
			return btn;
		}

		public static function UserFansButton() : Button {
			var btn : Button = new Button();
			var upSkin : Bitmap = new (Resource.UserFansButtonUp)();
			var overSkin : Bitmap = new (Resource.UserFansButtonDown)();
			var downSkin : Bitmap = new (Resource.UserFansButtonOver)();
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", overSkin);
			btn.setStyle("downSkin", downSkin);
			btn.setStyle("disabledSkin", downSkin);
			btn.setStyle("selectedUpSkin", downSkin);
			btn.setStyle("selectedOverSkin", downSkin);
			btn.setStyle("selectedDownSkin", downSkin);
			btn.setStyle("selectedDisabledSkin", downSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = upSkin.width;
			btn.height = upSkin.height;
			btn.label = "";
			return btn;
		}

		public static function RefreshButton() : UIButton {
			var btn : Button = new Button();
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			var upSkin : Bitmap = new (Resource.RefreshButtonUpSkin)();
			var overSkin : Bitmap = new (Resource.RefreshButtonOverSkin)();
			var downSkin : Bitmap = new (Resource.RefreshButtonDownSkin)();
			btn.setStyle("upSkin", upSkin);
			btn.setStyle("overSkin", overSkin);
			btn.setStyle("downSkin", downSkin);
			btn.setStyle("selectedUpSkin", downSkin);
			btn.setStyle("selectedOverSkin", downSkin);
			btn.setStyle("selectedDownSkin", downSkin);
			btn.setStyle("focusRectSkin", new Sprite());
			btn.textField.autoSize = TextFieldAutoSize.LEFT;
			btn.width = upSkin.width;
			btn.height = upSkin.height;
			btn.label = "";
			btn.emphasized = false;
			return new UIButton(btn, "刷 新", 4);
		}

		public static function SystemComboBox() : ComboBox {
			var cb : ComboBox = new ComboBox();
			var upSkin : ScaleBitmap = new ScaleBitmap((new (Resource.ComboBoxUpSkin)() as Bitmap).bitmapData, "auto", true);
			upSkin.scale9Grid = new Rectangle(8, 8, 12, 12);
			var overSkin : ScaleBitmap = new ScaleBitmap((new (Resource.ComboBoxOverSkin)() as Bitmap).bitmapData, "auto", true);
			overSkin.scale9Grid = new Rectangle(8, 8, 12, 12);
			cb.setStyle("upSkin", upSkin);
			cb.setStyle("overSkin", overSkin);
			cb.setStyle("downSkin", upSkin);
			return cb;
		}

		public static function SystemCheckBox() : CheckBox {
			var cb : CheckBox = new CheckBox();
			var upSkin : Bitmap = new Bitmap(StaticAssets.CheckBoxSkin());
			var selectedSkin : Bitmap = new Bitmap(StaticAssets.CheckBoxSelected());
			cb.setStyle("upIcon", upSkin);
			cb.setStyle("overIcon", upSkin);
			cb.setStyle("downIcon", upSkin);
			cb.setStyle("selectedUpIcon", selectedSkin);
			cb.setStyle("selectedOverIcon", selectedSkin);
			cb.setStyle("selectedDownIcon", selectedSkin);
			cb.setStyle("focusRectSkin", new Sprite());
			cb.textField.autoSize = TextFieldAutoSize.LEFT;
			cb.setStyle("textFormat", Widget.normalFormat);
			return cb;
		}

		public static function SystemNummericStepper() : NumericStepper {
			var ns : NumericStepper = new NumericStepper();
			ns.setStyle("focusRectSkin", new Sprite());
			ns.textField.textField.autoSize = TextFieldAutoSize.LEFT;
			ns.setStyle("textFormat", Widget.normalFormat);
			return ns;
		}
	}
}