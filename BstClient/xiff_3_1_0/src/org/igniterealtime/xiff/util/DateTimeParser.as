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
package org.igniterealtime.xiff.util
{

	/**
	 * A set of static functions to parse the time and date values.
	 * All date related methods are the UTC versions.
	 *
	 * <p>Also methods for handling legacy format are available</p>
	 *
	 * @see http://xmpp.org/extensions/xep-0082.html
	 * @see http://xmpp.org/extensions/xep-0090.html
	 */
	public class DateTimeParser
	{
		/**
		 * Convert a Date object to a string, <code>CCYY-MM-DD</code>
		 * @param	date
		 * @return <code>CCYY-MM-DD</code>
		 */
		public static function date2string(date:Date):String
		{
			var value:String = date.getUTCFullYear() + "-";
			value += (date.getUTCMonth() < 9 ? "0" : "") + (date.getUTCMonth() + 1) + "-";
			value += (date.getUTCDate() < 10 ? "0" : "") + date.getUTCDate();
			return value;
		}
		
		/**
		 * Convert a Date object to a string, <code>CCYYMMDD</code>, using UTC timezone.
		 * @param	date
		 * @return <code>CCYYMMDD</code>
		 */
		public static function date2legacyString(date:Date):String
		{
			var value:String = date.getUTCFullYear().toString();
			value += (date.getUTCMonth() < 9 ? "0" : "") + (date.getUTCMonth() + 1);
			value += (date.getUTCDate() < 10 ? "0" : "") + date.getUTCDate();
			return value;
		}
		
		/**
		 * Convert a string <code>CCYY-MM-DD</code> to a date object
		 * @param	stamp
		 * @return Date object
		 */
		public static function string2date(stamp:String):Date
		{
			var date:Date = new Date();
			date.setUTCFullYear(stamp.substr(0, 4), parseInt(stamp.substr(5, 2)) - 1, stamp.substr(8, 2));
			date.setUTCMinutes(0, 0, 0);
			return date;
		}
		
		/**
		 * Convert a lecagy string <code>CCYYMMDD</code> to a Date object.
		 *
		 * @param	stamp
		 * @return Date object
		 */
		public static function legacyString2date(stamp:String):Date
		{
			var date:Date = new Date();
			date.setUTCFullYear(stamp.substr(0, 4), parseInt(stamp.substr(4, 2)) - 1, stamp.substr(6, 2));
			date.setUTCMinutes(0, 0, 0);
			return date;
		}
		
		/**
		 * Convert a Date object to a string <code>hh:mm:ss[.sss][TZD]</code>
		 * @param	time
		 * @param	ms	Include milliseconds in the resulting string
		 * @return <code>hh:mm:ss[.sss][TZD]</code>
		 */
		public static function time2string(time:Date, ms:Boolean = false):String
		{
			var value:String = (time.getUTCHours() < 10 ? "0" : "") + time.getUTCHours() + ":";
			value += (time.getUTCMinutes() < 10 ? "0" : "") + time.getUTCMinutes() + ":";
			value += (time.getUTCSeconds() < 10 ? "0" : "") + time.getUTCSeconds();
			if (ms)
			{
				value += "." + (time.getUTCMilliseconds() < 10 ? "0" : "")
					+ (time.getUTCMilliseconds() < 100 ? "0" : "") + time.getUTCMilliseconds();
			}
			return value;
		}
		
		/**
		 * Convert a string <code>hh:mm:ss[.sss][TZD]</code> to a Date object
		 * @param	stamp
		 * @return Date object
		 */
		public static function string2time(stamp:String):Date
		{
			var date:Date = new Date();
			date.setUTCHours(stamp.substr(0, 2), stamp.substr(3, 2), stamp.substr(6, 2), 0);
			if (stamp.length > 10)
			{
				date.setUTCMilliseconds(parseInt(stamp.substr(10, 3)));
			}
			return date;
		}
		
		/**
		 * Convert a Date object to a string <code>CCYY-MM-DDThh:mm:ss[.sss]TZD</code>
		 * @param	dateTime
		 * @param	ms	Include milliseconds in the resulting string
		 * @return <code>CCYY-MM-DDThh:mm:ss[.sss]TZD</code>
		 */
		public static function dateTime2string(dateTime:Date, ms:Boolean = false):String
		{
			var value:String = date2string(dateTime) + "T";
			value += time2string(dateTime, ms);
			value += "Z"; // Always UTC
			return value;
		}
		
		/**
		 * Convert a string <code>CCYY-MM-DDThh:mm:ss[.sss]TZD</code> to a Date object
		 * @param	stamp
		 * @return Date object
		 * @see http://xmpp.org/extensions/xep-0082.html
		 */
		public static function string2dateTime(stamp:String):Date
		{
			var date:Date = string2date(stamp.substring(0, stamp.indexOf("T")));
			var time:Date = string2time(stamp.substring(stamp.indexOf("T") + 1));
			date.setUTCHours(time.getUTCHours(), time.getUTCMinutes(),
				time.getUTCSeconds(), time.getUTCMilliseconds());
			return date;
		}
		
		/**
		 * Convert a legacy string <code>CCYYMMDDThh:mm:ss</code> to a Date object
		 * @param	stamp
		 * @return Date object
		 * @see http://xmpp.org/extensions/xep-0090.html
		 */
		public static function legacyString2dateTime(stamp:String):Date
		{
			var date:Date = legacyString2date(stamp.substring(0, stamp.indexOf("T")));
			var time:Date = string2time(stamp.substring(stamp.indexOf("T") + 1));
			date.setUTCHours(time.getUTCHours(), time.getUTCMinutes(),
				time.getUTCSeconds(), time.getUTCMilliseconds());
			return date;
		}
	}
}
