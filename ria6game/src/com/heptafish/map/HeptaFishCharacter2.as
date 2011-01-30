/**
 *  Eb163 Flash RPG Webgame Framework
    @author eb163.com
    @email game@eb163.com
    @website www.eb163.com	
 * */
package com.heptafish.map
{
	import Manager.GameManager;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.system.Capabilities;
	/**
	 * 角色基础类	
	 * */
	public class HeptaFishCharacter2 extends HeptaFishCharacter
	{

		private var _moveToX:uint;
		/**
		 * 要移动去的坐标Y	
		 * */
		private var _moveToY:uint;
		/**
		 * 地图对应的节点大小	
		 * */
		private var _mapNodeSize:uint;
		/**
		 * 当前要移动去的横向索引坐标	
		 * */
		private var _angle:Number;
		/**
		 * 距离	
		 * */
		private var _distance:Number;
		/**
		 * 是否坐着	
		 * */
		private var _isSit:Boolean;
		/**
		 * 上一次的frameX	
		 * */
		private var _lastFrameX:int;
		/**
		 * 计算要播放的动画	
		 * */
		private var _dire:int;
		/**
		 * 是否需要重新判断遮挡	
		 * */
		private var _faceToScreen:Boolean;
		/**
		 * 关联的地图显示对象	
		 * */
		private var _mapScene:GameMap;
		private var _moveSpeed:int = 8;
		private var _filter:BitmapData;
		private var _rect:Rectangle;
		/**
		 * 构造函数	
		 * */
		public function HeptaFishCharacter2(pic:Bitmap,isMirror:Boolean = true ,row:int = 1,col:int = 1,beginIndex:int=0,endIndex:int=0,playDirection:int = 0,nowx:int = 0 ,nowy:int = 0,speed:Number = 0.27777,total:* = null,cx:Number = -1 , cy:Number = -1)
		{
//HeptaFishBitMapMC(pic:Bitmap = null,row:int = 1,col:int = 1,beginIndex:int=0,endIndex:int=0,playDirection:int = 0,nowx:int = 0 ,nowy:int = 0,speed:Number = 0.27777,total:* = null,cx:Number = -1 , cy:Number = -1) 
			super(pic,true,row,col,beginIndex,endIndex,playDirection,nowx,nowy,speed,total,cx,cy);
			_aimx = x;
			_aimy = y;
			_isMirror = isMirror;
			_filter = new BitmapData(this.width,this.height);
			_rect = new Rectangle(0,0,this.width,this.height);
			_filter.fillRect(_rect,  0xff0000ff);
		}

		/**
		 * 计算人物所在的第几个方向	
		 * */
		//听移5★核心
		override protected function onMove(event:Event):void
		{
			var __xspeed:Number = 10*Math.cos(_angle);
			var __yspeed:Number = 10*Math.sin(_angle);
			var __dx:Number = _aimx-x;
			var __dy:Number = _aimy-y;
			var __newDistance:Number = __dx*__dx+__dy*__dy;
			x += __xspeed/2;
			y += __yspeed/2;
			var mapXSpeed:Number = _mapScene.x - __xspeed/2;
			var mapYSpeed:Number = _mapScene.y - __yspeed/2;
			var __scX:Number = Capabilities.screenResolutionX;
			var __scY:Number = Capabilities.screenResolutionY;
			var bo1:Boolean=mapXSpeed < 0 ;
			var bo2:Boolean=mapXSpeed > -(_mapScene.mapWidth - __scX);
			var bo3:Boolean=x >= __scX/2;
			var bo4:Boolean=x <= _mapScene.mapWidth - __scX/2;
//			GameManager.trace("event.target.name："+event.target.name) ;
			var bo5:Boolean=event.target.name=="player";//是自已，不是其他人
			var bo6:Boolean=bo1 && bo2 && bo3 && bo4;// && bo5
			if(bo6)
			{
				_mapScene.x -= __xspeed/2;
			}
			if(bo5 && mapYSpeed < 0 && mapYSpeed > -(_mapScene.mapHeight - __scY) && y >= __scY/2 && y <= _mapScene.mapHeight - __scY/2)
			{
				_mapScene.y -= __yspeed/2;
			}
			if(__yspeed>0)
			{
				_faceToScreen = true;
			}
			else if(__yspeed<0)
			{
				_faceToScreen = false;
			}
			Debuger.STATIC_DEBUG_MSG = _mapScene.x + '_' + _mapScene.y;
			
			if(__newDistance<_speed*_speed || _distance<__newDistance)
			{
				x = _aimx;
				y = _aimy;
				stopCharacter();
				dispatch(WalkEvent,WalkEvent.WALK_END);
			}
			else
			{
				_distance = __newDistance;
				dispatch(WalkEvent,WalkEvent.ON_WALK);
			}
			_mapScene.mapLayer.checkLoad(new Point(this.x, this.y));
		}		
	}
}