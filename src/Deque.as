package {
    public dynamic class Deque extends Array {
        public var maxSize:Number;

        public function Deque(max:Number=10, ...args) {
            this.maxSize = max;
            var n:uint = args.length
            if (n == 1 && (args[0] is Number)) {
                var dlen:Number = args[0];
                var ulen:uint = dlen;
                if (ulen != dlen) {
                    throw new RangeError("Array index is not a 32-bit unsigned integer ("+dlen+")");
                }
                length = ulen;
            } else {
                length = n;
                for (var i:int=0; i < n; i++) {
                    this[i] = args[i]
                }
            }
        }

        AS3 override function push(...args):uint {
            var res:uint = super.unshift.apply(this, args);
            if (this.length > this.maxSize) {
                super.pop.apply(this);
            }
            return res;
        }
    }
}
