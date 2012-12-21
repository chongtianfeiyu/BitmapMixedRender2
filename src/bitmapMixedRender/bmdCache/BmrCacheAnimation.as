package bitmapMixedRender.bmdCache 
{
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	/**
	 * 位图缓存动画
	 * @author Alex
	 */
	public class BmrCacheAnimation 
	{
		//链接
		private var _link:String;
		//总帧数
		private var _totalFrames:int;
		//帧时间
		private var _frameTime:uint;
		//真实帧字典
		private var _realFrameDict:Dictionary;
		//关键帧标签字典
		private var _frameLabelDict:Dictionary;
		
		public function BmrCacheAnimation(link:String, totalFrames:int = 0, frameTime:uint = 0, realFrameDict:Dictionary = null, frameLabelDict:Dictionary = null) 
		{
			//trace("BmrCacheAnimation()");
			//trace("link:" + link);
			_link = link;
			_totalFrames = totalFrames;
			//trace("_totalFrames:" + _totalFrames);
			_frameTime = frameTime;
			_realFrameDict = realFrameDict;
			_frameLabelDict = frameLabelDict;
		}
		
		/**
		 * 得到缓存帧内容
		 * @param	frame
		 * @return
		 */
		public function getCacheFrame(frame:int):BmrCacheFrame
		{
			//trace("BmrCacheAnimation/getCacheFrame()");
			//trace("frame:" + frame);
			return _realFrameDict[frame];
		}
		
		/**
		 * 根据帧数或者帧标签得到真实帧数
		 * @param	frame
		 * @return 0表示无此帧
		 */
		public function getFrameNum(frame:Object):int
		{
			if (frame is int)
			{
				return frame as int;
			}
			else
			{
				if (_frameLabelDict == null)
				{
					return 0;
				}
				var frameNum:int = int(_frameLabelDict[frame]);
				return frameNum;
			}
		}
		
		/**
		 * 清除
		 */
		public function dispose():void
		{
			//BmrCacheManager.getInstance().deleteCacheAnimation(_link);
			if (_realFrameDict != null)
			{
				for (var i:int = 1; i <= _totalFrames; i++) 
				{
					var frame:BmrCacheFrame = _realFrameDict[i];
					if (frame) 
					{
						frame.dispose();
					}
					delete _realFrameDict[i];
				}
				_realFrameDict = null;
			}
			if (_frameLabelDict != null) 
			{
				_frameLabelDict = null;
			}
		}
		
		//getter & setter
		public function get link():String 
		{
			return _link;
		}
		
		public function get totalFrames():int 
		{
			return _totalFrames;
		}
		
		public function get frameTime():uint 
		{
			return _frameTime;
		}
	}
}