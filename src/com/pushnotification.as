// ActionScript file// ActionScript file
package com
{
	
	import com.mesmotronic.ane.AndroidID;
	import com.milkmangames.nativeextensions.events.PNEvent;
	import com.myflashlab.air.extensions.dependency.OverrideAir;
	import com.myflashlab.air.extensions.firebase.core.Firebase;
	import com.myflashlab.air.extensions.firebase.core.FirebaseConfig;
	import com.myflashlab.air.extensions.firebase.fcm.FCM;
	import com.myflashlab.air.extensions.firebase.fcm.FcmEvents;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.StageWebView;
	import flash.system.Capabilities;
	

	
	[SWF(frameRate="40", backgroundColor="#000000")]
	
	public class AndroidNotification extends Sprite
	{
		public var DeeplinkingObj:Object = new Object(); 
		public static const GCM_SENDER_ID:String = "406502163435";
		private var _navigator:Object;
		public function AndroidNotification()
		{

		
			
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, handleActivate);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, handleDeactivate);
			
			init();

			
		}
		
		
		
		
		
		
		
		
		private function handleActivate(e:Event):void
		{
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
		}
		
		private function handleDeactivate(e:Event):void
		{
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
		}
		
		
		
		
		
		
		
		
		
		
		
		
//		
//		private function myDebuggerDelegate($ane:String, $class:String, $msg:String):void
//		{
//			trace($ane + "(" + $class + ")" + " " + $msg);
//		}
		
		
		
		
		
		
		
		
		
		private function init():void
		{
			// remove this line in production build or pass null as the delegate
			//OverrideAir.enableDebugger(myDebuggerDelegate);
			
			var isConfigFound:Boolean = Firebase.init();
			
			if (isConfigFound)
			{
				var config:FirebaseConfig = Firebase.getConfig();
				trace("default_web_client_id = " + 			config.default_web_client_id);
				trace("firebase_database_url = " + 			config.firebase_database_url);
				trace("gcm_defaultSenderId = " + 			config.gcm_defaultSenderId);
				trace("google_api_key = " + 				config.google_api_key);
				trace("google_app_id = " + 					config.google_app_id);
				trace("google_crash_reporting_api_key = " + config.google_crash_reporting_api_key);
				trace("google_storage_bucket = " + 			config.google_storage_bucket);
				trace("project_id = " + 					config.project_id);
				
				// FCM needs Google Services so, before using FCM, we need to check that first.
				// https://firebase.google.com/docs/cloud-messaging/android/client#sample-play

				
				if(Firebase.os == Firebase.ANDROID){
					trace(Firebase.os);
					trace(Firebase.ANDROID);
					Firebase.checkGoogleAvailability(onCheckResult);
					initFCM();
				}
				else{
					trace("test")
					onCheckResult(Firebase.SUCCESS);
					initFCM();
				}
			}
				
				
				
				
			else
			{
				trace("Config file is not found!");
			}
		}
		
		
		
		
		
		
		
		
		private function onCheckResult($result:int):void
		{
			switch($result)
			{
				case Firebase.SUCCESS:
					
					trace("checkGoogleAvailability result = SUCCESS");
					
					// now you can use FCM
					initFCM();
					
					
					break;
				case Firebase.SERVICE_MISSING:
					
					trace("checkGoogleAvailability result = SERVICE_MISSING");
					
					break;
				case Firebase.SERVICE_VERSION_UPDATE_REQUIRED:
					
					trace("checkGoogleAvailability result = SERVICE_VERSION_UPDATE_REQUIRED");
					
					break;
				case Firebase.SERVICE_UPDATING:
					
					trace("checkGoogleAvailability result = SERVICE_UPDATING");
					
					break;
				case Firebase.SERVICE_DISABLED:
					
					trace("checkGoogleAvailability result = SERVICE_DISABLED");
					
					break;
				case Firebase.SERVICE_INVALID:
					
					trace("checkGoogleAvailability result = SERVICE_INVALID");
					
					break;
			}
		}
		
		
		
		
		private function initFCM():void
		{
			FCM.init(); 
			// FCM.listener.addEventListener(FcmEvents.TOKEN_REFRESH, onTokenRefresh);
			FCM.listener.addEventListener(FcmEvents.MESSAGE, onMessage);
			
			
			
			function getToken(e:MouseEvent):void
			{
				FCM.getInstanceId(onTokenReceived);
			}
			
			function onTokenReceived($token:String, $error:String):void
			{
				if($error)
				{
					trace("onTokenReceived error: " + $error);
					
				}
				
				if($token)
				{
					trace("token: " + $token);
					
				}
			}
			
			
			
		}
		
		
		
		
		
		
		
		
		
		
		private function onMessage(e:FcmEvents):void
		{
			trace(e.msg);
			var payload:Object = FCM.parsePayloadFromString(e.msg);
			
			if (payload)
			{
				for (var name:String in payload)
				{
					trace(name + " = " + payload[name]);
				}
			}
		}
		
		
		
		
		
	
		
	}
	
	
	
}