package mew.modules {
	import mew.windows.ScreenShotMasker;

	import system.MewSystem;
	import system.SystemDetection;

	import com.adobe.images.JPGEncoder;
	import com.plter.air.windows.screen.ScreenCapturer;
	import com.plter.air.windows.screen.ScreenCapturerEvent;

	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.display.BitmapData;
	import flash.events.NativeProcessExitEvent;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	/**
	 * @author Abel Lee
	 */
	public class ScreenShotor {
		private var nativeStartUp : NativeProcessStartupInfo = new NativeProcessStartupInfo();
		private var nativeProcess : NativeProcess = new NativeProcess();
		private var masker : ScreenShotMasker = null;
		private var capture : ScreenCapturer = null;
		private var tempRect : Rectangle = null;
		public var parent : IScreenShot = null;

		public function ScreenShotor() {
			super();
		}

		public function screenshot() : void {
			var arg : Vector.<String> = new Vector.<String>();
			if (SystemDetection.isMac()) {
				nativeStartUp.executable = new File("/usr/sbin/screencapture");
				arg.push("-s");
				arg.push("-c");
				nativeStartUp.arguments = arg;
				nativeProcess.addEventListener(NativeProcessExitEvent.EXIT, showScreenShot);
				nativeProcess.start(nativeStartUp);
			} else if (SystemDetection.isWindows()) {
				if (masker) {
					masker.close();
					masker = null;
				}
				masker = new ScreenShotMasker(MewSystem.getNativeWindowInitOption());
				masker.screenShotor = this;
				masker.activate();
			}
		}

		public function shotForWindow(rect : Rectangle) : void {
			masker.close();
			if(!rect) return;
			tempRect = rect;
			if (!capture) capture = new ScreenCapturer();
			capture.addEventListener(ScreenCapturerEvent.SUCCESS, screenCaptureSuccess);
			capture.startCapture();
		}

		private function screenCaptureSuccess(event : ScreenCapturerEvent) : void {
			capture.removeEventListener(ScreenCapturerEvent.SUCCESS, screenCaptureSuccess);
			var bd : BitmapData = new BitmapData(tempRect.width, tempRect.height);
			bd.copyPixels(event.bitmapData, tempRect, new Point(0, 0));
			if (bd) processBitmapFromClipboard(bd);
		}

		private function showScreenShot(event : NativeProcessExitEvent) : void {
			nativeProcess.removeEventListener(NativeProcessExitEvent.EXIT, showScreenShot);
			var bd : BitmapData = Clipboard.generalClipboard.getData(ClipboardFormats.BITMAP_FORMAT) as BitmapData;
			if (bd) processBitmapFromClipboard(bd);
		}

		private function processBitmapFromClipboard(bd : BitmapData) : void {
			var jpgEncoder : JPGEncoder = new JPGEncoder(80);
			var byteArray : ByteArray = jpgEncoder.encode(bd);
			if (parent) parent.screenComplete(byteArray);
		}
		
		public function destroy():void
		{
			nativeProcess.removeEventListener(NativeProcessExitEvent.EXIT, showScreenShot);
			capture.removeEventListener(ScreenCapturerEvent.SUCCESS, screenCaptureSuccess);
			nativeStartUp = null;
			nativeProcess = null;
			masker = null;
			capture = null;
			tempRect = null;
			parent = null;
		}
	}
}
