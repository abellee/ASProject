package com.iabel.command 
{
	/**
	 * ...
	 * @author AbelLee
	 */
	public class Command 
	{
		private var _commandType:String;
		private var _data:Object;
		public function Command(ct:String = null, d:Object = null) 
		{
			_commandType = ct;
			_data = d;
		}
		
		public function get commandType():String 
		{
			return _commandType;
		}
		
		public function set commandType(value:String):void 
		{
			_commandType = value;
		}
		
		public function get data():Object 
		{
			return _data;
		}
		
		public function set data(value:Object):void 
		{
			_data = value;
		}
	}

}