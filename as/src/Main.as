package {

import com.adobe.images.JPGEncoder;
import com.adobe.images.PNGEncoder;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.system.JPEGLoaderContext;
import flash.text.TextField;
import flash.utils.ByteArray;

import mx.graphics.codec.JPEGEncoder;

public class Main extends Sprite {
    private var l:URLLoader;
    private var ss:Array;
    private var cur:int;
    private var curImg:String;
    private var ll:Loader;
    private var bmps:Array = [];
    private var juanName:String;

    public function Main() {
        l = new URLLoader();
        l.dataFormat = URLLoaderDataFormat.TEXT;
        l.addEventListener(Event.COMPLETE, onLoad);
        l.load(new URLRequest("hmate.txt"));
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
        ll = new Loader();
        ll.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadImgComplete);
        ll.load(new URLRequest(this.curImg));
    }

    private function onLoadImgComplete(event:Event):void {
        this.bmps.push(Bitmap(ll.content).bitmapData);
        if (cur + 1 >= ss.length) {
            mergeImg();
            return;
        }
        var next:String = ss[cur + 1];
        var ns:Array = next.split("/");
        var jj:String = ns[ns.length - 2];
        if (jj != this.juanName) {
            mergeImg();
            cur++;
            this.curImg = this.ss[cur];
            var ns11:Array = curImg.split("/");
            this.juanName = ns11[ns11.length - 2];
            this.bmps = [];
            loadImg();
            return;
        }
        cur++;
        loadImg();
    }

    private function mergeImg():void {
        trace("merge", this.bmps.length)
        var h = 0;
        var w = bmps[0].width;
        for (var i:int = 0; i < bmps.length; i++) {
            var bmp:BitmapData = bmps[i];
            h += bmp.height;
        }
        var bmd = new BitmapData(w, h);
        var hh = 0;
        for (var j:int = 0; j < bmps.length; j++) {
            var bmp1:BitmapData = bmps[j];
            bmd.copyPixels(bmp1, new Rectangle(0, 0, bmp1.width, bmp1.height), new Point(0, hh));
            hh += bmp1.height;
        }

        savePng(bmd, new Rectangle(0, 0, bmd.width, bmd.height));
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

    private function savePng(bmd:BitmapData, rect:Rectangle):void {
//        var png:ByteArray=PNGEncoder.encode(bmd)
        var png:ByteArray=new JPEGEncoder().encode(bmd)
        save(this.juanName, png);
    }
}
}
