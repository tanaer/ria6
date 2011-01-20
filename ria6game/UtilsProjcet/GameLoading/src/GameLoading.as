package
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	public class GameLoading extends Sprite
	{
		
		public function GameLoading()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,ini)
		}
		public var bgloader:Loader
		public var loadtxt:TextField
		public function ini(e:Event):void{
			this.stage.scaleMode=StageScaleMode.NO_SCALE
				this.stage.align=StageAlign.TOP_LEFT
			
				loadtxt=new TextField()
				loadtxt.text="正在加载中,请稍等..."
				loadtxt.x=530
				loadtxt.y=600
				loadtxt.width=300
			bgloader=new Loader()
			bgloader.x=250
			bgloader.y=100
			bgloader.load(new URLRequest("logo.jpg"))
			this.addChild(bgloader)
			this.addChild(loadtxt)
			loadmovie()
		}
		public function loadmovie():void{
			bgloader=new Loader()
			bgloader.x=0
			bgloader.y=0
			bgloader.contentLoaderInfo.addEventListener(Event.COMPLETE,showgame)
			bgloader.load(new URLRequest("MapDemo.swf"))
			//this.addChild(bgloader)
		
		
		}
		
		protected function showgame(event:Event):void
		{
			trace("gameloaded")
			// TODO Auto-generated method stub
			bgloader.visible=false
			this.addChild(bgloader)
			setTimeout(delayshow,2500)
			
		}
		public function delayshow():void{
		
			bgloader.visible=true
				//this.visible=false
		}
		
		
	}
}