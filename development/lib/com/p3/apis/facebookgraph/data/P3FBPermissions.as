/**
 *
 * @author - Chris Andrews
 * @date - 2012
 *
 */


package com.p3.apis.facebookgraph.data
{
	
	/**
	 * This is a static class which hold all of the current permissions available to the Facebook graph API (Febuary 2012)<br />
	 * <br />
	 * More details on Permissions can be found here:<br />
	 * http://developers.facebook.com/docs/reference/api/permissions/
	 *  
	 * @author chrisandrews
	 * 
	 */
	public class P3FBPermissions
	{
		
//		USER PERMISSIONS
		/**
		 * Provides access to the "About Me" section of the profile in the about property 
		 */
		public static const USER_ABOUT_ME						:String = "user_about_me";
		
		/**
		 * Provides access to the user's list of activities as the activities connection 
		 */		
		public static const USER_ACTIVITIES						:String = "user_activities"
			
		/**
		 * Provides access to the birthday with year as the birthday property 
		 */			
		public static const USER_BIRTHDAY						:String = "user_birthday"
			
		/**
		 * Provides read access to the authorized user's check-ins or a friend's check-ins that the user can see. 
		 */			
		public static const USER_CHECKINS						:String = "user_checkins"
			
		/**
		 * Provides access to education history as the education property 
		 */			
		public static const USER_EDUCATION_HISTORY				:String = "user_education_history"
			
		/**
		 * Provides access to the list of events the user is attending as the events connection 
		 */			
		public static const USER_EVENTS							:String = "user_events"
			
		/**
		 * Provides access to the list of groups the user is a member of as the groups connection 
		 */			
		public static const USER_GROUPS							:String = "user_groups"
			
		/**
		 * Provides access to the user's hometown in the hometown property 
		 */			
		public static const USER_HOMETOWN						:String = "user_hometown"
			
		/**
		 * Provides access to the user's list of interests as the interests connection 
		 */			
		public static const USER_INTERESTS						:String = "user_interests"
			
		/**
		 * Provides access to the list of all of the pages the user has liked as the likes connection 
		 */			
		public static const USER_LIKES							:String = "user_likes"
			
		/**
		 * Provides access to the user's current location as the location property 
		 */			
		public static const USER_LOCATION						:String = "user_location"
			
		/**
		 * Provides access to the user's notes as the notes connection 
		 */			
		public static const USER_NOTES							:String = "user_notes"
			
		/**
		 * Provides access to the photos the user has uploaded, and photos the user has been tagged in 
		 */			
		public static const USER_PHOTOS							:String = "user_photos"
			
		/**
		 * Provides access to the questions the user or friend has asked 
		 */			
		public static const USER_QUESTIONS						:String = "user_questions"
			
		/**
		 * Provides access to the user's family and personal relationships and relationship status 
		 */			
		public static const USER_RELATIONSHIPS					:String = "user_relationships"
			
		/**
		 * Provides access to the user's relationship preferences 
		 */			
		public static const USER_RELATIONSHIP_DETAILS			:String = "user_relationship_details"
			
		/**
		 * Provides access to the user's religious and political affiliations
		 */			
		public static const USER_RELIGION_POLITICS				:String = "user_religion_politics"
			
		/**
		 * Provides access to the user's most recent status message
		 */			
		public static const USER_STATUS							:String = "user_status"
			
		/**
		 * Provides access to the videos the user has uploaded, and videos the user has been tagged in 
		 */			
		public static const USER_VIDEOS							:String = "user_videos"
			
		/**
		 * Provides access to the user's web site URL 
		 */			
		public static const USER_WEBSITE						:String = "user_website"
			
		/**
		 * Provides access to work history as the work property 
		 */			
		public static const USER_WORK_HISTORY					:String = "user_work_history"
			
		/**
		 * Provides access to the user's primary email address in the email property. Do not spam users. 
		 * Your use of email must comply both with Facebook policies and with the CAN-SPAM Act.<br /><br />
		 * Policies: http://www.facebook.com/legal/terms
		 */			
		public static const USER_EMAIL							:String = "email"
		
		
//		FRIENDS PERMISSIONS
		/**
		 * Provides access to the "About Me" section of the profile in the about property 
		 */
		public static const FRIENDS_ABOUT_ME					:String = "friends_about_me"
		
		/**
		 * Provides access to the user's list of activities as the activities connection 
		 */	
		public static const FRIENDS_ACTIVITIES					:String = "friends_activities"
		
		/**
		 * Provides access to the birthday with year as the birthday property 
		 */			
		public static const FRIENDS_BIRTHDAY					:String = "friends_birthday"
		
		/**
		 * Provides read access to the authorized user's check-ins or a friend's check-ins that the user can see. 
		 */			
		public static const FRIENDS_CHECKINS					:String = "friends_checkins"
		
		/**
		 * Provides access to education history as the education property 
		 */
		public static const FRIENDS_EDUCATION_HISTORY			:String = "friends_education_history"
		
		/**
		 * Provides access to the list of events the user is attending as the events connection 
		 */	
		public static const FRIENDS_EVENTS						:String = "friends_events"
		
		/**
		 * Provides access to the list of groups the user is a member of as the groups connection 
		 */	
		public static const FRIENDS_GROUPS						:String = "friends_groups"
		
		/**
		 * Provides access to the user's hometown in the hometown property 
		 */			
		public static const FRIENDS_HOMETOWN					:String = "friends_hometown"
		
		/**
		 * Provides access to the user's list of interests as the interests connection 
		 */	
		public static const FRIENDS_INTERESTS					:String = "friends_interests"
		
		/**
		 * Provides access to the list of all of the pages the user has liked as the likes connection 
		 */		
		public static const FRIENDS_LIKES						:String = "friends_likes"
		
		/**
		 * Provides access to the user's current location as the location property 
		 */			
		public static const FRIENDS_LOCATION					:String = "friends_location"
		
		/**
		 * Provides access to the user's notes as the notes connection 
		 */			
		public static const FRIENDS_NOTES						:String = "friends_notes"
		
		/**
		 * Provides access to the photos the user has uploaded, and photos the user has been tagged in 
		 */	
		public static const FRIENDS_PHOTOS						:String = "friends_photos"
		
		/**
		 * Provides access to the questions the user or friend has asked 
		 */
		public static const FRIENDS_QUESTIONS					:String = "friends_questions"
		
		/**
		 * Provides access to the user's family and personal relationships and relationship status 
		 */			
		public static const FRIENDS_RELATIONSHIPS				:String = "friends_relationships"
		
		/**
		 * Provides access to the user's relationship preferences 
		 */			
		public static const FRIENDS_RELATIONSHIP_DETAILS		:String = "friends_relationship_details"
		
		/**
		 * Provides access to the user's religious and political affiliations
		 */			
		public static const FRIENDS_RELIGION_POLITICS			:String = "friends_religion_politics"
		
		/**
		 * Provides access to the user's most recent status message
		 */			
		public static const FRIENDS_STATUS						:String = "friends_status"
		
		/**
		 * Provides access to the user's web site URL 
		 */
		public static const FRIENDS_VIDEOS						:String = "friends_videos"
		
		/**
		 * Provides access to work history as the work property 
		 */	
		public static const FRIENDS_WEBSITE						:String = "friends_website"
		
		/**
		 * Provides access to the user's primary email address in the email property. Do not spam users. 
		 * Your use of email must comply both with Facebook policies and with the CAN-SPAM Act.
		 * Policies: http://www.facebook.com/legal/terms
		 */	
		public static const FRIENDS_WORK_HISTORY				:String = "friends_work_history"
		
		
//		EXTENDED PERMISSIONS
		/**
		 * Provides access to any friend lists the user created. All user's friends are provided as part of basic data, 
		 * this extended permission grants access to the lists of friends a user has created, and should only be requested 
		 * if your application utilizes lists of friends. 
		 */
		public static const EXTENDED_READ_FRIENDLISTS			:String = "read_friendlists"
		
		/**
		 * Provides read access to the Insights data for pages, applications, and domains the user owns.
		 */
		public static const EXTENDED_READ_INSIGHTS				:String = "read_insights"
		
		/**
		 * Provides the ability to read from a user's Facebook Inbox.
		 */			
		public static const EXTENDED_READ_MAILBOX				:String = "read_mailbox"
			
		/**
		 * Provides read access to the user's friend requests 
		 */			
		public static const EXTENDED_READ_REQUESTS				:String = "read_requests"
			
		/**
		 * Provides access to all the posts in the user's News Feed and enables your application to perform searches 
		 * against the user's News Feed 
		 */			
		public static const EXTENDED_READ_STREAM				:String = "read_stream"
			
		/**
		 * Provides applications that integrate with Facebook Chat the ability to log in users. 
		 */			
		public static const EXTENDED_XMPP_LOGIN					:String = "xmpp_login"
			
		/**
		 * Provides the ability to manage ads and call the Facebook Ads API on behalf of a user. 
		 */			
		public static const EXTENDED_ADS_MANAGEMENT				:String = "ads_management"
			
		/**
		 * Enables your application to create and modify events on the user's behalf 
		 */			
		public static const EXTENDED_CREATE_EVENT				:String = "create_event"
			
		/**
		 * Enables your app to create and edit the user's friend lists. 
		 */			
		public static const EXTENDED_MANAGE_FRIENDLISTS			:String = "manage_friendlists"
			
		/**
		 * Enables your app to read notifications and mark them as read. 
		 */			
		public static const EXTENDED_MANAGE_NOTIFICATIONS		:String = "manage_notifications"
			
		/**
		 * Enables your app to perform authorized requests on behalf of the user at any time. By default, most access 
		 * tokens expire after a short time period to ensure applications only make requests on behalf of the user when 
		 * the are actively using the application. This permission makes the access token returned by our OAuth endpoint 
		 * long-lived. 
		 */			
		public static const EXTENDED_OFFLINE_ACCESS				:String = "offline_access"
			
		/**
		 * Provides access to the user's online/offline presence 
		 */			
		public static const EXTENDED_USER_ONLINE_PRESENCE		:String = "user_online_presence"
			
		/**
		 * Provides access to the user's friend's online/offline presence 
		 */			
		public static const EXTENDED_FRIENDS_ONLINE_PRESENCE	:String = "friends_online_presence"
			
		/**
		 * Enables your app to perform checkins on behalf of the user.
		 */			
		public static const EXTENDED_PUBLISH_CHECKINS			:String = "publish_checkins"
			
		/**
		 * Enables your app to post content, comments, and likes to a user's stream and to the streams of the user's friends. 
		 * With this permission, you can publish content to a user's feed at any time, without requiring offline_access. 
		 * However, please note that Facebook recommends a user-initiated sharing model. 
		 */			
		public static const EXTENDED_PUBLISH_STREAM				:String = "publish_stream"
			
		/**
		 * Enables your application to RSVP to events on the user's behalf 
		 */			
		public static const EXTENDED_RSVP_EVENT					:String = "rsvp_event"
			
		/**
		 * Enables your application to publish user scores and achievements.<br /><br />
		 * SCORE: http://developers.facebook.com/docs/score/ <br />
		 * ACHIEVEMENTS: http://developers.facebook.com/docs/achievements/
		 */			
		public static const EXTENDED_PUBLISH_ACTIONS			:String = "publish_actions"
		
	}
}