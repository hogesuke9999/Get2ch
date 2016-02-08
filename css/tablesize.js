function getWindowSize() {
	var sW,sH,s;
	var tW1,tW2;

	sW = window.innerWidth;
	sH = window.innerHeight;
	s = "横幅 = " + sW + " / 高さ = " + sH;
        document.write(s);
	document.write("<br>");
	if(sW > sH) {
		document.write("横長です");
	} else {
		document.write("縦長です");
	};

	tW1 = sW - 10 - 10;
	if( tW1 > 600 ) {
		tW2 = tW1 - 200;
	} else {
		tW2 = 400;
	};

	var stylesheet = document.styleSheets.item(0);
	stylesheet.insertRule("body { background-color: #66ffcc; }",         stylesheet.cssRules.length);
	stylesheet.insertRule("table.tablestyle { width: " + tW1 + "px; }",  stylesheet.cssRules.length);
	stylesheet.insertRule("th.id { width: 200px; }",                     stylesheet.cssRules.length);
	stylesheet.insertRule("th.subject { width: " + tW2 + "px; }",        stylesheet.cssRules.length);
	stylesheet.insertRule("td.id { width: 200px; }",                     stylesheet.cssRules.length);
	stylesheet.insertRule("td.subject { width: " + tW2 + "px; }",        stylesheet.cssRules.length);
};

function getAllStyleRule() {
	var styleSheets = document.styleSheets;
	var str = '';

	for (var i = 0; i < styleSheets.length; i++) {
		var styleSheet = styleSheets[i];
		var rules = styleSheet.rules || styleSheet.cssRules;
		str += "[" + styleSheet.href + "]\n";

		for (var j = 0; j < rules.length; j++) {
			var rule = rules[j];
			str += rule.selectorText + " {\n";
			str += rule.style.cssText + "\n";
			str += "}\n";
		}
	}

	return(str);
}
