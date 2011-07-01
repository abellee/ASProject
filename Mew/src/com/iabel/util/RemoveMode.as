package com.iabel.util
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;

	public class RemoveMode
	{
		public static const BITMAP:int = 1;
		public static const MOVIECLIP:int = 2;
		public static const ALL:int = 3;
		public static const DEALLOC:int = 4;
		
		public static function getRemoveClass(num:int):Class
		{
			switch(num)
			{
				case BITMAP:
					return Bitmap;
					break;
				case MOVIECLIP:
					return MovieClip
					break;
			}
			return null;
		}
	}
}