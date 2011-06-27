package com.iabel.factory
{
	import com.iabel.ui.AButton;
	
	import fl.controls.Button;
	import fl.controls.Slider;
	
	import resource.UIResource;

	public class ButtonFactory
	{
		public function ButtonFactory()
		{
		}
		public static function RandomPlayButton():AButton{
			
			var btn:AButton = new AButton(UIResource.RandomPlayUp, UIResource.RandomRepeatOverAndDown, UIResource.RandomRepeatOverAndDown, UIResource.RandomRepeatOverAndDown);
			btn.width = 22;
			btn.height = 16;
			btn.toggle = true;
			
			return btn;
			
		}
		public static function SinglePlayButton():AButton{
			
			var btn:AButton = new AButton(UIResource.SingleRepeatUp, UIResource.SinglePlayOverAndDown, UIResource.SinglePlayOverAndDown, UIResource.SinglePlayOverAndDown);
			btn.width = 22;
			btn.height = 16;
			btn.toggle = true;
			
			return btn;
			
		}
		public static function AllRepeatButton():AButton{
			
			var btn:AButton = new AButton(UIResource.AllRepeatUp, UIResource.AllRepeatOverAndDown, UIResource.AllRepeatOverAndDown, UIResource.AllRepeatOverAndDown);
			btn.width = 22;
			btn.height = 16;
			btn.toggle = true;
			
			return btn;
			
		}
		public static function DownloadButton():AButton{
			
			var btn:AButton = new AButton(UIResource.Download, UIResource.Download, UIResource.Download, UIResource.Download);
			btn.width = 9;
			btn.height = 11;
			
			return btn;
			
		}
		public static function SimilarSongButton():AButton{
			
			var btn:AButton = new AButton(UIResource.SimilarSong, UIResource.SimilarSong, UIResource.SimilarSong, UIResource.SimilarSong);
			btn.width = 6;
			btn.height = 9;
			
			return btn;
			
		}
		public static function PlayButton():AButton{
			
			var btn:AButton = new AButton(UIResource.PlayBtnUp, UIResource.PlayOverAndDown, UIResource.PlayOverAndDown, UIResource.PlayOverAndDown);
			btn.width = 45;
			btn.height = 43;
			
			return btn;
			
		}
		public static function PauseButton():AButton{
			
			var btn:AButton = new AButton(UIResource.PauseUp, UIResource.PauseOverAndDown, UIResource.PauseOverAndDown, UIResource.PauseOverAndDown);
			btn.width = 45;
			btn.height = 43;
			
			return btn;
			
		}
		public static function SoundTransformButton():AButton{
			
			var btn:AButton = new AButton(UIResource.SoundtransformBtn, UIResource.SoundtransformBtn, UIResource.SoundtransformBtn, UIResource.SoundtransformBtn);
			btn.width = 12;
			btn.height = 12;
			
			return btn;
			
		}
		public static function PreviouseButton():AButton{
			
			var btn:AButton = new AButton(UIResource.PreviouseUp, UIResource.PreviouseUpAndDown, UIResource.PreviouseUpAndDown, UIResource.PreviouseUpAndDown);
			btn.width = 30;
			btn.height = 29;
			
			return btn;
			
		}
		public static function NextButton():AButton{
			
			var btn:AButton = new AButton(UIResource.NextUp, UIResource.NextUpAndDown, UIResource.NextUpAndDown, UIResource.NextUpAndDown);
			btn.width = 30;
			btn.height = 29;
			
			return btn;
			
		}
		public static function QuietButton():AButton{
			
			var btn:AButton = new AButton(UIResource.Quiet, UIResource.Unquiet, UIResource.Unquiet, UIResource.Unquiet);
			btn.width = 10;
			btn.height = 8;
			
			return btn;
			
		}
		public static function LinkButton():AButton{
			
			var btn:AButton = new AButton(UIResource.Link, UIResource.Link, UIResource.Link, UIResource.Link);
			btn.width = 11;
			btn.height = 7;
			
			return btn;
			
		}
		public static function DownloadBackground():AButton{
			
			var btn:AButton = new AButton(UIResource.DownloadBackground, UIResource.DownloadBackground, UIResource.DownloadBackground, UIResource.DownloadBackground);
			btn.width = 458;
			btn.height = 6;
			
			return btn;
			
		}
		public static function LoadingBar():AButton{
			
			var btn:AButton = new AButton(UIResource.DownloadPercent, UIResource.DownloadPercent, UIResource.DownloadPercent, UIResource.DownloadPercent);
			btn.width = 458;
			btn.height = 4;
			
			return btn;
			
		}
		public static function PlayingBar():AButton{
			
			var btn:AButton = new AButton(UIResource.PlayPercent, UIResource.PlayPercent, UIResource.PlayPercent, UIResource.PlayPercent);
			btn.width = 458;
			btn.height = 4;
			
			return btn;
			
		}
		public static function SoundController():Slider{
			
			var sc:Slider = new Slider();
			sc.setStyle("thumbUpSkin", UIResource.SoundtransformBtn);
			sc.setStyle("thumbOverSkin", UIResource.SoundtransformBtn);
			sc.setStyle("thumbDownSkin", UIResource.SoundtransformBtn);
			sc.setStyle("thumbDisabledSkin", UIResource.SoundtransformBtn);
			
			sc.liveDragging = true;
			
			return sc;
			
		}
	}
}