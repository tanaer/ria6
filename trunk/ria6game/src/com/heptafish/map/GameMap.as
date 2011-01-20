package com.heptafish.map
{
	
	import Manager.GameManager;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	
	import mx.core.Application;
	
	public class GameMap extends BaseDisplayObject
	{	
		/**
		 * 人物清单	
		 * */
		public var playerList:Array = new Array();
		/**
		 * 人物	
		 * */
		private var _player:HeptaFishCharacter;
		/**
		 * 地图宽度	
		 * */
		private var _mapWidth:Number;
		/**
		 * 地图高度	
		 * */
		private var _mapHeight:Number;
		/**
		 * 地图单元格宽度	
		 * */
		private var _cellWidth:Number;
		/**
		 * 地图单元格高度	
		 * */
		private var _cellHeight:Number;
		/**
		 * 地图元件数组	
		 * */
		private var _itemArr:Array;
		/**
		 * 地图信息数组
		 * */
		private var _mapArr:Array;
		/**
		 * 地图直角坐标数组
		 * */
		private var _mapDArr:Array;
		/**
		 * 地图信息XMl	
		 * */
		private var _mapXML:XML;
		/**
		 * 纵向节点数
		 * */
		private var _row:int;
		/**
		* 	横向节点数
		* */
		private var _col:int;
		private var _pathIndex:int;
		/**
		 * 地图层 
		 * */
		private var _mapLayer:MapLayer;
		/**
		 * 建筑层	
		 * */
		private var _buildLayer:BuildingLayer;
		/**
		 * 网格层
		 * */
		private var _gridLayer:GridLayer;
		/**
		 * 路点层	
		 * */
		private var _roadPointLayer:RoadPointLayer;
		/**
		 * 初始时人物坐标
		 * */
		private var _initPlayerPoint:Point;

		private var _roadSeeker:RoadSeeker;
		private var _roadArr:Array;
		private var _roadMap:HashMap = new HashMap();
		
		private var _app:Application;

		
		
		public function GameMap(mapXML:XML, app:Application, playerPoint:Point = null)
		{
			this._app = app;
			_mapXML = mapXML;
			this.name = _mapXML.@name;
			_initPlayerPoint = playerPoint||new Point(30,80);
			_mapWidth = _mapXML.@mapwidth;
			_mapHeight = _mapXML.@mapheight;
			_cellWidth = _mapXML.floor.@tileWidth;
			_cellHeight = _mapXML.floor.@tileHeight;
			_mapArr = GameMapUtils.getArrByStr(_mapXML.floor,_mapXML.floor.@col,_mapXML.floor.@row);
			_row = _mapArr.length;
			_col = _mapArr[0].length;
			_mapDArr = GameMapUtils.getDArrayByArr(_mapArr,_row,_col,_roadMap);
			_roadSeeker = new RoadSeeker(_mapDArr,_cellWidth,_cellHeight*2);
			initMap();
		}
		/**
		 * 初始化	
		 * */
		private function initMap():void{
			
			_mapLayer = new MapLayer(this);
			addChild(_mapLayer);
			
			_gridLayer = new GridLayer(this);
			_gridLayer.drawGrid(_mapWidth, _mapHeight, this._cellWidth, this._cellHeight)
			
			_buildLayer = new BuildingLayer(this);
			addChild(_buildLayer);
			_mapLayer.addEventListener(Event.COMPLETE, mapLayerLoaded);
			_mapLayer.load();
			_buildLayer.drawByXml(_mapXML);
			
			for(var bldIndex:int = 0; bldIndex< _buildLayer.buildingArray.length; bldIndex++){
				var bld:GameMapItem = _buildLayer.buildingArray[bldIndex];
				for(var __bldIndex:int = 0; __bldIndex< _buildLayer.buildingArray.length; __bldIndex++){
					var bld_:GameMapItem = _buildLayer.buildingArray[__bldIndex];
					if(bld.y > bld_.y ){
						if(_buildLayer.getChildIndex(bld as DisplayObject) < _buildLayer.getChildIndex(bld_ as DisplayObject))_buildLayer.swapChildren(bld, bld_);
					}else {
						if(_buildLayer.getChildIndex(bld as DisplayObject) > _buildLayer.getChildIndex(bld_ as DisplayObject))_buildLayer.swapChildren(bld, bld_);
					}							
				}
			}
			
		}
		
		/**
		 * 设置控制角色
		 **/
		public function setControlPlayer(playerIndex:int = 0):void{
			if(playerList.length > 0){
				_player = playerList[playerIndex];
				_player.mapEle = this;
				_player.x = _initPlayerPoint.x;
				_player.y = _initPlayerPoint.y;
			}else{
			}
		}
		
		/**
		 * 加入用户角色	
		 * */
		public function addPlayer(player:HeptaFishCharacter):void{
			playerList.push(player);
			player.mapEle = this;
			player.x = _initPlayerPoint.x;
			player.y = _initPlayerPoint.y;
			_buildLayer.addChild(player as DisplayObject);
		}
		/**
		 * 地图层加载完成	
		 * */
		private function mapLayerLoaded(evet:Event):void{
			
		}
		/**
		 * 地图点击事件	
		 * */
		public function onClick(event:Event):void{
			
			_player.moveToX = event.currentTarget.mouseX;
			_player.moveToY = event.currentTarget.mouseY;
			var nowPoint:Point = new Point(_player.x, _player.y);
			var targetPoint:Point = new Point(event.currentTarget.mouseX, event.currentTarget.mouseY);
		
			GameManager.trace("角色从("+nowPoint.x+","+nowPoint.y+") 移动到"+"("+targetPoint.x+","+targetPoint.y+") ")
			manWalk(_player, nowPoint, targetPoint);
		}
		
		/**
		 * 指定的人物走路
		 * */
		public function manWalk(man:HeptaFishCharacter, nowPoint:Point, targetPoint:Point):void{
			var _nodeRPoint:Point = GameMapUtils.getDirectPointByPixel(_cellWidth,_cellHeight,targetPoint.x,targetPoint.y,_row);
			var __nodeX:int = _nodeRPoint.x;
			var __nodeY:int = _nodeRPoint.y;
			
			var _roleRPoint:Point = GameMapUtils.getDirectPointByPixel(_cellWidth,_cellHeight,man.x,man.y-_cellHeight,_row);

			var __roleX:int = _roleRPoint.x;
			var __roleY:int = _roleRPoint.y;
			var __length:int;
			var maxP:Point = GameMapUtils.getMaxDirectPoint(_row,_col);
			if(__nodeX>=0 && __nodeX<maxP.x && __nodeY>=0 && __nodeY<maxP.y && _roadSeeker.value(__nodeX, __nodeY)==0){
				_roadArr =_roadSeeker.path8(new Point(__roleX, __roleY), new Point(__nodeX, __nodeY));
				__length = _roadSeeker.path.length;
				if(__length>0){
					_pathIndex = 1;

					var px:int =  _roadMap.getValue(_roadSeeker.path[_pathIndex].y+"-"+_roadSeeker.path[_pathIndex].x).px;
					var py:int =  _roadMap.getValue(_roadSeeker.path[_pathIndex].y+"-"+_roadSeeker.path[_pathIndex].x).py;
					
					man.addEventListener(WalkEvent.WALK_END, onMoveOver);
					man.addEventListener(WalkEvent.ON_WALK,checkDep);
					var tp:Point = GameMapUtils.getPixelPoint(_cellWidth,_cellHeight,px,py);
					man.moveTo(tp.x, tp.y+_cellHeight);
				}else if(__length == 0){
					var newPointArray:Array = [ GameMapUtils.getDirectPointByPixel(_cellWidth, _cellHeight, man.x - _cellWidth, man.y-_cellHeight, _row),
												GameMapUtils.getDirectPointByPixel(_cellWidth, _cellHeight, man.x - _cellWidth/2, man.y-_cellHeight - _cellHeight/2, _row), 
												GameMapUtils.getDirectPointByPixel(_cellWidth, _cellHeight, man.x, man.y, _row),
												GameMapUtils.getDirectPointByPixel(_cellWidth, _cellHeight, man.x + _cellWidth/2, man.y-_cellHeight - _cellHeight/2, _row),
												GameMapUtils.getDirectPointByPixel(_cellWidth, _cellHeight, man.x + _cellWidth, man.y-_cellHeight, _row),
												GameMapUtils.getDirectPointByPixel(_cellWidth, _cellHeight, man.x + _cellWidth/2, man.y-_cellHeight + _cellHeight/2, _row),
												GameMapUtils.getDirectPointByPixel(_cellWidth, _cellHeight, man.x, man.y-_cellHeight + _cellHeight/2, _row),
												GameMapUtils.getDirectPointByPixel(_cellWidth, _cellHeight, man.x - _cellWidth/2, man.y-_cellHeight + _cellHeight/2, _row)
											  ]
					for(var i:int = 0; i<newPointArray.length; i++){
						var ___roleX:int = newPointArray[i].x;
						var ___roleY:int = newPointArray[i].y;
						var __roadArr:Array =_roadSeeker.path8(new Point(___roleX, ___roleY), new Point(__nodeX, __nodeY));
						if(__roadArr.length > 1){
							_pathIndex = 1;
		
							var px_:int =  _roadMap.getValue(_roadSeeker.path[_pathIndex].y+"-"+_roadSeeker.path[_pathIndex].x).px;
							var py_:int =  _roadMap.getValue(_roadSeeker.path[_pathIndex].y+"-"+_roadSeeker.path[_pathIndex].x).py;
							
							man.addEventListener(WalkEvent.WALK_END, onMoveOver);
							man.addEventListener(WalkEvent.ON_WALK,checkDep);
							var tp_:Point = GameMapUtils.getPixelPoint(_cellWidth,_cellHeight,px_,py_);
							man.moveTo(tp_.x, tp_.y+_cellHeight);
							break;
						}
					}
					var newStartPoint:Point = new Point();
				}
			}
		}
		
		/**
		 * 一段路程移动完成	
		 * */
		protected function onMoveOver(event:Event):void{
			var player:HeptaFishCharacter = event.target as HeptaFishCharacter;
			if(_pathIndex<_roadArr.length-1){
				_pathIndex++;
				if(_pathIndex==_roadArr.length){
					player.moveTo(player.moveToX, player.moveToY);
				}else{
					var px:int =  _roadMap.getValue(_roadSeeker.path[_pathIndex].y+"-"+_roadSeeker.path[_pathIndex].x).px;
					var py:int =  _roadMap.getValue(_roadSeeker.path[_pathIndex].y+"-"+_roadSeeker.path[_pathIndex].x).py;
					_player.addEventListener(WalkEvent.WALK_END, onMoveOver);
					var tp:Point = GameMapUtils.getPixelPoint(_cellWidth,_cellHeight,px,py);
					_player.moveTo(tp.x, tp.y+_cellHeight);
				}
			}else{
				player.removeEventListener(WalkEvent.WALK_END, onMoveOver);
			}
		}
		
		//校正图像夹角,p_x:玩家目前座标，bitmapx:图像的座标
		private function checkDiff(p_x:int,bitmapx:int):int{
			var diffx:int = (p_x-bitmapx)*Math.tan(30/180*3.14);		
			return diffx;
		}
		
		/**
		 * 移动中 检查深度	
		 * */
		private function checkDep(evet:WalkEvent):void{
			var index:int = 0;
			var manK:Number   = 0;
			var leftK:Number  = 0;
			var rightK:Number = 0;
			var originPoint:Point;
			var useSlopeBool:Boolean = false;
			if(_buildLayer.hitTestObject(_player as DisplayObject)){
				for each(var bl:* in _buildLayer.buildingArray){
					if(bl is GameMapItem){
						if(bl.bitMap.hitTestObject(_player as DisplayObject)){
							
							if(bl.configXml.walkable.@left_k!=null && bl.configXml.walkable.@right_k!=null && bl.configXml.walkable.@origin_x!=null && bl.configXml.walkable.@origin_y){
								leftK = Number(bl.configXml.walkable.@left_k);
								rightK = Number(bl.configXml.walkable.@right_k);
							
								originPoint = new Point(Number(bl.configXml.walkable.@origin_x) + bl.x, Number(bl.configXml.walkable.@origin_y) + bl.y);
							
								manK = -(originPoint.y - _player.y)/(originPoint.x - _player.x);
								useSlopeBool = true;
								
							}else{
								useSlopeBool = false;
							}
							var playerDepth:int   = _buildLayer.getChildIndex(_player as DisplayObject);
							var buildingDepth:int = _buildLayer.getChildIndex(bl);
							
							if(_player.y < bl.y + bl.bitMap.height){
								
								if(useSlopeBool){
									if((manK < 0 && manK < leftK) || (manK > 0 && manK > rightK)){
										//建筑物遮挡人
										if( playerDepth > buildingDepth ){
											_buildLayer.addChildAt(_player, buildingDepth);
										}
									}else{
										//人物遮挡建筑物
										if(playerDepth < buildingDepth){
											_buildLayer.addChildAt(_player, buildingDepth + 1);
										}
									}
								}else{
									if( playerDepth > buildingDepth ){
										_buildLayer.addChildAt(_player, buildingDepth);
									}
								}
								
							}else{
								if(playerDepth < buildingDepth){
									_buildLayer.addChildAt(_player, buildingDepth + 1);
								}
							}
						}
	
					}
				}
			}
		}
		
		
		/**
		 * 获取地图单元格宽度	
		 * */
		public function get cellWidth():Number{
			return _cellWidth
		}
		/**
		 * 获取地图单元格的高度	
		 * */
		public function get cellHeight():Number{
			return _cellHeight
		}
		/**
		 * 获取地图宽度	
		 * */
		public function get mapWidth():Number{
			return _mapWidth
		}
		/**
		 * s获取地图高度	
		 * */
		public function get mapHeight():Number{
			return _mapHeight
		}
		/**
		 * 获取地图XML数据
		 * */
		public function get mapXML():XML{
			return _mapXML;
		}
		/**
		 * 获取地图层	
		 * */
		public function get mapLayer():MapLayer{
			return _mapLayer;
		}
		/**
		 * 获取玩家初始坐标	
		 * */
		public function get initPlayerPoint():Point{
			return _initPlayerPoint;
		}
		/**
		 * ss获取应用域	
		 * */
		public function get app():Application{
			return _app;
		}
	}
}