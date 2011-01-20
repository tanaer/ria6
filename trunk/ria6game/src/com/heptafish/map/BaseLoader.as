package com.heptafish.map
{
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	
	public class BaseLoader extends EventDispatcher
	{
		/**
		 * 要读的URL路径
		 * */
		protected var _url:String;
		protected var _loader:Loader;
		protected var _name:String;
		protected var _type:String;
		
		public function BaseLoader()
		{
		}
		
		
		/**
		 * 加载外部资源
		 * */
        public function load(url:String,lc:LoaderContext = null):void{
            _url = url;
            _loader = new Loader();
            _loader.load(new URLRequest(url),lc);
            addEvent();
        }
                
		/**
		 * 加载外部资源字节
		 * */
        public function loadBytes(bytes:ByteArray,lc:LoaderContext = null):void{
            _loader = new Loader;
            _loader.loadBytes(bytes,lc);
            addEvent();
        }
        
		/**
		 * 开始侦听
		 * */
        protected function addEvent():void{
            _loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,progressFun);
            _loader.contentLoaderInfo.addEventListener(Event.COMPLETE,completeFun);
            _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioErrorFun);
        }
        
		/**
		 * 结束侦听
		 * */
        protected function delEvent():void{
            _loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,progressFun);
            _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,completeFun);
            _loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorFun);
        }
        
		/**
		 * 加载成功，发布成功事件
		 * */
        protected function completeFun(e:Event):void {
            dispatchEvent(e);
            delEvent();
        }
        
		/**
		 * 加载过程
		 * */
        protected function progressFun(e:ProgressEvent):void{
            dispatchEvent(e);
        }
        
		/**
		 * 错误处理
		 * */
        protected function ioErrorFun(e:Event):void{
        	trace("读取文件出错，未找到文件！");
        	Alert.show("读取文件出错，未找到文件！"+_url);
        }
        
		/**
		 * 清除加载的资源
		 * */
        public function clear():void{
            _loader.unload();
            _loader = null;
            HeptaFishGC.gc();
        }
		/**
		 * 获取资源的URL路径
		 * */
        public function get url():String{
        	return _url;
        }
		/**
		 * 设置资源的URL路径
		 * */
        public function set url(url:String):void{
        	_url = url;
        }
		/**
		 * 获取加载器的名称
		 * */
        public function get name():String{
        	return _name;
        }
		/**
		 * 设置加载器的名称
		 * */
        public function set name(name:String):void{
        	 _name = name;
        }
		/**
		 * 获取加载对像
		 * */
        public function get loader():Loader{
        	return _loader;
        }
		/**
		 *获取类型
		 * */
        public function get type():String{
        	return _type;
        }

	}
}