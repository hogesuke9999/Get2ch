function getWindowSize() {
	var sW,sH,s;
	sW = window.innerWidth;
	sH = window.innerHeight;
	s = "横幅 = " + sW + " / 高さ = " + sH;
        document.write(s);
	document.write("<br>");
	if(sW > sH) {
		document.write("横長です");

		var stylesheet = document.styleSheets.item(0);
		stylesheet.insertRule("
			body { background-color: #66ffcc; }
			th.id {width: 200px; }
			th.subject {width: 400px; }
			td.id { width: 200px; }
			td.subject { width: 400px; }
		", stylesheet.cssRules.length);
	} else {
		document.write("縦長です");

		var stylesheet = document.styleSheets.item(0);
		stylesheet.insertRule("
			body { background-color: #f8dce0; }
			th.id {width: 200px; }
			th.subject {width: 400px; }
			td.id { width: 200px; }
			td.subject { width: 400px; }
		", stylesheet.cssRules.length);
	};
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
