/**
 *  Eb163 Flash RPG Webgame Framework
    @author eb163.com
    @email game@eb163.com
    @website www.eb163.com	
 * */
package com.heptafish.map
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.system.Capabilities;
	/**
	 * 角色基础类	
	 * */
	public class HeptaFishCharacter extends HeptaFishBitMapMC
	{
		public static const STAND:int = 0;
		public static const SIT:int = 1;
		public static const RUN:int = 2;
		public static const NOT_MIRROR:int = 1;
		public static const IS_MIRROR:int = -1;
		/**
		 * 当前坐标X
		 * */
		protected var _nowX:uint;
		/**
		 * 当前坐标Y	
		 * */
		protected var _nowY:uint;
		/**
		 * 当前索引X	
		 * */
		protected var _dirX:int;
		/**
		 * 当前索引Y	
		 * */
		protected var _dirY:int;
		/**
		 * 移动步数	
		 * */
		protected var _walkStep:uint;
		/**
		 * 要移动的数组	
		 * */
		protected var _walkArray:Array;
		/**
		 * 是否正在移动	
		 * */
		protected var _isWalk:Boolean;
		/**
		 * 扩展组件	
		 * */
		protected var _modules:Array = new Array();
		/**
		 * 当前移动的数组index	
		 * */
		protected var _walkIndex:int;
		/**
		 * 要移动去的坐标X
		 * */
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
		protected var _aimx:Number;
		/**
		 * 当前要移动去的纵向索引坐标	
		 * */
		protected var _aimy:Number;
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
		public function HeptaFishCharacter(pic:Bitmap,isMirror:Boolean = true ,row:int = 1,col:int = 1,beginIndex:int=0,endIndex:int=0,playDirection:int = 0,nowx:int = 0 ,nowy:int = 0,speed:Number = 0.27777,total:* = null,cx:Number = -1 , cy:Number = -1)
		{
			super(pic,row,col,beginIndex,endIndex,playDirection,nowx,nowy,speed,total,cx,cy);
			_aimx = x;
			_aimy = y;
			_isMirror = isMirror;
			_filter = new BitmapData(this.width,this.height);
			_rect = new Rectangle(0,0,this.width,this.height);
			_filter.fillRect(_rect,  0xff0000ff);
		}
		/**
		 * 移动事件的处理函数	
		 * */ 
		public function moveCharacter(evet:WalkEvent):void{
			if (_isWalk) {
				stopCharacter();
			}
			_walkArray = evet.pathArray;
			_walkIndex = 0;
			_isWalk=true;
			_moveToX = evet.moveToX;
			_moveToY = evet.moveToY;
			_mapNodeSize = evet.mapNodeSize;
			addEventListener(Event.ENTER_FRAME,onMove);
		}
		

		/**
		 * 人物移动的函数	
		 * */
		public function moveTo(moveToX:Number,moveToY:Number):void{
			_aimx = moveToX;
			_aimy = moveToY;
			
			/**
			 * 反正切：对边/临边=弧度	
			 * */
			_angle = Math.atan2(_aimy-y, _aimx-x);
			/**
			 * 距离=（当前要移动的Y坐标-人物地Y坐标）*（当前要移动的Y坐标-人物地Y坐标）+（当前要移动的x坐标-人物地x坐标）*（当前要移动的x坐标-人物地x坐标）	
			 * */
			_distance = (_aimy-y)*(_aimy-y)+(_aimx-x)*(_aimx-x);
			/**
			 * 是否坐着=假	
			 * */
			_isSit = false;
			/**
			 * 计算人物所在的第几个方向	
			 * */
			_dire = Math.round((_angle+Math.PI)/(Math.PI/4));
			_dire = _dire>5 ? _dire-6 : _dire+2;
			if(_isMirror){
				if(_dire>4){
					_dire = _dire == 5 ? 3 : _dire == 6 ? 2 : 1;
					mirror(IS_MIRROR);
				}else{
					mirror(NOT_MIRROR);
				}
			}
			nowIndex = _dire;
			this.startMove(nowIndex);
			
			addEventListener(Event.ENTER_FRAME,onMove);
		}
		/**
		 * 计算人物所在的第几个方向	
		 * */
		protected function onMove(evet:Event):void{
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
			if(mapXSpeed < 0 && mapXSpeed > -(_mapScene.mapWidth - __scX) && x >= __scX/2 && x <= _mapScene.mapWidth - __scX/2){
				_mapScene.x -= __xspeed/2;
			}
			if(mapYSpeed < 0 && mapYSpeed > -(_mapScene.mapHeight - __scY) && y >= __scY/2 && y <= _mapScene.mapHeight - __scY/2){
				_mapScene.y -= __yspeed/2;
			}
			if(__yspeed>0){
				_faceToScreen = true;
			}else if(__yspeed<0){
				_faceToScreen = false;
			}
			Debuger.STATIC_DEBUG_MSG = _mapScene.x + '_' + _mapScene.y;
			
			if(__newDistance<_speed*_speed || _distance<__newDistance){
				x = _aimx;
				y = _aimy;
				stopCharacter();
				dispatch(WalkEvent,WalkEvent.WALK_END);
			}else{
				_distance = __newDistance;
				dispatch(WalkEvent,WalkEvent.ON_WALK);
			}
			
			
			_mapScene.mapLayer.checkLoad(new Point(this.x, this.y));
		}
		/**
		 * 停止人物	
		 * */
		public function stopCharacter():void{
			removeEventListener(Event.ENTER_FRAME,onMove);
			stopMove();
		}
		
		/**
		 * 获取移动目标的X坐标	
		 * */
		public function get moveToX():Number{
			return this._moveToX;
		}
		/**
		 * 获取移动目标的y坐标	
		 * */
		public function get moveToY():Number{
			return this._moveToY;
		}
		/**
		 * 设置移动目标的X坐标	
		 * */
		public function set moveToX(moveToX:Number):void{
			this._moveToX = moveToX;
		}
		/**
		 * 设置移动目标的y坐标	
		 * */
		public function set moveToY(moveToY:Number):void{
			this._moveToY = moveToY;
			
		}
		/**
		 * 设置当前的地图	
		 * */
		public function set mapEle(map:GameMap):void{
			_mapScene = map;
		}
		/**
		 * 获取是否重新判断遮挡	
		 * */
		public function get faceToscreen():Boolean{
			return _faceToScreen;
		}
		/**
		 * 获取人物的矩形轮廓	
		 * */
		public function get rect():Rectangle{
			return _rect;
		}
		/**
		 * 获取位图数据	
		 * */
		public function get filter():BitmapData{
			return _filter;
		}
		
		/**
		 * 获取位图数据	
		 * */
		private function moveMap(__xspeed:Number,__yspeed:Number):void{
		}
		
		
		
	}
}