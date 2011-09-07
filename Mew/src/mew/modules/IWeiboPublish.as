package mew.modules {
	/**
	 * @author Abel Lee
	 */
	public interface IWeiboPublish extends IDisplay {
		function updateSuccess():void;
		function updateFailed():void;
	}
}
