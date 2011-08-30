package resource
{
	public class Resource
	{
		/**
		 * BitmapData
		 */
		[Embed(source="res.swf", symbol="LoadingBackground")]
		public static var LoadingBackground:Class;
		
		[Embed(source="loadingMotion.swf", mimeType="application/octet-stream")]
		public static var LoadingMotion:Class;
		
		[Embed(source="loading.swf", mimeType="application/octet-stream")]
		public static var CycleLoading:Class;
	}
}