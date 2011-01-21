package com.heptafish.map
{	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	/**
	 * 地图层 图片	
	 * */
	public class MapLayer extends BaseDisplayObject
	{
		/**
		 * 图片读取器	
		 * */
			private var _imageLoader:ImageLoader;
			/**
			 * 地图图片 用于整块加载模式	
			 * */
			private var _image:Bitmap;
			/**
			 * 地图图片数组 用于栅格式加载地图模式	
			 * */
			private var _imageMap:HashMap;
			/**
			 * 小地图图片	
			 * */
			private var _simage:Bitmap;
			//
			private var _map:GameMap;
			/**
			 * 加载类型 0：整块加载 1：栅格加载	
			 * */
			private var _loadType:int;
			/**
			 * 地图可视宽度	
			 * */
			private var _visualWidth:Number;
			/**
			 * 地图可视高度	
			 * */
			private var _visualHeight:Number;
			/**
			 * 地图切割单元宽度	
			 * */
			private var _sliceWidth:Number;
			/**
			 * 地图切割单元高度	
			 * */
			private var _sliceHeight:Number;
			/**
			 * 横向预加载屏数	
			 * */
			private var _preloadX:Number;
			/**
			 * 纵向预加载屏数	
			 * */
			private var _preloadY:Number;
			/**
			 * 正在加载的屏map	
			 * */
			private var _loadingMap:HashMap;
			/**
			 * 等待加载的loadermap	
			 * */
			private var _waitLoadingArr:Array;
			
			private var _loadingNo:int = 1;
			/**
			 * 一屏需要加载的横向图片数	
			 * */
			private var _screenImageRow:int;
			/**
			 * 一屏需要加载的纵向图片数	
			 * */
			private var _screenImageCol:int;
			/**
			 * 总横向节点数	
			 * */
			private var _row:int;
			/**
			 * 建总纵向节点数	
			 * */
			private var _col:int;
			/**
			 * 当前人物所处的屏	
			 * */
			private var _nowPlayerPoint:Point;
			
		public function MapLayer(map:GameMap)
		{
			_map = map; 
			_loadType = parseInt(_map.mapXML.@loadType);
		}
			/**
			 * 读取地图图片	
			 * */
		public function load():void{
			/**
			 * 加载小地图	
			 * */
			var imageLoader:ImageLoader = new ImageLoader();
		 	var fileName:String = 'maps/' + _map.name + "/map_s.jpg";//Config.getValue("mapLib")
		 	imageLoader.load(fileName);
		 	imageLoader.addEventListener(Event.COMPLETE,loadSuccess);
		 	imageLoader.addEventListener(ProgressEvent.PROGRESS,loadingHandler);
		 	imageLoader.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
		 
		}
		/**
		 * 读取大地图成功	
		 * */
		private function loadBigSuccess(evet:Event):void{
			var imageLoader:ImageLoader = ImageLoader(evet.target);
			var image:Bitmap = new Bitmap(imageLoader._data);
			addChild(image);
			if(_simage != null && _simage.parent == this){
				removeChild(_simage);
				_simage = null;
			}
			this.width = image.width;
			this.height = image.height;
			imageLoader.removeEventListener(Event.COMPLETE,loadBigSuccess);
			imageLoader.removeEventListener(ProgressEvent.PROGRESS,loadingHandler);
			imageLoader.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			imageLoader = null;
			dispatchEvent(evet);
			HeptaFishGC.gc();
		}
		/**
		 * 读取小地图成功后按照_loadType类型调用不同加载函数	
		 * */
		private function loadSuccess(evet:Event):void{
			var imageLoader:ImageLoader = ImageLoader(evet.target);
			var image:Bitmap = new Bitmap(imageLoader._data);
			image.width *= 10;
			image.height *= 10;
			addChild(image);
			imageLoader.removeEventListener(Event.COMPLETE,loadSuccess);
			imageLoader.removeEventListener(ProgressEvent.PROGRESS,loadingHandler);
			imageLoader.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			imageLoader = null;
			dispatchEvent(evet);
			HeptaFishGC.gc();
			switch(_loadType){
				case 0:
					/**
					 * 整块加载
					 * 加载大地图	
					 * */		
					var bfileName:String ='maps/' + _map.name + "/map.jpg";
					var bLoader:ImageLoader = new ImageLoader(); 
					bLoader.load(bfileName);
					bLoader.addEventListener(Event.COMPLETE,loadBigSuccess);
					bLoader.addEventListener(ProgressEvent.PROGRESS,loadingHandler);
					bLoader.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
				break;
				case 1:
					_loadingMap = new HashMap();
					_imageMap = new HashMap();
					_waitLoadingArr = new Array();
					_visualWidth = _map.app.screen.size.x;
					_visualHeight = _map.app.screen.size.y;
					_sliceWidth = parseFloat(_map.mapXML.@sliceWidth);
					_sliceHeight = parseFloat(_map.mapXML.@sliceHeight);
					_preloadX = parseFloat(_map.mapXML.@preloadX);
					_preloadY = parseFloat(_map.mapXML.@preloadY);
					_screenImageRow = Math.round(_visualWidth/_sliceWidth);
					_screenImageCol = Math.round(_visualHeight/_sliceHeight);
					_row = Math.ceil(_map.mapWidth/_sliceWidth);
					_col = Math.ceil(_map.mapHeight/_sliceHeight);
					loadSliceImage(_map.initPlayerPoint);
				break;
				default:
				break;
			}
		}
		
		/**
		 * 根据player坐标读取周边指定屏数地图	
		 * */
		private function loadSliceImage(playerPoint:Point):void{
			/**
			 * 现在所处的索引X	
			 * */
			var nowX:int = int(playerPoint.x/_sliceWidth);
			/**
			 * 现在所处的索引Y	
			 * */
			var nowY:int = int(playerPoint.y/_sliceHeight);
			/**
			 * 现在所处的屏索引X数
			 * */
			var nowScreenX:int = int(nowX/_screenImageRow);
			/**
			 * 现在所处的屏索引Y	
			 * */
			var nowScreenY:int = int(nowY/_screenImageCol);
		
			_nowPlayerPoint = new Point(nowScreenX,nowScreenY);
			loadScreenImage(nowScreenX,nowScreenY);
			var startX:int = (nowScreenX - _preloadX < 0 ? 0 : nowScreenX - _preloadX);
			var startY:int = (nowScreenY - _preloadY < 0 ? 0 : nowScreenY - _preloadY);
			 
			var endX:int = (nowScreenX + _preloadX > _row ? _row : nowScreenX + _preloadX);
			var endY:int = (nowScreenY + _preloadY > _col ? _col : nowScreenY + _preloadY);
		
			for(var xx:int = startX; xx < endX;xx++){
				for(var yy:int = startY; yy < endY;yy++){
					if(xx == nowScreenX && yy == nowScreenY){
						continue;
					}else{
						loadScreenImage(xx,yy);
					}
				}
			}
		}
		/**
		 * 加载指定屏的地图图片	
		 * */
		private function loadScreenImage(screenX:int,screenY:int):void{
			var starX:int = _screenImageRow*screenX <= 0 ? 0 : _screenImageRow*screenX;
			var starY:int = _screenImageCol*screenY <= 0 ? 0 : _screenImageCol*screenY;
			var endX:int = _screenImageRow*(screenX+1) >= _row - 1 ? _row -1 : _screenImageRow*(screenX+1);
			var endY:int = _screenImageCol*(screenY+1) >= _col-1	? _col-1 : _screenImageCol*(screenY+1);
			for(var yy:int = starY;yy<=endY;yy++){
				for(var xx:int = starX;xx<=endX;xx++){
					var tempKey:String = yy+"_"+xx;
					if(!_loadingMap.containsValue(tempKey) && !_imageMap.containsKey(tempKey)){
						_waitLoadingArr.push(tempKey);
					}
				}
				_waitLoadingArr.reverse();
				loadImage();
			}
		}
		
		/**
		 * 加载地图图片	
		 * */
		private function loadImage():void{
			if(_waitLoadingArr.length > 0){
				for(var i:int = 0;i<_loadingNo - _loadingMap.size();i++){
					var key:String = _waitLoadingArr.pop();
					var imageLoader:ImageLoader = new ImageLoader();
					var fileName:String = 'maps/' + _map.name +"/" + key	+ ".jpg";
					_loadingMap.put(imageLoader,key);
					imageLoader.addEventListener(Event.COMPLETE,loadScreenImageSuccess);
					imageLoader.addEventListener(ProgressEvent.PROGRESS,loadingHandler);
					imageLoader.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
					imageLoader.load(fileName);
				}
			}
		}
		
		/**
		 * 成功加载某屏的图片	
		 * */
		private function loadScreenImageSuccess(evet:Event):void{
			var imageLoader:ImageLoader = ImageLoader(evet.target);
			var tempStr:String = String(_loadingMap.getValue(imageLoader));
			var tempStrArr:Array = tempStr.split("_");
			var yy:int = tempStrArr[0];
			var xx:int = tempStrArr[1];
			_loadingMap.remove(imageLoader);
			var image:Bitmap = new Bitmap(imageLoader._data);
			image.x = _sliceWidth*xx;
			image.y = _sliceHeight*yy;
			this.addChild(image);
			_imageMap.put(yy+"_"+xx,image);
			imageLoader.removeEventListener(Event.COMPLETE,loadScreenImageSuccess);
			imageLoader.removeEventListener(ProgressEvent.PROGRESS,loadingHandler);
			imageLoader.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			imageLoader = null;
			loadImage();
		}
		/**
		 * 卸载指定屏的地图图片	
		 * */
		private function removeScreenImage(screenX:int,screenY:int):void{
			var startX:int = (screenX - _preloadX < 0 ? 0 : screenX - _preloadX);
			var startY:int = (screenY - _preloadY < 0 ? 0 : screenY - _preloadY);
			 
			var endX:int = (screenX + _preloadX > _row ? _row : screenX + _preloadX);
			var endY:int = (screenY + _preloadY > _col ? _col : screenY + _preloadY);
			var keyArr:Array = _imageMap.keys();
			for(var i:int = 0;i < keyArr.length;i++){
				var key:String = keyArr as String;
				var tempStrArr:Array = key.split("_");
				var yy:int = tempStrArr[0];
				var xx:int = tempStrArr[1];
				if(xx < startX*_screenImageRow || xx > endX * _screenImageRow || yy < startY*_screenImageCol || yy > endY*_screenImageCol){
					var image:Bitmap = Bitmap(_imageMap.getValue(key));
					this.removeChild(image);
					image = null;
					_imageMap.remove(key);
				}
			}
			HeptaFishGC.gc();
		}
		
		/**
		 * 检查是否需要加载	
		 * */
		public function checkLoad(point:Point):void{
			/**
			 * 现在所处的索引X	
			 * */
			var nowX:int = Math.floor(point.x/_sliceWidth);
			/**
			 * 现在所处的索引Y	
			 * */
			var nowY:int = Math.floor(point.y/_sliceHeight);
			/**
			 * 现在所处的屏索引X	
			 * */
			var nowScreenX:int = Math.floor(nowX/_screenImageRow);
			/**
			 * 现在所处的屏索引Y	
			 * */
			var nowScreenY:int = Math.floor(nowY/_screenImageCol);
			if(nowScreenX != _nowPlayerPoint.x || nowScreenY != _nowPlayerPoint.y){
				loadSliceImage(point);
			}
		}
	}
}