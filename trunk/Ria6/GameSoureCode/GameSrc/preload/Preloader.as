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
		[Embed(source='images/woman.png')]
		public var WelcomeScreenGraphic : Class; 
		private var load:DisplayObject;
		private var tips:TextField;
		public function Preloader()
		{
			super();
			load = new WelcomeScreenGraphic();
			tips = new TextField();
			this.addChild(load);
			this.addChild(tips);
			
		}
		
		
		override public function set preloader(preloader:Sprite):void
		{
			preloader.addEventListener(ProgressEvent.PROGRESS, SWFDownloadProgress);
			preloader.addEventListener(FlexEvent.INIT_COMPLETE, FlexInitComplete);
			preloader.addEventListener(FlexEvent.INIT_PROGRESS,initing);
		}
		
		private function SWFDownloadProgress(event:ProgressEvent):void
		{
			//下载过程中。。。
			tips.text = event.bytesLoaded +"/"+event.bytesTotal;
			tips.x = (this.stage.stageWidth - tips.width) / 2;
			tips.y = (this.stage.stageHeight - tips.height) / 2;
			load.x = (this.stage.stageWidth - load.width) / 2;
			load.y = (this.stage.stageHeight - load.height) / 2;
		}
		
		private function initing(event:Event):void
		{
			//初始化成功了
			tips.text = "下载完成,系统初始化....";
			tips.x = (1000 - tips.width) / 2;
			tips.y = (800 - tips.height) / 2;
		}
		
		private function FlexInitComplete(event:Event):void
		{
			//初始化成功了,可以释放资源
			dispatchEvent(new Event(Event.COMPLETE));
			this.removeChild(load);
			this.removeChild(tips);
		}
		
		
		
	}
	
}
