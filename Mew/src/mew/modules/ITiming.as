package mew.modules {
	import mew.data.TimingWeiboVariable;
	/**
	 * @author abellee
	 */
	public interface ITiming {
		function timingWeiboData(data:Vector.<TimingWeiboVariable>):void;
		function showLightAlert(str:String):void;
	}
}
