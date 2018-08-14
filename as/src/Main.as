package {
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.net.URLStream;
    import flash.utils.ByteArray;

    public class Main extends Sprite {
        private var l:URLLoader;
        private var ss:Array;
        private var cur:int;
        private var juanNum:int = 1;
        private var curImg:String;
        private var ll:URLStream = new URLStream();
        private var juanName:String;

        public function Main() {
            l = new URLLoader();
            l.dataFormat = URLLoaderDataFormat.TEXT;
            l.addEventListener(Event.COMPLETE, onLoad);
            l.load(new URLRequest("偷窥.txt"));
        }

        private function onLoad(event:Event):void {
            var s:String = l.data;
            ss = s.split("\n");
            trace(ss.length);
            cur = 0;
            this.curImg = this.ss[cur];
            var ns11:Array = curImg.split("/");
            this.juanName = ns11[ns11.length - 2];
            loadImg();
        }

        private function loadImg():void {
            trace("load", this.curImg);
            ll.addEventListener(Event.COMPLETE, onLoadImgComplete);
            ll.load(new URLRequest(this.curImg));
        }

        private function onLoadImgComplete(event:Event):void {
            var ba:ByteArray = new ByteArray();
            ll.readBytes(ba);
            save(this.juanName + "/" + juanNum, ba);
            if (cur + 1 >= ss.length) {
                return;
            }
            var next:String = ss[cur + 1];
            var ns:Array = next.split("/");
            var jj:String = ns[ns.length - 2];
            if (jj != this.juanName) {
                cur++;
                juanNum = 1;
                this.curImg = this.ss[cur];
                var ns11:Array = curImg.split("/");
                this.juanName = ns11[ns11.length - 2];
                loadImg();
                return;
            }
            cur++;
            juanNum++;
            this.curImg = this.ss[cur];
            loadImg();
        }

        private function save(size:String, png:ByteArray):void {
            var jj:File = new File(File.applicationDirectory.nativePath + "/" + size + ".png");
            trace(jj.nativePath);
            var aa:FileStream = new FileStream();
            aa.open(jj, FileMode.WRITE);
            aa.writeBytes(png);
            aa.close();
            png.clear();
        }
    }
}
