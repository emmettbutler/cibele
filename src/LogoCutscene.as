package
{
    import org.flixel.*;

    import flash.net.NetConnection;
    import flash.net.NetStream;
    import flash.media.Video;
    import flash.display.StageDisplayState;
    import flash.events.NetStatusEvent;

    public class LogoCutscene extends FlxState
    {
        public var videoStream:NetStream;
        public var spr:FlxSprite;
        public var video:Video;

        override public function create():void
        {
            FlxG.stage.displayState = StageDisplayState.FULL_SCREEN;

            var videoConnection:NetConnection = new NetConnection();
            videoConnection.connect(null);
            videoStream = new NetStream(videoConnection);
            videoStream.play("scooter.flv");
            videoStream.client = { onMetaData:function(obj:Object):void{} };
            videoStream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);

            var screenWidth:Number = FlxG.stage.fullScreenWidth;
            var screenHeight:Number = FlxG.stage.fullScreenHeight;
            var aspectRatio:Number = 360/288;
            var videoLetterboxWidth:Number = screenWidth/aspectRatio;

            video = new Video(videoLetterboxWidth, screenHeight);
            video.attachNetStream(videoStream);
            video.x = (screenWidth - videoLetterboxWidth) / 2;

            FlxG.stage.addChild(video);

            spr = new FlxSprite(300, 10);
            spr.makeGraphic(20, 20, 0xffff0000);
            add(spr);
        }

        override public function update():void {
        }

        private function netStatusHandler(evt:NetStatusEvent):void {
            if (evt.info.code == "NetStream.Play.Stop") {
                //videoStream.play("scooter.flv");  // loop
                FlxG.stage.removeChild(video);  // kill video
            }
        }
    }
}
