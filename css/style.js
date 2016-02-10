function resizeTableSize() {
	var tW1,tW2;

	// 画面の横幅のサイズ取得
	var sW = window.innerWidth;
	// 画面の縦幅のサイズ取得
	var sH = window.innerHeight;

	var stylesheet = document.styleSheets.item(0);

	if( sW > 1000 ) {
		// テーブルの横幅は画面サイズの左余白10pxと右余白10pxの残りすべてを割り当てる
		tW0 = sW - 10 - 10;

		// IDセルの横幅は100pxを割り当てる
		tW1 = 100;

		// itaセルの横幅は200pxを割り当てる
		tW2 = 200;

		// threadセルの横幅はIDセルの横幅(100px)とitaセルの横幅(200px)を除いた残りすべてを割り当てる
		tW3 = tW0 - 100 - 200;

		// 画面背景色を指定(#66ffcc)
		stylesheet.insertRule("body { background-color: #66ffcc; }",         stylesheet.cssRules.length);
	} else {
		// テーブルの横幅はIDセルの横幅(100px)とitaセルの横幅(200px)とthreadセルの横幅(700px)の横幅の合計1200pxを割り当てる
		tW0 = 100 + 200 + 700;

		// IDセルの横幅は100pxを割り当てる
		tW1 = 100;

		// itaセルの横幅は200pxを割り当てる
		tW2 = 200;

		// threadセルの横幅は700pxを割り当てる
		tW3 = 700;

		// 画面背景色を指定(#f8dce0)
		stylesheet.insertRule("body { background-color: #f8dce0; }",         stylesheet.cssRules.length);
	};

	stylesheet.insertRule("table.tablestyle { width: " + tW0 + "px; }",	stylesheet.cssRules.length);
	stylesheet.insertRule("th.id { width: " + tW1 + "px; }",								stylesheet.cssRules.length);
	stylesheet.insertRule("td.id { width: " + tW1 + "px; }",								stylesheet.cssRules.length);
	stylesheet.insertRule("th.ita { width: " + tW2 + "px; }",								stylesheet.cssRules.length);
	stylesheet.insertRule("td.ita { width: " + tW2 + "px; }",								stylesheet.cssRules.length);
	stylesheet.insertRule("th.thread { width: " + tW3 + "px; }",					stylesheet.cssRules.length);
	stylesheet.insertRule("td.thread { width: " + tW3 + "px; }",					stylesheet.cssRules.length);
	stylesheet.insertRule("div.textOverflow { width: " + tW3 + "px; }",	stylesheet.cssRules.length);

//  console.log(tW0 + " / " + tW1 + " / " + tW2 + " / " + tW3);
};

var resizeTimer;
var interval = Math.floor(1000 / 60 * 10);

window.addEventListener('resize', function (event) {
//  console.log('resizing');
  if (resizeTimer !== false) {
    clearTimeout(resizeTimer);
  }
  resizeTimer = setTimeout(function () {
//    console.log('resized');
		resizeTableSize();
  }, interval);
});
