# MD-88/MD-90 Lighting System
# Jonathan Redpath

#####################
# Initializing Vars #
#####################

var beacon = aircraft.light.new("/sim/model/lighting/beacon", [0.25, 1], "/controls/lighting/beacon");
var strobe = aircraft.light.new("/sim/model/lighting/strobe", [0.1, 1], "/controls/lighting/strobe");

var nav = props.globals.initNode("/sim/model/lighting/nav-lt", 0, "BOOL");
var strobe = props.globals.initNode("/controls/lighting/strobe", 0, "BOOL");
var postrobe = props.globals.initNode("/controls/lighting/pos-strobe", 0, "DOUBLE");

var floodL = props.globals.initNode("/sim/model/lighting/floodL", 0, "BOOL");
var floodR = props.globals.initNode("/sim/model/lighting/floodR", 0, "BOOL");
var floodLsw = props.globals.initNode("/controls/lighting/floodL", 0, "BOOL");
var floodRsw = props.globals.initNode("/controls/lighting/floodR", 0, "BOOL");

var floodNaclL = props.globals.initNode("/sim/model/lighting/floodNaclL", 0, "BOOL");
var floodNaclR = props.globals.initNode("/sim/model/lighting/floodNaclR", 0, "BOOL");
var floodWingL = props.globals.initNode("/sim/model/lighting/floodWingL", 0, "BOOL");
var floodWingR = props.globals.initNode("/sim/model/lighting/floodWingR", 0, "BOOL");
var floodNaclsw = props.globals.initNode("/controls/lighting/floodNacl", 0, "DOUBLE");

var landL = props.globals.initNode("/sim/model/lighting/landL", 0, "BOOL");
var landN = props.globals.initNode("/sim/model/lighting/landN", 0, "DOUBLE");
var landR = props.globals.initNode("/sim/model/lighting/landR", 0, "BOOL");
var landLsw = props.globals.initNode("/controls/lighting/landL", 0, "DOUBLE");
var landNsw = props.globals.initNode("/controls/lighting/landN", 0, "DOUBLE");
var landRsw = props.globals.initNode("/controls/lighting/landR", 0, "DOUBLE");

#############
# Listeners #
#############

setlistener("/controls/lighting/pos-strobe", func() {
	if (postrobe.getValue() == 0) {
		nav.setBoolValue(0);
		strobe.setBoolValue(0);
	} elsif (postrobe.getValue() == 0.5) {
		nav.setBoolValue(1);
		strobe.setBoolValue(0);
	} elsif (postrobe.getValue() == 1) {
		nav.setBoolValue(1);
		strobe.setBoolValue(1);
	}
}, 0, 0);

setlistener("/controls/lighting/floodL", func() {
	if (floodLsw.getValue() == 0) {
		floodL.setBoolValue(0);
	} else {
		floodL.setBoolValue(1);
	}
}, 0, 0);

setlistener("/controls/lighting/floodR", func() {
	if (floodRsw.getValue() == 0) {
		floodR.setBoolValue(0);
	} else {
		floodR.setBoolValue(1);
	}
}, 0, 0);

setlistener("/controls/lighting/floodNacl", func() {
	if (floodNaclsw.getValue() == 0) {
		floodNaclL.setBoolValue(0);
		floodNaclR.setBoolValue(0);
		floodWingL.setBoolValue(0);
		floodWingR.setBoolValue(0);
	} elsif (floodNaclsw.getValue() == 0.5) {
		floodNaclL.setBoolValue(1);
		floodNaclR.setBoolValue(1);
		floodWingL.setBoolValue(1);
		floodWingR.setBoolValue(1);
	} elsif (floodNaclsw.getValue() == 1) {
		floodNaclL.setBoolValue(0);
		floodNaclR.setBoolValue(1);
		floodWingL.setBoolValue(0);
		floodWingR.setBoolValue(1);
	}
}, 0, 0);

setlistener("/controls/lighting/landL", func() {
	if (landLsw.getValue() != 1) {
		landL.setDoubleValue(0);
		setprop("/controls/lighting/landing-left", 1); # not a bug
	} else {
		landL.setDoubleValue(1);
		setprop("/controls/lighting/landing-left", 0);
	}
}, 0, 0);

setlistener("/controls/lighting/landN", func() {
	if (landNsw.getValue() == 0) {
		landN.setDoubleValue(0);
		setprop("/sim/rendering/als-secondary-lights/use-landing-light", 0);
		setprop("controls/lighting/landing-lights", 0);
	} elsif (landNsw.getValue() == 0.5) {
		landN.setDoubleValue(0.5);
		setprop("/sim/rendering/als-secondary-lights/use-landing-light", 1);
		setprop("controls/lighting/landing-lights", 1);
	} elsif (landNsw.getValue() == 1) {
		landN.setDoubleValue(1);
		setprop("/sim/rendering/als-secondary-lights/use-landing-light", 1);
		setprop("controls/lighting/landing-lights", 1);
	}
}, 0, 0);

setlistener("/controls/lighting/landR", func() {
	if (landRsw.getValue() != 1) {
		landR.setDoubleValue(0);
		setprop("/controls/lighting/landing-right", 1); # not a bug
	} else {
		landR.setDoubleValue(1);
		setprop("/controls/lighting/landing-right", 0);
	}
}, 0, 0);

# Pass beacon timer over MP (aliasing the timer value
# doesn't seem to work, so a listener is used)
# Use MP var float[3]
var MD88_BeaconState	= props.globals.getNode("sim/model/lighting/beacon/state[0]", 1);
var MD88_MPBeaconState	= props.globals.getNode("/sim/multiplay/generic/float[3]", 1);
setlistener(MD88_BeaconState, func {
	if (MD88_BeaconState.getBoolValue()) {
		MD88_MPBeaconState.setValue(1);
	}
	else {
		MD88_MPBeaconState.setValue(0);
	}
}, 0, 0);

# Pass strobe timer over MP
# Use MP var float[12]
var MD88_StrobeState	= props.globals.getNode("sim/model/lighting/strobe/state[0]", 1);
var MD88_MPStrobeState	= props.globals.getNode("/sim/multiplay/generic/float[12]", 1);
setlistener(MD88_StrobeState, func {
	if (MD88_StrobeState.getBoolValue()) {
		MD88_MPStrobeState.setValue(1);
	}
	else {
		MD88_MPStrobeState.setValue(0);
	}
}, 0, 0);