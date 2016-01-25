getWindowSize();
function getWindowSize() {
	var sW,sH,s;
	sW = win dow.innerWidth;
	sH = window.innerHeight;
	s = \"横幅 = \" + sW + \" / 高さ = \" + sH;
	document.getElementById(\"WinSize\").innerHTML = s;
};
