package {
    import org.flixel.*;

    import flash.net.NetConnection;
    import flash.net.NetStream;
    import flash.media.Video;
    import flash.events.NetStatusEvent;

    public class PlayVideoState extends FlxState {
        public var videoStream:NetStream;
        public var video:Video;
        public var endCallback:Function;

        public function PlayVideoState(filename:String, endCallback:Function) {
            this.loadVideo(filename);
            this.endCallback = endCallback;
        }

        public function loadVideo(filename:String):void {
            var videoConnection:NetConnection = new NetConnection();
            videoConnection.connect(null);
            videoStream = new NetStream(videoConnection);
            videoStream.play(filename);
            videoStream.client = { onMetaData:function(obj:Object):void{} };
            videoStream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);

            video = new Video(640, 480);
            video.attachNetStream(videoStream);

            FlxG.stage.addChild(video);
        }

        private function netStatusHandler(evt:NetStatusEvent):void {
            if (evt.info.code == "NetStream.Play.Stop") {
                FlxG.stage.removeChild(video);  // kill video
                this.endCallback();
            }
        }
    }
}
