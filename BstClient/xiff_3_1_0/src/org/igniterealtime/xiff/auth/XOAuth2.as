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
package org.igniterealtime.xiff.auth
{
	import com.hurlant.util.Base64;
	import flash.utils.Dictionary;

	import org.igniterealtime.xiff.core.IXMPPConnection;

	/**
	 * This class provides SASL authentication using the X-OAUTH2 mechanism.
	 *
	 * @see http://tools.ietf.org/html/rfc3920#section-6
	 * @see https://developers.google.com/accounts/docs/OAuth2
	 * @see https://developers.google.com/cloud-print/docs/rawxmpp
	 */
	public class XOAuth2 extends SASLAuth implements ISASLAuth
	{
		public static const MECHANISM:String = "X-OAUTH2";
		public static const NS:String = "urn:ietf:params:xml:ns:xmpp-sasl";

		/**
		 * Creates a OAuth v2 authentication object.
		 *
		 * @param	connection A reference to the XMPPConnection instance in use.
		 */
		public function XOAuth2( connection:IXMPPConnection )
		{
			this.connection = connection;

			req.setNamespace( XOAuth2.NS );
			req.@mechanism = XOAuth2.MECHANISM;

			response.setNamespace( XOAuth2.NS );

			stage = 0;
		}

		/**
		 * Called when a challenge to this authentication is received.
		 *
		 * @param	stage The current stage in the authentication process.
		 * @param	challenge The XML of the actual authentication challenge.
		 *
		 * @return The XML response to the challenge.
		 */
		override public function handleChallenge( stage:int, challenge:XML ):XML
		{
			return new XML;
		}

		/**
		 * Called when a response to this authentication is received.
		 *
		 * @param	stage The current stage in the authentication process.
		 * @param	response The XML of the actual authentication response.
		 *
		 * @return An object specifying the current state of the authentication.
		 */
		override public function handleResponse( stage:int, response:XML ):Object
		{
			var success:Boolean = response.localName() == SASLAuth.RESPONSE_SUCCESS;
			return {
				authComplete: true,
				authSuccess: success,
				authStage: stage++
			};
		}
	}
}
