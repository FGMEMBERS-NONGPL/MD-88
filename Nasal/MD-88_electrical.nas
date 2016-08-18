# Electrical system for MD-88/MD-90 by Joshua Davidson (it0uchpods/411).

var ELEC_UPDATE_PERIOD	= 1;					# A periodic update in secs
var STD_VOLTS_AC	= 115;						# Typical volts for a power source
var MIN_VOLTS_AC	= 115;						# Typical minimum voltage level for generic equipment
var STD_VOLTS_DC	= 28;						# Typical volts for a power source
var MIN_VOLTS_DC	= 25;						# Typical minimum voltage level for generic equipment
var STD_AMPS		= 0;						# Not used yet
var NUM_ENGINES		= 2;


									# Handy handles for DC source feed indices
var feed	= {	eng1	: 0,
			eng2	: 1,
			apu	: 2,
			batt	: 3,
			cart	: 4,
			rect1	: 5,
			rect2	: 6
		  };
var feed_status	= [0,0,0,0,0,0,0];					# For fast feed switch checking
var RECT_OFFSET = 5;							# Handy rectifier index offset

var elec_init = func {
	setprop("/controls/electrical/battery", 0);   # Set all the stuff I need
	setprop("/controls/electrical/ext/Lsw", 0);
	setprop("/controls/electrical/ext/Rsw", 0);
	setprop("/controls/electrical/emerpwr", 0);
	setprop("/controls/electrical/apu/Lsw", 0);
	setprop("/controls/electrical/apu/Rsw", 0);
	setprop("/controls/electrical/eng/Lsw", 1);
	setprop("/controls/electrical/eng/Rsw", 1);
	setprop("/systems/electrical/bus/dcL", 0);
	setprop("/systems/electrical/bus/dcR", 0);
	setprop("/systems/electrical/bus/acL", 0);
	setprop("/systems/electrical/bus/acR", 0);
	setprop("/systems/electrical/bus/genL", 0);
	setprop("/systems/electrical/bus/genR", 0);
}

var master_elec = func {
	var battery_on = getprop("/controls/electrical/battery");   # Define all the stuff I need
	var extpwr_on = getprop("/controls/switches/cart");
	var extL = getprop("/controls/electrical/ext/Lsw");
	var extR = getprop("/controls/electrical/ext/Rsw");
	var emerpwr_on = getprop("/controls/electrical/emerpwr");
	var rpmapu = getprop("/systems/apu/rpm");
	var apuL = getprop("/controls/electrical/apu/Lsw");
	var apuR = getprop("/controls/electrical/apu/Rsw");
	var engL = getprop("/controls/electrical/eng/Lsw");
	var engR = getprop("/controls/electrical/eng/Rsw");
	var stateL = getprop("/engines/engine[0]/state");
	var stateR = getprop("/engines/engine[1]/state");
	var dcbusL = getprop("/systems/electrical/bus/dcL");
	var dcbusR = getprop("/systems/electrical/bus/dcR");
	var acbusL = getprop("/systems/electrical/bus/acL");
	var acbusR = getprop("/systems/electrical/bus/acR");
	var Lgen = getprop("/systems/electrical/bus/genL");
	var Rgen = getprop("/systems/electrical/bus/genR");
	
	# Left bus yes?
	if (extpwr_on and extL) {
		setprop("/systems/electrical/bus/dcL", 28);
		setprop("/systems/electrical/bus/acL", 115);
		setprop("systems/electrical/outputs/efis", 25);	
	} else if (emerpwr_on) {
		setprop("/systems/electrical/bus/dcL", 28);
		setprop("/systems/electrical/bus/acL", 115);
		setprop("systems/electrical/outputs/efis", 25);	
	} else if (rpmapu >= 99 and apuL) {
		setprop("/systems/electrical/bus/dcL", 28);
		setprop("/systems/electrical/bus/acL", 115);
		setprop("systems/electrical/outputs/efis", 25);	
	} else if (stateL == 3 and engL) {
		setprop("/systems/electrical/bus/dcL", 28);
		setprop("/systems/electrical/bus/acL", 115);
		setprop("systems/electrical/outputs/efis", 25);	
	} else {
		setprop("/systems/electrical/bus/dcL", 0);
		setprop("/systems/electrical/bus/acL", 0);
		var dcR = getprop("/systems/electrical/bus/dcR");
		if (dcR <= 15) {
			setprop("systems/electrical/outputs/efis", 0);
		}
	}
	
	# Right bus yes?
	if (extpwr_on and extR) {
		setprop("/systems/electrical/bus/dcR", 28);
		setprop("/systems/electrical/bus/acR", 115);
		setprop("systems/electrical/outputs/efis", 25);	
	} else if (rpmapu >= 99 and apuR) {
		setprop("/systems/electrical/bus/dcR", 28);
		setprop("/systems/electrical/bus/acR", 115);
		setprop("systems/electrical/outputs/efis", 25);	
	} else if (stateR == 3 and engR) {
		setprop("/systems/electrical/bus/dcR", 28);
		setprop("/systems/electrical/bus/acR", 115);
		setprop("systems/electrical/outputs/efis", 25);	
	} else {
		setprop("/systems/electrical/bus/dcR", 0);
		setprop("/systems/electrical/bus/acR", 0);
		var dcL = getprop("/systems/electrical/bus/dcL");
		if (dcL <= 15) {
			setprop("systems/electrical/outputs/efis", 0);
		}
	}

}

setlistener("/controls/electrical/battery", func {
	var batt = getprop("/controls/electrical/battery");
	if (batt == 0) {
        setprop("systems/electrical/on", 0);
		ai_spin.setValue(0.2);
		aispin.stop();
	} else if (batt == 1) {
        setprop("systems/electrical/on", 1);
		aispin.start();
	}
});

var ai_spin	= props.globals.getNode("/instrumentation/attitude-indicator/spin");

var aispinfunc = func {
  ai_spin.setValue(1);
}

var aispin = maketimer(5, aispinfunc);

  
var update_electrical = func {
  master_elec();

  
  settimer(update_electrical,ELEC_UPDATE_PERIOD);			# Schedule next run
}


settimer(update_electrical, 2);						# Give a few seconds for vars to initialize