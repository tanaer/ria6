package com.heptafish.map
{
		
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	
	public class GameMapItem extends BaseDisplayObject
	{
		/**
		 * 显示图像	
		 * */
		private var _bitMap:Bitmap;
		/**
		 * 配置
		 * */
		private var _configXml:XML;
		/**
		 * 是否初始化完成
		 * */
		private var _init:Boolean = false;
		/**
		 * 图片载入器
		 * */
		private var _imageLoader:ImageLoader;
		/**
		 * 建筑物层
		 * */
		private var _parentLayer:BuildingLayer; 
		/**
		 * 构构函数	
		 * */
		public function GameMapItem()
		{
			
		}
		
		/**
		 * 重置游戏地图项	
		 * */
		public function reset(bitMapData:BitmapData,configXml:XML):void{
			if(numChildren > 0)
				removeChildAt(0);
			_bitMap = new Bitmap(bitMapData);
			addChild(_bitMap);
			_configXml = configXml;
		}
		/**
		 * 图片加载完成事件的侦听函数	
		 * */
		public function imageLoaded(evet:Event):void{
			_bitMap = new Bitmap(_imageLoader._data);
			_parentLayer.imageDataMap.put(_imageLoader.url,_imageLoader._data);
			addChild(_bitMap);
			_imageLoader.removeEventListener(Event.COMPLETE,imageLoaded);
			_imageLoader = null;
			HeptaFishGC.gc();
		}
		/**
		 * 读取图片 src参数是指基础文件路径 指在地图文件中配置的建筑图片路径之前的路径	
		 * */
		public function loadImage(src:String = ""):void{
			_imageLoader = new ImageLoader();
			_imageLoader.addEventListener(Event.COMPLETE,imageLoaded);
			_imageLoader.load(src + _configXml.@file[0]);
		}
		/**
		 * 获取XML配置	
		 * */
		public function get configXml():XML{
			return _configXml;
		}
		/**
		 * 设置XML配置	
		 * */
		public function set configXml(configXml:XML):void{
			_configXml = configXml;
		}
		
		/**
		 * 获取显示图像	
		 * */
		public function get bitMap():Bitmap{
			return _bitMap;
		}
		/**
		 * 设置显示图像	
		 * */
		public function set bitMap(bitMap:Bitmap):void{
			_bitMap = bitMap;
		}
		/**
		 * 获取父级建筑物层	
		 * */
		public function get parentLayer():BuildingLayer{
			return _parentLayer;
		}
		/**
		 * 设置父级建筑物层	
		 * */
		public function set parentLayer(parentLayer:BuildingLayer):void{
			_parentLayer = parentLayer;
		}

	}
}