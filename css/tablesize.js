function getWindowSize() {
	var sW,sH,s;
	sW = window.innerWidth;
	sH = window.innerHeight;
	s = "横幅 = " + sW + " / 高さ = " + sH;
        document.write(s);
	if(sW > sH) {
		document.write("横長です");
	} else {
		document.write("縦長です");
	}
};
