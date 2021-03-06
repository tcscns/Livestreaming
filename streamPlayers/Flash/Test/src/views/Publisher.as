package views
{
	import flash.display.Sprite;
	
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.Camera;
	import flash.media.CameraUI;
	import flash.media.H264Level;
	import flash.media.H264Profile;
	import flash.media.H264VideoStreamSettings;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	public class Publisher extends Sprite
	{
		
		private var metaText:TextField = new TextField();
		private var vid_outDescription:TextField = new TextField();
		private var vid_inDescription:TextField = new TextField();
		private var metaTextTitle:TextField = new TextField();
		
		private var nc:NetConnection;
		private var ns_out:NetStream;
		private var cam:Camera = Camera.getCamera();
		private var vid_out:Video;
		
		public function Publisher()
		{   
			initConnection();
		}
		
		private function initConnection():void
		{
			
			nc = new NetConnection();
			nc.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			nc.connect("rtmp://54.237.199.172/test");
			nc.client=this;
			vid_out = new Video();
		}
		
		
		protected function onNetStatus(event:NetStatusEvent):void
		{
			trace(event.info.code);
			
			if(event.info.code == "NetConnection.Connect.Success")
			{ 
				publishCamera(); 
			}
			else{
				
				//navigator.pushView(MyNewView);
			}
		}
		
		
		protected function publishCamera():void
		{
			
			ns_out = new NetStream(nc);
			
			var h264Settings:H264VideoStreamSettings = new H264VideoStreamSettings();
			h264Settings.setProfileLevel( H264Profile.BASELINE, H264Level.LEVEL_3_1 )
			cam.setQuality( 90000, 90 );
			cam.setMode( 320, 240, 30, true );
			cam.setKeyFrameInterval( 15 );
			ns_out.attachCamera(cam);
			ns_out.videoStreamSettings = h264Settings;
			ns_out.publish( "xyzstream" , "live");
			
		}
		
		public function onBWDone():void
		{
		}
	}
}