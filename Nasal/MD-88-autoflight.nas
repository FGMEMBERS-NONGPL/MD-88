# MD-88/MD-90 Autoflight system by Joshua Davidson(it0uchpods/411). License: Creative Commons "BY-NC-SA"

var ap_init = func {
	setprop("/controls/switches/ap_master", 0);
	setprop("/controls/switches/hdg", 1);
	setprop("/controls/switches/nav", 0);
	setprop("/controls/switches/loc", 0);
	setprop("/controls/switches/alt", 1);
	setprop("/controls/switches/vs", 0);
	setprop("/controls/switches/app", 0);
	ap_refresh();
	print("AUTOFLIGHT ... FINE!");
}

var hdg_master = func {
	var ap = getprop("/controls/switches/ap_master");
	var hdg = getprop("/controls/switches/hdg");
	if (hdg & ap) {
		setprop("/autopilot/locks/heading", "dg-heading-hold");
		print("AUTOFLIGHT MODE ... HDG");
	} else {
		return 0;
	}
}

var nav_master = func {
	var ap = getprop("/controls/switches/ap_master");
	var nav = getprop("/controls/switches/nav");
	if (nav & ap) {
		setprop("/autopilot/locks/heading", "true-heading-hold");
		print("AUTOFLIGHT MODE ... NAV");
	} else {
		return 0;
	}
}

var loc_master = func {
	var ap = getprop("/controls/switches/ap_master");
	var loc = getprop("/controls/switches/loc");
	if (loc & ap) {
		setprop("/autopilot/locks/heading", "nav1-hold");
		print("AUTOFLIGHT MODE ... LOC");
	} else {
		return 0;
	}
}

var alt_master = func {
	var ap = getprop("/controls/switches/ap_master");
	var alt = getprop("/controls/switches/alt");
	if (alt & ap) {
		setprop("/autopilot/locks/altitude", "altitude-hold");
		print("AUTOFLIGHT MODE ... ALT CAPT");
	} else {
		return 0;
	}
}

var vs_master = func {
	var ap = getprop("/controls/switches/ap_master");
	var vs = getprop("/controls/switches/vs");
	if (vs & ap) {
		setprop("/autopilot/locks/altitude", "vertical-speed-hold");
		print("AUTOFLIGHT MODE ... VS");
	} else {
		return 0;
	}
}

var app_master = func {
	var ap = getprop("/controls/switches/ap_master");
	var app = getprop("/controls/switches/app");
	if (app & ap) {
		setprop("/autopilot/locks/altitude", "gs1-hold");
		print("AUTOFLIGHT MODE ... APPR");
	} else {
		return 0;
	}
}

var ap_refresh = func {
	hdg_master();
	nav_master();
	loc_master();
	alt_master();
	vs_master();
	app_master();
}

var ap_off = func {
	var ap = getprop("/controls/switches/ap_master");
	setprop("/controls/switches/ap_master", 0);
	setprop("/autopilot/locks/heading", 0);
	setprop("/autopilot/locks/altitude", 0);
	hdg_master();
	nav_master();
	loc_master();
	alt_master();
	vs_master();
	app_master();
}