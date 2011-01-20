/**
 *  Eb163 Flash RPG Webgame Framework
    @author eb163.com
    @email game@eb163.com
    @website www.eb163.com
 * */

package com.heptafish.map
{
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	
	import mx.core.IUIComponent;
	import mx.managers.ISystemManager;
	/**
	 * 显示元件的基类
	 * */
	public class BaseDisplayObject extends Sprite implements IUIComponent
	{
		/**
		 * 构造函数
		 * */
		public function BaseDisplayObject()
		{
			super();
			addEventListener(Event.REMOVED,removedFun);
		}
		/**
		 * 重写alpha属性
		 * */
		override public function get alpha():Number
		{
			return super.alpha;
		}
		
		override public function set alpha(value:Number):void
		{
			super.alpha = value;
		}
		/**
		 * 获取基线位置
		 * */
		public function get baselinePosition():Number
		{
			return 0;
		}
		/**
		 * 重写height属性
		 * */
		override public function get height():Number
		{
			return super.height;
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
		}
		/**
		 * 获取位图缓存
		 * */
		override public function get cacheAsBitmap():Boolean
		{
			return super.cacheAsBitmap;
		}
		
		override public function set cacheAsBitmap(value:Boolean):void
		{
			super.cacheAsBitmap = value;
		}
		/**
		 * 重写mask属性
		 * */
		override public function get mask():DisplayObject
		{
			return super.mask;
		}
		
		override public function set mask(value:DisplayObject):void
		{
			super.mask = value;
		}
		/**
		 * 获取文档属性
		 * */
		public function get document():Object
		{
			return null;
		}
		
		/**
		 * 设置文档属性
		 * */
		public function set document(value:Object):void
		{
		}
		/**
		 * 获取可用状态
		 * */
		public function get enabled():Boolean
		{
			return false;
		}
		/**
		 * 设置可用状态
		 * */
		public function set enabled(value:Boolean):void
		{
		}
		/**
		 * 获取显示基元尺寸的高度
		 * */
		public function get measuredHeight():Number
		{
			return 0;
		}
		/**
		 * 取显示基元精确的高度
		 * */
		public function get explicitHeight():Number
		{
			return 0;
		}
		/**
		 * 置显示基元精确的高度
		 * */
		public function set explicitHeight(value:Number):void
		{
		}
		/**
		 * 获取显示基元精确高度最大值
		 * */
		public function get explicitMaxHeight():Number
		{
			return 0;
		}
		/**
		 * 获取显示基元尺寸宽度
		 * */
		public function get measuredWidth():Number
		{
			return 0;
		}
		/**
		 * 获取显示基元精确宽度最大值
		 * */
		public function get explicitMaxWidth():Number
		{
			return 0;
		}
		/**
		 * 获取显示基元精确高度最小值
		 * */
		public function get explicitMinHeight():Number
		{
			return 0;
		}
		/**
		 * 获了显示基元精确宽度最小值
		 * */
		public function get explicitMinWidth():Number
		{
			return 0;
		}
		/**
		 * 重写name属性
		 * */
		override public function get name():String
		{
			return super.name;
		}
		
		override public function set name(value:String):void
		{
			super.name = value;
		}
		/**
		 * 获取显示基元的精确宽度
		 * */
		public function get explicitWidth():Number
		{
			return 0;
		}
		/**
		 * 设置显示基元的精确宽度
		 * */
		public function set explicitWidth(value:Number):void
		{
		}
		/**
		 * 写parent属性
		 * */
		override public function get parent():DisplayObjectContainer
		{
			return super.parent;
		}
		/**
		 * 获取焦点面板
		 * */
		public function get focusPane():Sprite
		{
			return null;
		}
		/**
		 * 设置焦点面板
		 * */
		public function set focusPane(value:Sprite):void
		{
		}
		/**
		 * 重写scaleX属性
		 * */
		override public function get scaleX():Number
		{
			return super.scaleX;
		}
		
		override public function set scaleX(value:Number):void
		{
			super.scaleX = value;
		}
		/**
		 * 获取是否包含布局属性
		 * */
		public function get includeInLayout():Boolean
		{
			return false;
		}
		/**
		 * 设置是否包含布局属性
		 * */
		public function set includeInLayout(value:Boolean):void
		{
		}
		/**
		 * 获取是否弹出窗口出现属性
		 * */
		public function get isPopUp():Boolean
		{
			return false;
		}
		/**
		 * 设置是否弹出窗口出现属性
		 * */
		public function set isPopUp(value:Boolean):void
		{
		}
		/**
		 * 重写scaleYn属性
		 * */
		override public function get scaleY():Number
		{
			return super.scaleY;
		}
		
		override public function set scaleY(value:Number):void
		{
			super.scaleY = value;
		}
		/**
		 * 重写添加侦听器方法
		 * */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0.0, useWeakReference:Boolean=false):void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		/**
		 * 获取最大高度
		 * */
		public function get maxHeight():Number
		{
			return 0;
		}
		/**
		 *重写x属性
		 * */
		override public function get x():Number
		{
			return super.x;
		}
		
		override public function set x(value:Number):void
		{
			super.x = value;
		}
		/**
		 * 获取最大宽度
		 * */
		public function get maxWidth():Number
		{
			return 0;
		}
		/**
		 * 重写y属性
		 * */
		override public function get y():Number
		{
			return super.y;
		}
		
		override public function set y(value:Number):void
		{
			super.y = value;
		}
		/**
		 * 获取显示基元尺寸的最小高度
		 * */
		public function get measuredMinHeight():Number
		{
			return 0;
		}
		/**
		 * 设置显示基元尺寸的最小高度
		 * */
		public function set measuredMinHeight(value:Number):void
		{
		}
		/**
		 * 重写visible属性
		 * */
		override public function get visible():Boolean
		{
			return super.visible;
		}
		
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
		}
		/**
		 * 获取显示基元尺寸的最小宽度
		 * */
		public function get measuredMinWidth():Number
		{
			return 0;
		}
		/**
		 * 重写移出侦听器方法
		 * */
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			super.removeEventListener(type, listener, useCapture);
		}
		/**
		 * 重写width属性
		 * */
		override public function get width():Number
		{
			return super.width;
		}
		override public function set width(value:Number):void
		{
			super.width = value;
		}
		/**
		 * 设置显示基元尺寸的最小宽度
		 * */
		public function set measuredMinWidth(value:Number):void
		{
		}
		/**
		 * 获取显示基元的最小高度
		 * */
		public function get minHeight():Number
		{
			return 0;
		}
		
		/**
		 *移动显示基元
		 *
		 * @param x   移动目地的X坐标
		 * @param y   移动目地的y坐标
		 */
		public function move(x:Number, y:Number):void
		{
		}
		/**
		 * 重写调遣事件的方法
		 * */
		override public function dispatchEvent(event:Event):Boolean
		{
			return super.dispatchEvent(event);
		}
		/**	  
		 *获取显示基元最小宽度
		 */
		public function get minWidth():Number
		{
			return 0;
		}
		/**
		 * 获取所属元件
		 * */
		public function get owner():DisplayObjectContainer
		{
			return null;
		}
		/**
		 * 设置所属原件
		 * */
		public function set owner(value:DisplayObjectContainer):void
		{
		}
		/**
		 *设置真实大小
		 *
		 * @param newWidth   将要设置的属性宽度
		 * @param newHeight   将要设置的属性高度
		 */
		
		public function setActualSize(newWidth:Number, newHeight:Number):void
		{
		}
		/**
		 * 重写是否侦听事件方法
		 * */
		override public function hasEventListener(type:String):Boolean
		{
			return super.hasEventListener(type);
		}
		/**
		 * 获取高度百分数
		 * */
		public function get percentHeight():Number
		{
			return 0;
		}
		/**
		 * 设置高度百分数
		 * */
		public function set percentHeight(value:Number):void
		{
		}
		/**
		 * 获取宽度百分数
		 * */
		public function get percentWidth():Number
		{
			return 0;
		}
		/**
		 * 设置宽度百分数
		 * */
		public function set percentWidth(value:Number):void
		{
		}
		/**
		 * 获取系统管理器
		 * */
		public function get systemManager():ISystemManager
		{
			return null;
		}
		/**
		 * 设置系统管理器
		 * */
		public function set systemManager(value:ISystemManager):void
		{
		}
		/**
		 * 重写willTrgger属性
		 * */
		override public function willTrigger(type:String):Boolean
		{
			return super.willTrigger(type);
		}
		/**
		 * 重写opaqueBackground属性
		 * */
		override public function get opaqueBackground():Object
		{
			return super.opaqueBackground;
		}
		
		override public function set opaqueBackground(value:Object):void
		{
			super.opaqueBackground = value;
		}
		/**
		 * 重写scrollRect属性
		 * */
		override public function get scrollRect():Rectangle
		{
			return super.scrollRect;
		}
		
		override public function set scrollRect(value:Rectangle):void
		{
			super.scrollRect = value;
		}
		/**
		 * 获取补间动画属性集
		 * */
		public function get tweeningProperties():Array
		{
			return null;
		}
		/**
		 * 设置补间动画属性集
		 * */
		public function set tweeningProperties(value:Array):void
		{
		}
		/**
		 * 初始化显示基元
		 * */
		public function initialize():void
		{
		}
		/**
		 *改变父级显示对像
		 * */
		public function parentChanged(p:DisplayObjectContainer):void
		{
		}
		/**
		 * 获取显示基元标准宽度
		 * */
		public function getExplicitOrMeasuredWidth():Number
		{
			return 0;
		}
		/**
		 * 获取显示载元标准高度
		 * */
		public function getExplicitOrMeasuredHeight():Number
		{
			return 0;
		}
		/**
		 * 设置显示基元是否可视
		 * */
		public function setVisible(value:Boolean, noEvent:Boolean=false):void
		{
		}
		/**
		 * 是否有所属元件
		 * */
		public function owns(displayObject:DisplayObject):Boolean
		{
			return false;
		}
		
		/**
		 * 在被移除的时候 强制执行垃圾清理
		 * */
		protected function removedFun(evet:Event):void{
			HeptaFishGC.gc();
		}
		/**
		 * 传递一个事件
		 * */
		protected function dispatch(eventClass:Class,eventType:String,par:Object = null):void{
			var event:Event = new eventClass(eventType,par);
			this.dispatchEvent(event);
		}
		/**
		 * 读取中方法
		 * */
		protected function loadingHandler(evet:ProgressEvent):void{
			dispatchEvent(evet);
		}
		
		/**
		 * 读取错误
		 * */
		protected function ioErrorHandler(evet:IOErrorEvent):void{
			dispatchEvent(evet);
		}
	}
}