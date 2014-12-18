/*
 * Copyright (C) 2003-2012 Igniterealtime Community Contributors
 *
 *     Daniel Henninger
 *     Derrick Grigg <dgrigg@rogers.com>
 *     Juga Paazmaya <olavic@gmail.com>
 *     Nick Velloff <nick.velloff@gmail.com>
 *     Sean Treadway <seant@oncotype.dk>
 *     Sean Voisen <sean@voisen.org>
 *     Mark Walters <mark@yourpalmark.com>
 *     Michael McCarthy <mikeycmccarthy@gmail.com>
 *
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.igniterealtime.xiff.data.sharedgroups
{
	
	
	import org.igniterealtime.xiff.data.Extension;
	import org.igniterealtime.xiff.data.IExtension;
	
	/**
	 * Similar idea to XEP-0140 (http://xmpp.org/extensions/xep-0140.html) which was
	 * retracted in favor of XEP-0144 (http://xmpp.org/extensions/xep-0144.html).
	 *
	 * @see http://xmpp.org/extensions/xep-0144.html
	 * @see http://xmpp.org/extensions/xep-0140.html
	 */
	public class SharedGroupsExtension extends Extension implements IExtension
	{
		public static const NS:String = "http://www.jivesoftware.org/protocol/sharedgroup";
		public static const ELEMENT_NAME:String = "sharedgroup";
		
		/**
		 *
		 * @param	parent (Optional) The containing XML for this extension
		 */
		public function SharedGroupsExtension( parent:XML = null )
		{
			super(parent);
		}
		
		public function getNS():String
		{
			return SharedGroupsExtension.NS;
		}
		
		public function getElementName():String
		{
			return SharedGroupsExtension.ELEMENT_NAME;
		}
		
	}
}
