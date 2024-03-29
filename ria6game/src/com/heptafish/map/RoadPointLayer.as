package com.heptafish.map
{
	
	import flash.display.Shape;
	import flash.geom.Point;
	/**
	 * 路点层	
	 * */
	public class RoadPointLayer extends BaseDisplayObject
	{
		
		private var _cellWidth:Number;
		private var _cellHeight:Number;
		private var _childMap:HashMap;
		private var _map:GameMap;
		
		public function RoadPointLayer(map:GameMap)
		{
			_map = map;
			_cellWidth = map.cellWidth;
			_cellHeight = map.cellHeight;
			_childMap = new HashMap();
		}
		
		/**
		 * 根据类型画出单元格	
		 * */
		public function drawCell(xIndex:int,yIndex:int,cellType:int):void{
			
			var cellColor:Number;
			/**
			 * 如果是路点	
			 * */
			if(cellType == HetapFishGameConstant.MAPEDITOR_CELL_TYPE_ROAD){
				cellColor = 0x33FF33;
				/**
				 * 如果是障碍	
				 * */
			}else if(cellType == HetapFishGameConstant.MAPEDITOR_CELL_TYPE_HINDER){
				cellColor = 0xFF0033;
			}else{
				throw new Error("未知单元格类型！");
			}
			var p:Point = GameMapUtils.getPixelPoint(_cellWidth,_cellHeight,xIndex,yIndex);
			resetCell(xIndex,yIndex);
			
			var cell:Shape = new Shape();
			cell.graphics.beginFill(cellColor,0.5);
			cell.graphics.drawCircle(0,0,_cellHeight/4);
			cell.graphics.endFill();
			cell.x = p.x;
			cell.y = p.y;
			addChild(cell);
			var mapKey:String = xIndex + "," + yIndex;
			_childMap.put(mapKey,cell);
		}
		
		/**
		 * 将制定单元格设置为初始状	
		 * */
		public function resetCell(xIndex:int,yIndex:int):void{
			var mapKey:String = xIndex + "," + yIndex;
			var oldCell:* = _childMap.getValue(mapKey);
			if(oldCell!=null && oldCell.parent == this){
				removeChild(oldCell);
			}
		}
		
		/**
		 * 
		 * originPX, originPY	建筑物元点在地图坐标系中的像素坐标
		 * building				
		 * walkable 			是否可行走
		 */
		public function drawWalkableBuilding(building:GameMapItem, originPX:int, originPY:int, wb:Boolean):void
		{
			var walkableStr:String = building.configXml.walkable;
			var wa:Array = walkableStr.split(",");
			if (wa == null || wa.length < 2) return;
			var cellWidth:Number = _map.cellWidth;
			var cellHeight:Number = _map.cellHeight;
			var row:int = _map.mapHeight/cellHeight;
			var col:int = _map.mapWidth/cellWidth;
			var xtmp:int, ytmp:int;
			for (var i:int=0; i<wa.length; i+=2)
			{
				ytmp = originPY + int(wa[i+1]);
				xtmp = originPX + int(wa[i]);

				var pt:Point = GameMapUtils.getCellPoint(cellWidth, cellHeight, xtmp, ytmp);
				var tile:* = _childMap.getValue(pt.x + "," + pt.y);
				
				/**
				 *增加阻挡
				 * */
				if (wb == false)		
				{
					/**
					 * 如果原来不是阻挡，则画	
					 * */
					if (tile == null)	
					{
						drawCell(pt.x,pt.y,HetapFishGameConstant.MAPEDITOR_CELL_TYPE_HINDER);
					}
				}
				/**
				 * 删除阻挡	
				 * */
				else					
				{
					/**
					 * 如果原来不是阻挡	
					 * */
					if (tile != null)	
					{
						removeChild(tile);
					}
				}
			}

		}
		/**
		 * 打开时 先画出原来的障碍点	
		 * */
		public function drawArr(arr:Array,roadType:int):void{
			for(var iy:int=0;iy < arr.length;iy++){
				for(var ix:int=0;ix < arr[0].length;ix++){
					var cell:int = arr[iy][ix];
					if(roadType == HetapFishGameConstant.TYPE_SAVE_MAP_HINDER){
						if(cell == 0){
							drawCell(ix,iy,HetapFishGameConstant.MAPEDITOR_CELL_TYPE_ROAD);
						}
					}else if(roadType == HetapFishGameConstant.TYPE_SAVE_MAP_ROAD){
						if(cell == 1){
							drawCell(ix,iy,HetapFishGameConstant.MAPEDITOR_CELL_TYPE_HINDER);
						}
					}
				}
			}
		}
		/**
		 * 设置路点单元宽度	
		 * */
		public function set cellWidth(cellWidth:Number):void{
			this._cellWidth = cellWidth;
		}
		/**
		 * 获取路点单元宽度	
		 * */
		public function get cellWidth():Number{
			return this._cellWidth;
		}
		/**
		 * 设置路点单元高度	
		 * */
		public function set cellHeight(cellHeight:Number):void{
			this._cellHeight = cellHeight;
		}
		/**
		 * 获取路点单元高度	
		 * */
		public function get cellHeight():Number{
			return this._cellHeight;
		}
	}
}