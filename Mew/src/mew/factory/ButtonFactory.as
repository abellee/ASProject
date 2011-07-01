package mew.factory
{
	import fl.controls.Button;

	public class ButtonFactory
	{
		public function ButtonFactory()
		{
		}
		
		public static function RepostButton():Button
		{
			
			return new Button();
		}
		
		public static function DeleteButton():Button
		{
			
			return new Button();
		}
		
		public static function CollectionButton():Button
		{
			
			return new Button();
		}
		
		public static function CommentButton():Button
		{
			
			return new Button();
		}
		
		public static function PlayButton():Button
		{
			
			return new Button();
		}
	}
}