package com.sina.microblog.data
{
	/**
	 * MicroBlogUsersRelationship是一个数据封装类(Value Object)，用于返回两个用户之间的关系
	 */ 
	public class MicroBlogUsersRelationship
	{
		/**
		 * 查询的源用户
		 */
		public var source:MicroBlogRelationshipDescriptor;
		/**
		 * 查询的目标用户
		 */
		public var target:MicroBlogRelationshipDescriptor;
		public function MicroBlogUsersRelationship()
		{
			
		}
		public function init(relationship:XML):void
		{
			source = new MicroBlogRelationshipDescriptor();
			source.init(relationship.source[0]);
			target = new MicroBlogRelationshipDescriptor();
			target.init(relationship.target[0]);
		}
	}
}