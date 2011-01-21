package  {
	
	import flash.display.MovieClip;
	import Pro.AsocketServer.ASocketClient;
	import Config.ServerConfig;
	import flash.events.Event;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import Pro.AsocketServer.ASocketData;
	import flash.utils.ByteArray;
	
	
	public class talktemple extends MovieClip {
		
		public var btn1:SimpleButton
		public var btn2:SimpleButton
		public var logtxt:TextField
		public function talktemple() {
			// constructor code
			logtxt.text="本示例显示如何联接服务器并发送聊天信息"
			
			btn2.visible=false
			btn1.addEventListener(MouseEvent.CLICK,showloging)
			btn2.addEventListener(MouseEvent.CLICK,sendtalk)
			serconn=new ASocketClient()
			
		}
		public var serconn:ASocketClient
		public function login(){
			serconn.addEventListener(ASocketClient.ClientConnedeve,showConnOK)
			serconn.addEventListener(ASocketClient.ClientConerreve,showConnERR)
			serconn.addEventListener(ASocketClient.ClientDatain,showDATA)
			
			
			serconn.Connect(ServerConfig.Serverip,ServerConfig.Serverport)
			
			
			
			}
			
			public function showConnOK(e:Event):void{
				btn1.visible=false
				btn2.visible=true
				log("服务器联接成功,点击发送按钮发送hello!")
				sendInfo(0,"username")
				}
				
		public function showConnERR(e:Event):void{
			log("服务器联接失败")
			}
			
		public function log(instr:String):void{
			logtxt.text+="\n"+instr+"\n"
			
			}	
			public function showDATA(e:Event):void{
					var dataay:ByteArray=serconn.SocketDataBuffer
			var ClientData:ASocketData=new ASocketData()
			ClientData.messageout=dataay
			
				log(ClientData.getString())
				
				}
			import Pro.WGSData.Wgs_Data
			
			public function showloging(e:Event):void{
				login()
				}
			
			public function sendtalk(e:Event):void{
				sendInfo(5,"hello")
				}
				
				
			public function sendInfo(funid,...arg):void{
			trace("send...")
			var socdat:ASocketData=new ASocketData()
			
		//var cmday:Array=new Array("mededu","mededuyst")
			var cmdxml:XML=Wgs_Data.GetCmdbyArgs(110,funid,arg)
		//log(cmdxml)
			var sendCmdByte:ByteArray=Wgs_Data.processXMLtoByte(cmdxml)
			serconn.SendData(sendCmdByte)
			
		
			}
			
			
			
			
			
	}

}
