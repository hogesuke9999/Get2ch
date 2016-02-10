function getWindowSize() {
	var tW1,tW2;

// 画面の横幅のサイズ取得
	var sW = window.innerWidth;
	// 画面の縦幅のサイズ取得
	var sH = window.innerHeight;

//	document.write("横 = " + sW + " / 高さ = " + sH + "<br>");

	var stylesheet = document.styleSheets.item(0);

	if( sW > 640 ) {
		// テーブルの横幅は画面サイズの左余白10pxと右余白10pxの残りすべてを割り当てる
		tW0 = sW - 10 - 10;

		// IDセルの横幅は200pxを割り当てる
		tW1 = 200;

		// subjectセルの横幅はテーブルサイズからIDセルの200pxを除いた残りすべてを割り当てる
		tW2 = tW0 - 200;

		// 画面背景色を指定(#66ffcc)
		stylesheet.insertRule("body { background-color: #66ffcc; }",         stylesheet.cssRules.length);
	} else {
		// テーブルの横幅はIDセルの横幅の200pxとsubjectセルの横幅の合計600pxを割り当てる
		tW0 = 600;

		// IDセルの横幅は200pxを割り当てる
		tW1 = 200;

		// subjectセルの横幅は200pxを割り当てる
		tW2 = 400;

		// 画面背景色を指定(#f8dce0)
		stylesheet.insertRule("body { background-color: #f8dce0; }",         stylesheet.cssRules.length);
	};

	stylesheet.insertRule("table.tablestyle { width: " + tW0 + "px; }", stylesheet.cssRules.length);
	stylesheet.insertRule("th.id { width: " + tW1 + "px; }",                stylesheet.cssRules.length);
	stylesheet.insertRule("td.id { width: " + tW1 + "px; }",                stylesheet.cssRules.length);
	stylesheet.insertRule("th.subject { width: " + tW2 + "px; }",         stylesheet.cssRules.length);
	stylesheet.insertRule("td.subject { width: " + tW2 + "px; }",         stylesheet.cssRules.length);
};

var resizeTimer;
var interval = Math.floor(1000 / 60 * 10);

window.addEventListener('resize', function (event) {
  console.log('resizing');
  if (resizeTimer !== false) {
    clearTimeout(resizeTimer);
  }
  resizeTimer = setTimeout(function () {
    console.log('resized');
		getWindowSize();
  }, interval);
});
