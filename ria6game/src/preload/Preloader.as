/**
 * 
 * by wen2375160@163.com 
 */
package preload

{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	
	import mx.events.FlexEvent;
	import mx.preloaders.DownloadProgressBar;
	
	
	public class Preloader extends DownloadProgressBar
	{
		
		//[Embed(source="assets/loading.swf", mimeType="application/octet-stream")] flash的动画
		//[Embed(source='assets/jdyl.swf', symbol='loading')] swf资源方式
		//图片方式, embed会把图片编译进swf，好处是进度条一出来图片马上就出来
		//也可以考虑不用embed，动态load图片
		//[Embed(source='images/woman.png')]
		//public var WelcomeScreenGraphic : Class; 
		private var load:Loader;
		private var logo_loaded:Boolean = false;
		private var tips:TextField;
		private var graphic_p:Sprite;
		public function Preloader()
		{
			super();
			load = new Loader();
			tips = new TextField();
			graphic_p = new Sprite();
			this.addChild(load);
			this.addChild(graphic_p);
			this.addChild(tips);
			
			load.load(new URLRequest("logo.jpg"),new LoaderContext());
			load.contentLoaderInfo.addEventListener(Event.COMPLETE,onlogoloaded);
		}
		
		
		override public function set preloader(preloader:Sprite):void
		{
			preloader.addEventListener(ProgressEvent.PROGRESS, SWFDownloadProgress);
			preloader.addEventListener(FlexEvent.INIT_COMPLETE, FlexInitComplete);
			preloader.addEventListener(Event.COMPLETE,initing);
		}
		
		private function SWFDownloadProgress(event:ProgressEvent):void
		{
			//下载过程中。。。
			tips.text = "已下载 +"+Math.round(100*event.bytesLoaded/event.bytesTotal)
				+"%---"+event.bytesLoaded +"字节 / 共"+event.bytesTotal;
			graphic_p.graphics.clear();
			graphic_p.graphics.beginFill(0x666666,0.3);
			graphic_p.graphics.drawRect(-50,-15,3*Math.round(100*event.bytesLoaded/event.bytesTotal),30);
			graphic_p.graphics.endFill();
			adjustDisplay();
			
		}
		
		private function adjustDisplay():void{
			if(stage!=null){
				tips.x = (stage.width - tips.width) / 2;
				tips.y = (stage.height - tips.height) / 2;
				graphic_p.x = (stage.width - graphic_p.width) / 2 - 50;
				graphic_p.y = (stage.height - graphic_p.height) / 2-15;
				if(logo_loaded){
					load.x = (stage.width - load.contentLoaderInfo.width) / 2;
					load.y = (stage.height - load.contentLoaderInfo.height) / 2;
				}
			}
		}
		
		private function onlogoloaded(e:Event):void{
			logo_loaded = true;
		}
		
		private function initing(event:Event):void
		{
			//初始化成功了
			tips.text = "下载完成,系统初始化....";
			adjustDisplay();
		}
		
		private function FlexInitComplete(event:Event):void
		{
			load.contentLoaderInfo.removeEventListener(Event.COMPLETE,onlogoloaded);
			graphic_p.graphics.clear();
			this.removeChild(load);
			this.removeChild(tips);
			this.removeChild(graphic_p);
			//初始化成功了
			dispatchEvent(new Event(Event.COMPLETE));
			
		}
		
	}
	
}
