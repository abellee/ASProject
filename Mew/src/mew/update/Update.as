package mew.update {
	import air.update.descriptors.UpdateDescriptor;
	import air.update.events.StatusUpdateEvent;
	import air.update.events.UpdateEvent;
	
	import com.iabel.nativeApplicationUpdater.NativeApplicationUpdater;
	
	import flash.desktop.NativeApplication;
	import flash.events.ProgressEvent;
	
	import system.MewSystem;

	public class Update
	{
		private var updater:NativeApplicationUpdater = new NativeApplicationUpdater();
		private var updatePath:String = "http://mew.iabel.com/MewUpdater.xml";
		public function Update()
		{
			updater.updateURL = updatePath;
			updater.addEventListener(UpdateEvent.INITIALIZED, onUpdateInitializedHandler);
			updater.addEventListener(StatusUpdateEvent.UPDATE_STATUS, showUpdateInfo);
			updater.addEventListener(UpdateEvent.CHECK_FOR_UPDATE, checkForUpdateRun);
			updater.addEventListener(ProgressEvent.PROGRESS, updateDownload_progressHandler);
			updater.addEventListener(UpdateEvent.DOWNLOAD_COMPLETE, updateDownload_completeHandler);
			updater.initialize();
		}
		private function showUpdateInfo(event:StatusUpdateEvent):void
		{
			var xmlns:Namespace = new Namespace(NativeApplication.nativeApplication.applicationDescriptor.namespace());
			var updator:NativeApplicationUpdater = event.target as NativeApplicationUpdater;
			var curVersion:String = NativeApplication.nativeApplication.applicationDescriptor.xmlns::versionNumber;
			if(updator.updateVersion == curVersion){
				if(MewSystem.isManual) MewSystem.show("当前为最新版本!");
				MewSystem.app.noUpdate();
				this.clearSelf();
				return;
			}
			MewSystem.app.openUpdateWindow(Number(updator.updateVersion), updator.updateDescription);
		}
		private function checkForUpdateRun(event:UpdateEvent):void{
			
			event.preventDefault();
			updater.checkForUpdate();
			
		}
		private function onUpdateInitializedHandler(event:UpdateEvent):void{
			
			updater.removeEventListener(UpdateEvent.INITIALIZED, onUpdateInitializedHandler);
			updater.checkNow();
			
		}
		private function updateDownload_progressHandler(event:ProgressEvent):void
		{
			if(MewSystem.app.updateCheckingWindow) MewSystem.app.updateCheckingWindow.showDownloading(event.bytesLoaded / event.bytesTotal);
		}
		private function updateDownload_completeHandler(event:UpdateEvent):void
		{
			if(updater)
			{
				updater.removeEventListener(ProgressEvent.PROGRESS, updateDownload_progressHandler);
				updater.removeEventListener(UpdateEvent.DOWNLOAD_COMPLETE, updateDownload_completeHandler);
			}
			updater.installUpdate();
		}
		public function update():void
		{
			updater.downloadUpdate();
		}
		public function clearSelf():void
		{
			if(updater)
			{
				updater.removeEventListener(UpdateEvent.INITIALIZED, onUpdateInitializedHandler);
				updater.removeEventListener(StatusUpdateEvent.UPDATE_STATUS, showUpdateInfo);
				updater.removeEventListener(UpdateEvent.CHECK_FOR_UPDATE, checkForUpdateRun);
				updater.removeEventListener(ProgressEvent.PROGRESS, updateDownload_progressHandler);
				updater.removeEventListener(UpdateEvent.DOWNLOAD_COMPLETE, updateDownload_completeHandler);
			}
			updater = null;
		}
	}
}