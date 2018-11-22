package com
{
	import com.freshplanet.nativeExtensions.PushNotification;
	import com.freshplanet.nativeExtensions.PushNotificationEvent;
	import com.mesmotronic.ane.AndroidID;
	
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.profiler.Telemetry;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import mx.events.Request;
	
	import flashx.textLayout.elements.LinkElement;
	
	import views.AppWebViewScreenView;
	import views.CookingMethodDetailScreenView;
	import views.CutDetailScreenView;
	import views.RecipesDetailScreenView;
	import views.cmsPagesDetailView;
	import views.cmsPagesListView;
	
	[SWF(frameRate="40", backgroundColor="#000000")]
	
	public class AndroidDeviceId extends Sprite
	{
		//https://afterisk.wordpress.com/2012/09/22/the-only-free-and-fully-functional-android-gcm-native-extension-for-adobe-air/
		//your gcm sender id (listed on your app page at google developer portal)
		//public static const GCM_SENDER_ID:String = "921350435548";// "yourGCMSenderID";974406036632,644624582827
		public static const GCM_SENDER_ID:String = "406502163435";// "yourGCMSenderID";
		//		private var _gcmi:GCMPushInterface;
		private var _gcmDeviceID:String;
		private var _payload:String;
		public var DeeplinkingObj:Object = new Object(); 
		public var push:PushNotification = PushNotification.getInstance();
		
		public function AndroidDeviceId()
		{
			//AndroidID.ANDROID_ID
			//push.addEventListener(PushNotificationEvent.APP_BROUGHT_TO_FOREGROUND_FROM_NOTIFICATION_EVENT, pushNotificationHandler);
			
			push.registerForPushNotification(GCM_SENDER_ID);
			// Register for events
			push.addEventListener(PushNotificationEvent.PERMISSION_GIVEN_WITH_TOKEN_EVENT, handleRegistrationIDReceived);
			
			push.addEventListener(PushNotificationEvent.NOTIFICATION_RECEIVED_WHEN_IN_FOREGROUND_EVENT, onNotificationReceivedInForeground);
			push.addEventListener( PushNotificationEvent.APP_BROUGHT_TO_FOREGROUND_FROM_NOTIFICATION_EVENT, onNotificationReceivedInBackground);
			
			//PushNotification.getInstance().addListenerForStarterNotifications(onNotificationReceivedStartingTheApp);
			
			trace("Andriod DeviceID")
			
		}
		
		private function onNotificationReceivedInForeground(e):void
		{
			trace(" onNotificationReceivedInForeground "+ e);
			recieveDeepLinking(e.parameters.tickerText);
		}
		
		private var _navigator:Object
		public function setDeepLinkingNavigator(navigatorObject:Object):void
		{
			_navigator = navigatorObject
		}
		
		function replaceAll(mainString:String,replace:String, replaceWith:String):String{
			return mainString.split(replace).join(replaceWith);
		}
		
		private function onNotificationReceivedInBackground(e):void
		{
			//trace("on Notificaton Background"+ e.parameters.tickerText + " --- "+ e.parameters.tickerText.length);
			
			
			recieveDeepLinking(e.parameters.tickerText);
			
		}
		///////////////////////////////////////////////////////////////////////////
		private function onActivate(e:Event = null):void
		{
			setAppInForeground(true);
		}
		
		// APP IN BACKGROUND
		private function onDeactivate(e:Event):void
		{
			setAppInForeground(false);
		}
		public function setAppInForeground(value:Boolean):void
		{
			PushNotification.setIsAppInForeground(value);
		}
		///////////////////////////////////////////////////////////////////////////////
		
		
		private function handleRegistrationIDReceived(e):void
		{
			// Gooogle
			//Server API Key - AIzaSyCMn4sJm_z-KEycVgmATiAX5Lg6KKBCgwg
			//Sender ID - 921350435548
			//send device id to backend service that will broadcast messages
			
			ConstantDataClass.deviceTokenID = e.token;
			trace("handleRegistrationIDReceived " + e.token)
			var _dbConnection:DbCommunication = new DbCommunication();
			var paramObj:Object = new Object();
			paramObj.language = ConstantDataClass.currentLanguageCode;
			paramObj.deviceToken = e.token;
			paramObj.deviceOS = "ANDROID";
			paramObj.deviceUniqueID = AndroidID.ANDROID_ID
			_dbConnection.callHttpService("getDeviceToken.php",function(dataObj)
			{},function(dataObj)
			{},paramObj);
		}
	}
}
// ActionScript file