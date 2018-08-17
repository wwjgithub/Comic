var http = require('http');
var cheerio = require('cheerio');
var mulu=[]
var curJuan = 1;
var totalJuan=0;
var curComic="0";
function parseHtml(html) {
    //写法和jQuery一模一样，有没有觉得很cool
    var reg = new RegExp("\<script(.*?)\>(.*?)\<\/script\>", "i");

    if (reg.test(html)) {
        const ss = RegExp.$2
        var reg1 = new RegExp(".*?\"(.*?)\".*$", "i");
        if (reg1.test(ss)) {
            let img = (RegExp.$1);
            var ims = img.split('|');
            for (let i = 0; i < ims.length; i++) {
                let sss='http://98.94201314.net/dm01' + ims[i];
                console.log(sss);
            }
        }
    }
    if (curJuan > totalJuan) {
        return;
    }
    curJuan++;
    loadCurPage();
}

function loadCurPage() {
    http.get(mulu[curJuan-1], function (res) {
        var html = '';
        res.on('data', function (data) {
            html += data;
        });
        res.on('end', function () {
            parseHtml(html)
        });
        res.on('error',function () {
            console.log("end"+curJuan+"==="+totalJuan);
        })
    });
}

function parseMulu(s) {
    //cVolList
    //cheerio.
    const $ = cheerio.load(s);

    let ms = $('.cVolList a');
    for (let i = 0; i < ms.length; i++) {
        const m = ms[i];
        let jm='http://99.hhxxee.com/'+m.attribs.href;
        mulu.push(jm+ "/?p=" + curJuan + "&s=1");
    }
    totalJuan=ms.length;
    curJuan=1;
    loadCurPage()
}

function readMulu(url,comic) {
    curComic=comic;
    http.get(url+comic, function (res) {
        var html = '';
        res.on('data', function (data) {
            html += data;
        });
        res.on('end', function () {
            parseMulu(html)

        });
    });
}
//秋色之空舊版
readMulu('http://99.hhxxee.com/comic/','998492/');
//9933213
//9934058
//998525