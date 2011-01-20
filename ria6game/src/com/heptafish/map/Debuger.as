package com.heptafish.map
{
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.utils.Timer;
	
	import mx.controls.TextArea;

	public class Debuger {
		public static var JS_COMMAND:Array = ["sendToActionScript", "sendToJavaScript"];
		[Bindable]public static var STATIC_DEBUG_MSG:String = "";
		
		public function Debuger() {
		}
		
		public static function debug(textArea:TextArea, msg:String):void{
			textArea.text += msg;
		}
		
		public static function staticDebug(msg:String, isAdd:Boolean = true):void{
			if(isAdd){
				STATIC_DEBUG_MSG += msg;
			}else{
				STATIC_DEBUG_MSG = msg;
			}
		}
		
		public static function callBackDebug(func:Function, ...args):void{
			//ExternalInterface.addCallback(JS_COMMAND[0], func);
		}
		
		public static function JSDebug(msg:String):void{
			if (ExternalInterface.available) {
				try {
					//ExternalInterface.addCallback(JS_COMMAND[0], receivedFromJavaScript);
					ExternalInterface.call(JS_COMMAND[1], msg); 

					if (checkJavaScriptReady()) {
					} else {
						var readyTimer:Timer=new Timer(100,0);
						readyTimer.addEventListener(TimerEvent.TIMER,timerHandler);
						readyTimer.start();
					}
				} catch (error:SecurityError) {
				} catch (error:Error) {
				}
			} else {
			}
		}
		
		private static function receivedFromJavaScript(value:String):void {
			//output.appendText("JavaScript says: " + value + "\n");
		}
		private static function checkJavaScriptReady():Boolean {
			var isReady:Boolean = ExternalInterface.call("isReady");
			return isReady;
		}
		private static function timerHandler(event:TimerEvent):void {
			//output.appendText("Checking JavaScript status...\n");
			var isReady:Boolean=checkJavaScriptReady();
			if (isReady) {
				//output.appendText("JavaScript is ready.\n");
				Timer(event.target).stop();
			}
		}
		private static function clickHandler(event:MouseEvent):void {
			if (ExternalInterface.available) {
				//ExternalInterface.call("sendToJavaScript", input.text);
			}
		}
	}
}