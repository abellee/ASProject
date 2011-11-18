package cycle
{
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public interface IDirection
	{
		function addComponents(dir:uint, list:Object):void;
		function replaceComponent(name:String, mc:Sprite):void;
		function highlightMC(param1:Sprite) : void;
		function removeHightlight() : void;
		function removeHightlightSprite(param1:Sprite) : void;
		function showColorHad(param1:Sprite) : void;
	}
}