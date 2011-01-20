package GamePlug
{
	import Manager.GameManager;
	
	import com.heptafish.map.BaseDisplayObject;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class DebugVisual extends BaseDisplayObject
	{
		public function DebugVisual()
		{
			super();
			init()
		}
		
		public var debugtxt:TextField
		
		public function init():void{
			debugtxt=new TextField()
			debugtxt.autoSize=TextFieldAutoSize.LEFT
			var tefor:TextFormat=new TextFormat()
			tefor.color=0x303333	
			debugtxt.defaultTextFormat=tefor
			debugtxt.setTextFormat(tefor)
			

			
			
			this.addChild(debugtxt)
		
		}
		private var debugcount:int=0
			
		public function trace(instr:Object):void{
			if(debugcount>GameManager.maxdebugline){
				debugcount=0
				debugtxt.text=""		
			}
			else{
				debugcount++
			}
			
			if(GameManager.isdebug==1){
				debugcount++
			debugtxt.appendText("[调试] "+instr.toString()+"\n")
			}
			
		}
		
	}
}