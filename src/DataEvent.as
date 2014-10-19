package {
    import flash.events.Event;

    public class DataEvent extends Event {
        public var userData:Object;

        public function DataEvent(type:String, userData:Object, bubbles:Boolean=false,
                                  cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
            this.userData = userData;
        }

        public override function clone():Event {
            return new DataEvent(type, userData, bubbles, cancelable);
        }
    }
}
