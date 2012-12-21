package bitmapMixedRender.display 
{
	import bitmapMixedRender.bmdCache.BmrCacheAnimation;
	import bitmapMixedRender.bmdCache.BmrCacheFrame;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * 位图动画类
	 * @author Alex
	 */
	public class BmrAnimation extends Sprite 
	{
		//位图缓存动画
		protected var _cacheAnimation:BmrCacheAnimation;
		//当前位图缓存帧
		protected var _curCacheFrame:BmrCacheFrame;
		//protected var _curCacheFrameIndex:uint = uint.MAX_VALUE;
		//显示位图对象
		protected var _bmrBitmap:Bitmap;
		
		protected var _renderTimer:Timer;
		
		public function BmrAnimation(cacheAnimation:BmrCacheAnimation = null, smoothing:Boolean = false)
		{
			super();
			_cacheAnimation = cacheAnimation;
			if (_cacheAnimation) 
			{
				//_totalFrames = _cacheAnimation.realFrames.length;
				_totalFrames = _cacheAnimation.totalFrames;
				
				_bmrBitmap = new Bitmap();
				_bmrBitmap.smoothing = smoothing;
				this.addChild(_bmrBitmap);
				_bmrBitmap.bitmapData = null;
				
				//BmrAnimaionManager.getInstance().add(this);
				_currentFrame = 1;
				
				updateFrame();
				
				_renderTimer = new Timer(_cacheAnimation.frameTime);
				_renderTimer.addEventListener(TimerEvent.TIMER, renderTimer_timer);
			}
			
			this.mouseChildren = false;
			this.mouseEnabled = false;
		}
		
		private function renderTimer_timer(e:TimerEvent):void 
		{
			updateFrame();
		}
		
		/**
		 * 更新帧
		 */
		public function updateFrame():void
		{
			//trace("updateFrame()");
			if (_cacheAnimation == null) 
			{
				return;
			}
			if (_isPlay)
			{
				if (_currentFrame < _totalFrames) 
				{
					_currentFrame++;
				}
				else 
				{
					_currentFrame = 1;
				}
			}
			render();
		}
		
		/**
		 * 渲染
		 */
		protected function render():void
		{
			if (_cacheAnimation == null) 
			{
				return;
			}
			//trace("render()");
			//trace("_currentFrame:" + _currentFrame);
			//var newCacheFrame:BmrCacheFrame = _cacheAnimation.realFrames[_currentFrame-1];
			//var newCacheFrameIndex:uint = _cacheAnimation.realFrameIndexs[_currentFrame-1];
			var newCacheFrame:BmrCacheFrame = _cacheAnimation.getCacheFrame(_currentFrame);
			if (newCacheFrame == null) 
			{
				trace("newCacheFrame == null");
			}
			if (_curCacheFrame != newCacheFrame)
			//if (_curCacheFrameIndex != newCacheFrameIndex)
			{
				_curCacheFrame = newCacheFrame;
				//_curCacheFrameIndex = newCacheFrameIndex;
				//var _curCacheFrame:BmrCacheFrame = _cacheAnimation.cacheFrames[_curCacheFrameIndex];
				if (_curCacheFrame == null)
				{
					return;
				}
				if (_curCacheFrame && _curCacheFrame.sourceBitmapData) 
				{
					_bmrBitmap.bitmapData = _curCacheFrame.sourceBitmapData;
					_bmrBitmap.x = _curCacheFrame.offsetX;
					_bmrBitmap.y = _curCacheFrame.offsetY;
				}
				else 
				{
					_bmrBitmap.bitmapData = null;
				}
				
			}
		}
		
		//更新播放状态
		protected function updatePlayStatus():void
		{
			if (_cacheAnimation == null) 
			{
				return;
			}
			//trace("updatePlayStatus()");
			//trace("_isPlay:" + _isPlay);
			if (_isPlay)
			{
				if (!_renderTimer.running) 
				{
					_renderTimer.start();
				}
			}
			else
			{
				if (_renderTimer.running) 
				{
					_renderTimer.stop();
				}
			}
		}
		
		/**
		 * 清除
		 */
		public function dispose():void
		{
			if (_renderTimer) 
			{
				_renderTimer.removeEventListener(TimerEvent.TIMER, renderTimer_timer);
				_renderTimer.stop();
				_renderTimer = null;
			}
			_bmrBitmap = null;
			while (numChildren > 0) 
			{
				removeChildAt(0);
			}
			_cacheAnimation = null;
		}
		
		/**
		 * 套用MovieClip的API
		 */
		protected var _totalFrames:int;
		protected var _currentFrame:int;
		protected var _isPlay:Boolean;
		
		public function get currentFrame():int 
		{
			return _currentFrame;
		}
		
		public function get totalFrames():int
		{
			return _totalFrames;
		}
		
		public function get isPlay():Boolean 
		{ 
			return _isPlay; 
		}
		
		//public function gotoAndPlay(frame:int):void
		public function gotoAndPlay(frame:Object):void
		{
			var frameNum:int = _cacheAnimation.getFrameNum(frame);
			if (frameNum < 1 || frameNum > _totalFrames)
			{
				return;
			}
			_currentFrame = frameNum;
			_isPlay = true;
			updatePlayStatus();
		}
		//public function gotoAndStop(frame:int):void
		public function gotoAndStop(frame:Object):void
		{
			var frameNum:int = _cacheAnimation.getFrameNum(frame);
			if (frameNum < 1 || frameNum > _totalFrames) 
			{
				return;
			}
			_currentFrame = frameNum;
			_isPlay = false;
			updatePlayStatus();
		}
		public function nextFrame():void
		{
			if (_currentFrame < _totalFrames) 
			{
				_currentFrame++;
			}
			else 
			{
				_currentFrame = 1;
			}
			_isPlay = false;
			updatePlayStatus();
		}
		public function play():void
		{
			_isPlay = true;
			updatePlayStatus();
		}
		public function prevFrame():void
		{
			if (_currentFrame > 1) 
			{
				_currentFrame--;
			}
			else 
			{
				_currentFrame = _totalFrames;
			}
			_isPlay = false;
			updatePlayStatus();
		}
		public function stop():void
		{
			_isPlay = false;
			updatePlayStatus();
		}
	}
}