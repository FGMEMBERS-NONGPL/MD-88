# Custom sounds like minimums, and approaching minimums, and so on.
# Joshua Davidson (it0uchpods/411)

var twentyfivehundred = func {
	var agl = getprop("/position/altitude-agl-ft");
	if (agl <= 2500) {
		setprop("/sounds/twentyfivehundred", 1);
	} else if (agl > 2500) {
		setprop("/sounds/twentyfivehundred", 0);
	}
}

var min = func {
	var agl = getprop("/position/altitude-agl-ft");
	var mins = getprop("/options/min-agl");
	if (agl <= mins) {
		setprop("/sounds/min", 1);
	} else if (agl > mins) {
		setprop("/sounds/min", 0);
	}
}

var appmin = func {
	var agl = getprop("/position/altitude-agl-ft");
	var mins = getprop("/options/min-agl");
	var appmins = mins+100;
	if (agl <= appmins) {
		setprop("/sounds/appmin", 1);
	} else if (agl > appmins) {
		setprop("/sounds/appmin", 0);
	}
}

setlistener("controls/flight/flaps", func {
	var flap = getprop("/
	controls/flight/flaps");
	if (flap >= 0.7) {
		twentyfivehundredt.start();
		mint.start();
		appmint.start();
	} else {
		twentyfivehundredt.stop();
		mint.stop();
		appmint.stop();
	}
});

# Timer
var twentyfivehundredt = maketimer(0.2, twentyfivehundred);
var mint = maketimer(0.2, min);
var appmint = maketimer(0.2, appmin);