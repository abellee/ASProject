package mew.factory {
	import resource.Resource;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;

	public class StaticAssets {
		private static var _DefaultAvatar50 : BitmapData = null;
		private static var _DefaultAvatar180 : BitmapData = null;
		private static var _FemaleIcon : BitmapData = null;
		private static var _MaleIcon : BitmapData = null;
		private static var _DefaultVideo : BitmapData = null;
		private static var _DefaultImage : BitmapData = null;
		private static var _YellowVIcon : BitmapData = null;
		/**
		 * 定时微博发布器资源
		 */
		private static var _TimingPointRed : BitmapData = null;
		private static var _TimingPointGreen : BitmapData = null;
		private static var _TimingPointGray : BitmapData = null;
		private static var _TimeLine : BitmapData = null;
		// public static var DefaultMusic:BitmapData = null;
		// public static var BlueVIcon:BitmapData = null;
		// public static var RedStarIcon:BitmapData = null;
		/**
		 * 关于界面、更新界面的猫脸
		 */
		private static var _MewFace : BitmapData = null;
		/**
		 * 关于界面的MEW字
		 */
		private static var _MewFont : BitmapData = null;
		private static var _BlackButtonSkin : BitmapData = null;
		private static var _BlackButtonOverSkin : BitmapData = null;
		private static var _OrangeButtonSkin : BitmapData = null;
		private static var _OrangeButtonOverSkin : BitmapData = null;
		private static var _CheckBoxSkin : BitmapData = null;
		private static var _CheckBoxSelected : BitmapData = null;
		private static var _ImageFrameSkin : BitmapData = null;
		private static var _CloseButtonSkin : BitmapData = null;
		private static var _CloseButtonOverSkin : BitmapData = null;
		private static var _ComboBoxUpSkin : BitmapData = null;
		private static var _ComboBoxOverSkin : BitmapData = null;
		private static var _IndexButtonUp : BitmapData = null;
		private static var _IndexButtonOver : BitmapData = null;
		private static var _IndexButtonDown : BitmapData = null;
		private static var _AtButtonUp : BitmapData = null;
		private static var _AtButtonOver : BitmapData = null;
		private static var _AtButtonDown : BitmapData = null;
		private static var _CommentButtonUp : BitmapData = null;
		private static var _CommentButtonOver : BitmapData = null;
		private static var _CommentButtonDown : BitmapData = null;
		private static var _DMButtonUp : BitmapData = null;
		private static var _DMButtonOver : BitmapData = null;
		private static var _DMButtonDown : BitmapData = null;
		private static var _CollectButtonUp : BitmapData = null;
		private static var _CollectButtonOver : BitmapData = null;
		private static var _CollectButtonDown : BitmapData = null;
		private static var _FansButtonUp : BitmapData = null;
		private static var _FansButtonOver : BitmapData = null;
		private static var _FansButtonDown : BitmapData = null;
		private static var _FollowButtonUp : BitmapData = null;
		private static var _FollowButtonOver : BitmapData = null;
		private static var _FollowButtonDown : BitmapData = null;
		private static var _SystemButtonUp : BitmapData = null;
		private static var _SystemButtonOver : BitmapData = null;
		private static var _SystemButtonDown : BitmapData = null;
		private static var _SearchButtonUp : BitmapData = null;
		private static var _SearchButtonOver : BitmapData = null;
		private static var _SearchButtonDown : BitmapData = null;
		private static var _MewButtonUp : BitmapData = null;
		private static var _MewButtonOver : BitmapData = null;
		private static var _MewButtonDown : BitmapData = null;
		private static var _PublishButtonUp : BitmapData = null;
		private static var _PublishButtonOver : BitmapData = null;
		private static var _PublishButtonDown : BitmapData = null;
		private static var _UnreadSkin : BitmapData = null;

		public function StaticAssets() {
		}
		
		public static function FemaleIcon():BitmapData
		{
			if(!_FemaleIcon){
				var bitmap:Bitmap = new (Resource.FemaleSkin)();
				_FemaleIcon = bitmap.bitmapData;
			}
			return _FemaleIcon;
		}
		
		public static function MaleIcon():BitmapData
		{
			if(!_MaleIcon){
				var bitmap:Bitmap = new (Resource.MaleSkin)();
				_FemaleIcon = bitmap.bitmapData;
			}
			return _FemaleIcon;
		}

		public static function UnreadSkin() : BitmapData {
			if (!_UnreadSkin) {
				var bitmap : Bitmap = new (Resource.UnreadSkin)();
				_UnreadSkin = bitmap.bitmapData;
			}
			return _UnreadSkin;
		}

		public static function PublishButtonUp() : BitmapData {
			if (!_PublishButtonUp) {
				var bitmap : Bitmap = new (Resource.IndexMouseUpSkin)();
				_PublishButtonUp = bitmap.bitmapData;
			}
			return _PublishButtonUp;
		}

		public static function PublishButtonOver() : BitmapData {
			if (!_PublishButtonOver) {
				var bitmap : Bitmap = new (Resource.IndexMouseOverSkin)();
				_PublishButtonOver = bitmap.bitmapData;
			}
			return _PublishButtonOver;
		}

		public static function PublishButtonDown() : BitmapData {
			if (!_PublishButtonDown) {
				var bitmap : Bitmap = new (Resource.IndexMouseDownSkin)();
				_PublishButtonDown = bitmap.bitmapData;
			}
			return _PublishButtonDown;
		}

		public static function MewButtonUp() : BitmapData {
			if (!_MewButtonUp) {
				var bitmap : Bitmap = new (Resource.MewMouseUpSkin)();
				_MewButtonUp = bitmap.bitmapData;
			}
			return _MewButtonUp;
		}

		public static function MewButtonOver() : BitmapData {
			if (!_MewButtonOver) {
				var bitmap : Bitmap = new (Resource.MewMouseOverSkin)();
				_MewButtonOver = bitmap.bitmapData;
			}
			return _MewButtonOver;
		}

		public static function MewButtonDown() : BitmapData {
			if (!_MewButtonDown) {
				var bitmap : Bitmap = new (Resource.MewMouseDownSkin)();
				_MewButtonDown = bitmap.bitmapData;
			}
			return _MewButtonDown;
		}

		public static function SearchButtonUp() : BitmapData {
			if (!_SearchButtonUp) {
				var bitmap : Bitmap = new (Resource.SearchMouseUpSkin)();
				_SearchButtonUp = bitmap.bitmapData;
			}
			return _SearchButtonUp;
		}

		public static function SearchButtonOver() : BitmapData {
			if (!_SearchButtonOver) {
				var bitmap : Bitmap = new (Resource.SearchMouseOverSkin)();
				_SearchButtonOver = bitmap.bitmapData;
			}
			return _SearchButtonOver;
		}

		public static function SearchButtonDown() : BitmapData {
			if (!_SearchButtonDown) {
				var bitmap : Bitmap = new (Resource.SearchMouseDownSkin)();
				_SearchButtonDown = bitmap.bitmapData;
			}
			return _SearchButtonDown;
		}

		public static function SystemButtonUp() : BitmapData {
			if (!_SystemButtonUp) {
				var bitmap : Bitmap = new (Resource.SystemMouseUpSkin)();
				_SystemButtonUp = bitmap.bitmapData;
			}
			return _SystemButtonUp;
		}

		public static function SystemButtonOver() : BitmapData {
			if (!_SystemButtonOver) {
				var bitmap : Bitmap = new (Resource.SystemMouseOverSkin)();
				_SystemButtonOver = bitmap.bitmapData;
			}
			return _SystemButtonOver;
		}

		public static function SystemButtonDown() : BitmapData {
			if (!_SystemButtonDown) {
				var bitmap : Bitmap = new (Resource.SystemMouseDownSkin)();
				_SystemButtonDown = bitmap.bitmapData;
			}
			return _SystemButtonDown;
		}

		public static function FollowButtonUp() : BitmapData {
			if (!_FollowButtonUp) {
				var bitmap : Bitmap = new (Resource.FollowMouseUpSkin)();
				_FollowButtonUp = bitmap.bitmapData;
			}
			return _FollowButtonUp;
		}

		public static function FollowButtonOver() : BitmapData {
			if (!_FollowButtonOver) {
				var bitmap : Bitmap = new (Resource.FollowMouseOverSkin)();
				_FollowButtonOver = bitmap.bitmapData;
			}
			return _FollowButtonOver;
		}

		public static function FollowButtonDown() : BitmapData {
			if (!_FollowButtonDown) {
				var bitmap : Bitmap = new (Resource.FollowMouseDownSkin)();
				_FollowButtonDown = bitmap.bitmapData;
			}
			return _FollowButtonDown;
		}

		public static function FansButtonUp() : BitmapData {
			if (!_FansButtonUp) {
				var bitmap : Bitmap = new (Resource.FansMouseUpSkin)();
				_FansButtonUp = bitmap.bitmapData;
			}
			return _FansButtonUp;
		}

		public static function FansButtonOver() : BitmapData {
			if (!_FansButtonOver) {
				var bitmap : Bitmap = new (Resource.FansMouseOverSkin)();
				_FansButtonOver = bitmap.bitmapData;
			}
			return _FansButtonOver;
		}

		public static function FansButtonDown() : BitmapData {
			if (!_FansButtonDown) {
				var bitmap : Bitmap = new (Resource.FansMouseDownSkin)();
				_FansButtonDown = bitmap.bitmapData;
			}
			return _FansButtonDown;
		}

		public static function CollectButtonUp() : BitmapData {
			if (!_CollectButtonUp) {
				var bitmap : Bitmap = new (Resource.CollectMouseUpSkin)();
				_CollectButtonUp = bitmap.bitmapData;
			}
			return _CollectButtonUp;
		}

		public static function CollectButtonOver() : BitmapData {
			if (!_CollectButtonOver) {
				var bitmap : Bitmap = new (Resource.CollectMouseOverSkin)();
				_CollectButtonOver = bitmap.bitmapData;
			}
			return _CollectButtonOver;
		}

		public static function CollectButtonDown() : BitmapData {
			if (!_CollectButtonDown) {
				var bitmap : Bitmap = new (Resource.CollectMouseDownSkin)();
				_CollectButtonDown = bitmap.bitmapData;
			}
			return _CollectButtonDown;
		}

		public static function DMButtonUp() : BitmapData {
			if (!_DMButtonUp) {
				var bitmap : Bitmap = new (Resource.DMMouseUpSkin)();
				_DMButtonUp = bitmap.bitmapData;
			}
			return _DMButtonUp;
		}

		public static function DMButtonOver() : BitmapData {
			if (!_DMButtonOver) {
				var bitmap : Bitmap = new (Resource.DMMouseOverSkin)();
				_DMButtonOver = bitmap.bitmapData;
			}
			return _DMButtonOver;
		}

		public static function DMButtonDown() : BitmapData {
			if (!_DMButtonDown) {
				var bitmap : Bitmap = new (Resource.DMMouseDownSkin)();
				_DMButtonDown = bitmap.bitmapData;
			}
			return _DMButtonDown;
		}

		public static function CommentButtonUp() : BitmapData {
			if (!_CommentButtonUp) {
				var bitmap : Bitmap = new (Resource.CommentMouseUpSkin)();
				_CommentButtonUp = bitmap.bitmapData;
			}
			return _CommentButtonUp;
		}

		public static function CommentButtonOver() : BitmapData {
			if (!_CommentButtonOver) {
				var bitmap : Bitmap = new (Resource.CommentMouseOverSkin)();
				_CommentButtonOver = bitmap.bitmapData;
			}
			return _CommentButtonOver;
		}

		public static function CommentButtonDown() : BitmapData {
			if (!_CommentButtonDown) {
				var bitmap : Bitmap = new (Resource.CommentMouseDownSkin)();
				_CommentButtonDown = bitmap.bitmapData;
			}
			return _CommentButtonDown;
		}

		public static function AtButtonUp() : BitmapData {
			if (!_AtButtonUp) {
				var bitmap : Bitmap = new (Resource.AtMouseUpSkin)();
				_AtButtonUp = bitmap.bitmapData;
			}
			return _AtButtonUp;
		}

		public static function AtButtonOver() : BitmapData {
			if (!_AtButtonOver) {
				var bitmap : Bitmap = new (Resource.AtMouseOverSkin)();
				_AtButtonOver = bitmap.bitmapData;
			}
			return _AtButtonOver;
		}

		public static function AtButtonDown() : BitmapData {
			if (!_AtButtonDown) {
				var bitmap : Bitmap = new (Resource.AtMouseDownSkin)();
				_AtButtonDown = bitmap.bitmapData;
			}
			return _AtButtonDown;
		}

		public static function IndexButtonUp() : BitmapData {
			if (!_IndexButtonUp) {
				var bitmap : Bitmap = new (Resource.HomeMouseUpSkin)();
				_IndexButtonUp = bitmap.bitmapData;
			}
			return _IndexButtonUp;
		}

		public static function IndexButtonOver() : BitmapData {
			if (!_IndexButtonOver) {
				var bitmap : Bitmap = new (Resource.HomeMouseOverSkin)();
				_IndexButtonOver = bitmap.bitmapData;
			}
			return _IndexButtonOver;
		}

		public static function IndexButtonDown() : BitmapData {
			if (!_IndexButtonDown) {
				var bitmap : Bitmap = new (Resource.HomeMouseDownSkin)();
				_IndexButtonDown = bitmap.bitmapData;
			}
			return _IndexButtonDown;
		}

		/**
		 * 黑色风格按钮的正常状态皮肤
		 */
		public static function BlackButtonSkin() : BitmapData {
			if (!_BlackButtonSkin) {
				var bitmap : Bitmap = new (Resource.ButtonSkin)();
				_BlackButtonSkin = bitmap.bitmapData;
			}
			return _BlackButtonSkin;
		}

		/**
		 * 黑色风格按钮的鼠标经过状态皮肤
		 */
		public static function BlackButtonOverSkin() : BitmapData {
			if (!_BlackButtonOverSkin) {
				var bitmap : Bitmap = new (Resource.ButtonOverSkin)();
				_BlackButtonOverSkin = bitmap.bitmapData;
			}
			return _BlackButtonOverSkin;
		}

		/**
		 * Mew 50尺寸
		 */
		public static function DefaultAvatar50() : BitmapData {
			if (!_DefaultAvatar50) {
				var bitmap : Bitmap = new (Resource.MewDefault50)();
				_DefaultAvatar50 = bitmap.bitmapData;
			}
			return _DefaultAvatar50;
		}

		/**
		 * Mew 180尺寸
		 */
		public static function DefaultAvatar180() : BitmapData {
			if (!_DefaultAvatar180) {
				var bitmap : Bitmap = new (Resource.MewDefault180)();
				_DefaultAvatar180 = bitmap.bitmapData;
			}
			return _DefaultAvatar180;
		}

		/**
		 * 橙色风格按钮正常状态皮肤
		 */
		public static function OrangeButtonSkin() : BitmapData {
			if (!_OrangeButtonSkin) {
				var bitmap : Bitmap = new (Resource.OrangeButtonSkin)();
				_OrangeButtonSkin = bitmap.bitmapData;
			}
			return _OrangeButtonSkin;
		}

		/**
		 * 橙色风格按钮鼠标经过状态皮肤
		 */
		public static function OrangeButtonOverSkin() : BitmapData {
			if (!_OrangeButtonOverSkin) {
				var bitmap : Bitmap = new (Resource.OrangeOverSkin)();
				_OrangeButtonOverSkin = bitmap.bitmapData;
			}
			return _OrangeButtonOverSkin;
		}

		/**
		 * 复选框背景皮肤
		 */
		public static function CheckBoxSkin() : BitmapData {
			if (!_CheckBoxSkin) {
				var bitmap : Bitmap = new (Resource.CheckBoxSkin)();
				_CheckBoxSkin = bitmap.bitmapData;
			}
			return _CheckBoxSkin;
		}

		/**
		 * 复选框勾皮肤
		 */
		public static function CheckBoxSelected() : BitmapData {
			if (!_CheckBoxSelected) {
				var bitmap : Bitmap = new (Resource.CheckBoxSelected)();
				_CheckBoxSelected = bitmap.bitmapData;
			}
			return _CheckBoxSelected;
		}

		/**
		 * 图片背景框
		 */
		public static function ImageFrameSkin() : BitmapData {
			if (!_ImageFrameSkin) {
				var bitmap : Bitmap = new (Resource.ImageBackgroundSkin)();
				_ImageFrameSkin = bitmap.bitmapData;
			}
			return _ImageFrameSkin;
		}

		/**
		 * 关闭按钮普通状态皮肤
		 */
		public static function CloseButtonSkin() : BitmapData {
			if (!_CloseButtonSkin) {
				var bitmap : Bitmap = new (Resource.CloseButtonSkin)();
				_CloseButtonSkin = bitmap.bitmapData;
			}
			return _CloseButtonSkin;
		}

		/**
		 * 关闭按钮鼠标经过状态
		 */
		public static function CloseButtonOverSkin() : BitmapData {
			if (!_CloseButtonOverSkin) {
				var bitmap : Bitmap = new (Resource.CloseButtonOverSkin)();
				_CloseButtonOverSkin = bitmap.bitmapData;
			}
			return _CloseButtonOverSkin;
		}

		/**
		 * 认证图标
		 */
		public static function YellowVIcon() : BitmapData {
			if (!_YellowVIcon) {
				var bitmap:Bitmap = new (Resource.VSkin)();
				_YellowVIcon = bitmap.bitmapData;
			}
			return _YellowVIcon;
		}

		/**
		 * mew 脸
		 */
		public static function MewFace() : BitmapData {
			if (!_MewFace) {
				return new BitmapData(10, 10);
			}
			return _MewFace;
		}

		/**
		 * mew 字样
		 */
		public static function MewFont() : BitmapData {
			if (!_MewFont) {
				return new BitmapData(10, 10);
			}
			return _MewFont;
		}

		/**
		 * 默认视频图片
		 */
		public static function DefaultVideo() : BitmapData {
			if (!_DefaultVideo) {
				var bitmap : Bitmap = new (Resource.VideoPlayButton)();
				_DefaultVideo = bitmap.bitmapData;
			}
			return _DefaultVideo;
		}

		/**
		 * combobox 普通状态皮肤
		 */
		public static function ComboBoxUpSkin() : BitmapData {
			if (!_ComboBoxUpSkin) {
				var bitmap : Bitmap = new (Resource.ComboBoxUpSkin)();
				_ComboBoxUpSkin = bitmap.bitmapData;
			}
			return _ComboBoxUpSkin;
		}

		/**
		 * combobox 鼠标经过状态皮肤
		 */
		public static function ComboBoxOverSkin() : BitmapData {
			if (!_ComboBoxOverSkin) {
				var bitmap : Bitmap = new (Resource.ComboBoxOverSkin)();
				_ComboBoxOverSkin = bitmap.bitmapData;
			}
			return _ComboBoxOverSkin;
		}
	}
}