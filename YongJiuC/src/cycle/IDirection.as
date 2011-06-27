package cycle
{
	import flash.display.MovieClip;

	public interface IDirection
	{
		function addComponents(dir:uint, list:Object):void;
		function replaceComponent(name:String, mc:MovieClip):void;
	}
}