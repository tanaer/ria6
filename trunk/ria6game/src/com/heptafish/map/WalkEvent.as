/**
 * Eb163 Flash RPG Webgame Framework
    @author eb163.com
    @email game@eb163.com
    @website www.eb163.com
 * */
package com.heptafish.map
{
	import flash.events.Event;
	
	public class WalkEvent extends Event
	{
		/**
		 * 定义WALK_START事件名称	
		 * */
		public static const WALK_START:String="walk_Start";
		/**
		 * 定义WALK_END事件名称	
		 * */
		public static const WALK_END:String = "walk_end";
		/**
		 * 定义ON_WALK事件名称	
		 * */
		public static const ON_WALK:String  = "on_walk";
		/**
		 * 路径数组
		 * */
		private var _pathArray:Array; 
		/**
		 * 地图节点长度
		 * */
		private var _mapNodeSize:uint; 
		/**
		 * 目的地X坐标
		 * */
		private var _moveToX:Number; 
		/**
		 * 地目的地Y坐标
		 * */
		private var _moveToY:Number;    
		/**
		 * 构结函数	
		 * */
		public function WalkEvent(type:String = null,par:Object = null) {
			super(type != null ? type : WALK_START);
		}
		/**
		 * 设置路径数组
		 * */
		public function set pathArray(pathArray:Array):void {
			_pathArray = pathArray;
		}
		/**
		 * 	获取路径路组
		 * */
		public function get pathArray():Array {
			return _pathArray;
		}
		/**
		 * 设置地图节点长度
		 * */
		public function set mapNodeSize(mapNodeSize:uint):void {
			_mapNodeSize = mapNodeSize;
		}
		/**
		 * 获取地图节点长度
		 * */
		public function get mapNodeSize():uint {
			return _mapNodeSize;
		}
		/**
		 * 设置目的地X坐标
		 * */
		public function set moveToX(moveToX:Number):void {
			_moveToX = moveToX;
		}
		/**
		 * 获取目的地X坐标
		 * */
		public function get moveToX():Number {
			return _moveToX;
		}
		/**
		 * 设置目的地Y坐标
		 * */
		public function set moveToY(moveToY:Number):void {
			_moveToY = moveToY;
		}
		/**
		 * 获取目的地Y坐标
		 * */
		public function get moveToY():Number {
			return _moveToY;
		}
	}
}