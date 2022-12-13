# MD-88/MD-90 Engine System
# Joshua Davidson (Octal450)

#####################
# Initializing Vars #
#####################

var engines = props.globals.getNode("/engines").getChildren("engine");
var apu = props.globals.getNode("/systems/").getChildren("apu");
var n1_min = 23.1;
var n2_min = 57.7;
var egt_min = 323;
var n1_spin = 5.4;
var n2_spin = 26.8;
var n1_start = 26.5;
var n2_start = 59.9;
var egt_start = 524;
var n1_max = 106.2;
var n2_max = 101.4;
var egt_max = 860;
var n1_wm = 0;
var n2_wm = 0;
var apu_max = 99.8;
var apu_egt_max = 462;
var spinup_time = 15;
var start_time = 10;
var egt_lightup_time = 3;
var egt_lightdn_time = 7;
var shutdown_time = 20;
var egt_shutdown_time = 40;
var throttle0 = props.globals.getNode("controls/engines/engine[0]/throttle");
var throttle0_fdm = props.globals.getNode("controls/engines/engine[0]/throttle-fdm");
var throttle1 = props.globals.getNode("controls/engines/engine[1]/throttle");
var throttle1_fdm = props.globals.getNode("controls/engines/engine[1]/throttle-fdm");
setprop("/controls/engines/engine[0]/start-switch", 0);
setprop("/controls/engines/engine[1]/start-switch", 0);
setprop("/controls/engines/ignition", 0);
setprop("/controls/switches/apu-master", 0);
setprop("/controls/switches/apu-air", 0);
setprop("/systems/apu/rpm", 0);
setprop("/systems/apu/egt", 42);

setlistener("/sim/signals/fdm-initialized", func {
	engines[0].getNode("out-of-fuel", create=1).setBoolValue(1);
	engines[1].getNode("out-of-fuel", create=1).setBoolValue(1);
});

####################
# Start Engine One #
####################

setlistener("/controls/engines/engine[0]/start-switch", func {
	if ((getprop("/controls/engines/engine[0]/start-switch") == 1) and (getprop("/controls/engines/ignition") == 1) and (getprop("/controls/switches/apu-air") == 1) 
	and (getprop("/controls/pneumatic/engine[0]/bleed") == 1)) {
		setprop("/engines/engine[0]/state", 1);
		setprop("/controls/engines/engine[0]/starting", 1);
		interpolate(engines[0].getNode("n1-actual"), n1_spin, spinup_time);
		interpolate(engines[0].getNode("n2-actual"), n2_spin, spinup_time);
	} else if (getprop("/controls/engines/engine[0]/start-switch") == 0) {
		if (getprop("/engines/engine[0]/state") == 1) {
			eng_one_stop();
		}
	}
});

setlistener("/controls/engines/engine[0]/cutoff", func {
	if ((getprop("/controls/engines/engine[0]/cutoff") == 0) and (getprop("/controls/engines/engine[0]/starting") == 1)) {
		eng_one_startt.start();
	} else if (getprop("/controls/engines/engine[0]/cutoff") == 1) {
		if ((getprop("/engines/engine[0]/state") == 2) or (getprop("/engines/engine[0]/state") == 3)) {
			eng_one_stop();
		}
	}
});

var eng_one_start = func {
	if ((getprop("/controls/engines/engine[0]/cutoff") == 0) and (getprop("/controls/engines/engine[0]/starting") == 1) and (getprop("/engines/engine[0]/n2-actual") >= 23) 
	and ((getprop("/controls/fuel/switches/left-fwd") == 1) or (getprop("/controls/fuel/switches/left-aft") == 1)  or (getprop("/controls/fuel/switches/center-fwd") == 1) 
	or (getprop("/controls/fuel/switches/center-aft") == 1)) and (getprop("/systems/electrical/on") == 1)) {
		setprop("/engines/engine[0]/state", 2);
		interpolate(engines[0].getNode("n1-actual"), n1_start, start_time);
		interpolate(engines[0].getNode("n2-actual"), n2_start, start_time);
		interpolate(engines[0].getNode("egt-actual"), egt_start, egt_lightup_time);
		eng_one_n2_checkt.start();
		eng_one_startt.stop();
	}
}

var eng_one_n2_check = func {
	if (getprop("/engines/engine[0]/egt-actual") >= egt_start) {
		interpolate(engines[0].getNode("egt-actual"), egt_min, egt_lightdn_time);
	}
	if (getprop("/engines/engine[0]/n2-actual") >= 51) {
		setprop("/controls/engines/engine[0]/start-switch", 0);
		engines[0].getNode("out-of-fuel").setBoolValue(0);
		setprop("/controls/engines/engine[0]/starting", 0);
	}
	if (getprop("/engines/engine[0]/n2-actual") >= n2_start) {
		setprop("/engines/engine[0]/state", 3);
		throttle0_fdm.setValue(throttle0.getValue()*0.96+0.04);
		eng_one_n2_checkt.stop();
		eng_one_loopt.start();
	}
}

var eng_one_loop = func {
	if (getprop("/engines/engine[0]/state") == 3) {
		var e = engines[0];
		e.getNode("n1-actual").setValue(e.getNode("n1").getValue());
		e.getNode("n2-actual").setValue(e.getNode("n2").getValue());
	}
}

###################
# Stop Engine One #
###################

var eng_one_stop = func {
	setprop("/controls/engines/engine[0]/start-switch", 0);
	eng_one_startt.stop();
	eng_one_n2_checkt.stop();
	eng_one_loopt.stop();
	setprop("/engines/engine[0]/state", 4);
	interpolate(engines[0].getNode("n1-actual"), n1_wm, shutdown_time);
	interpolate(engines[0].getNode("n2-actual"), n2_wm, shutdown_time);
	interpolate(engines[0].getNode("egt-actual"), 42, egt_shutdown_time);
}

####################
# Start Engine Two #
####################

setlistener("/controls/engines/engine[1]/start-switch", func {
	if ((getprop("/controls/engines/engine[1]/start-switch") == 1) and (getprop("/controls/engines/ignition") == 1) and (getprop("/controls/switches/apu-air") == 1) 
	and (getprop("/controls/pneumatic/engine[1]/bleed") == 1)) {
		setprop("/engines/engine[1]/state", 1);
		setprop("/controls/engines/engine[1]/starting", 1);
		interpolate(engines[1].getNode("n1-actual"), 5.4, spinup_time);
		interpolate(engines[1].getNode("n2-actual"), 26.8, spinup_time);
	} else if (getprop("/controls/engines/engine[1]/start-switch") == 0) {
		if (getprop("/engines/engine[1]/state") == 1) {
			eng_two_stop();
		}
	}
});

setlistener("/controls/engines/engine[1]/cutoff", func {
	if ((getprop("/controls/engines/engine[1]/cutoff") == 0) and (getprop("/controls/engines/engine[1]/starting") == 1)) {
		eng_two_startt.start();
	} else if (getprop("/controls/engines/engine[1]/cutoff") == 1) {
		if ((getprop("/engines/engine[1]/state") == 2) or (getprop("/engines/engine[1]/state") == 3)) {
			eng_two_stop();
		}
	}
});

var eng_two_start = func {
	if ((getprop("/controls/engines/engine[1]/cutoff") == 0) and (getprop("/controls/engines/engine[1]/starting") == 1) and (getprop("/engines/engine[1]/n2-actual") >= 23) 
	and ((getprop("/controls/fuel/switches/right-fwd") == 1) or (getprop("/controls/fuel/switches/right-aft") == 1) or (getprop("/controls/fuel/switches/center-fwd") == 1) 
	or (getprop("/controls/fuel/switches/center-aft") == 1)) and (getprop("/systems/electrical/on") == 1)) {
		setprop("/engines/engine[1]/state", 2);
		interpolate(engines[1].getNode("n1-actual"), n1_start, start_time);
		interpolate(engines[1].getNode("n2-actual"), n2_start, start_time);
		interpolate(engines[1].getNode("egt-actual"), egt_start, egt_lightup_time);
		eng_two_n2_checkt.start();
		eng_two_startt.stop();
	}
}

var eng_two_n2_check = func {
	if (getprop("/engines/engine[1]/egt-actual") >= egt_start) {
		interpolate(engines[1].getNode("egt-actual"), egt_min, egt_lightdn_time);
	}
	if (getprop("/engines/engine[1]/n2-actual") >= 51) {
		setprop("/controls/engines/engine[1]/start-switch", 0);
		engines[1].getNode("out-of-fuel").setBoolValue(0);
		setprop("/controls/engines/engine[1]/starting", 0);
	}
	if (getprop("/engines/engine[1]/n2-actual") >= n2_start) {
		setprop("/engines/engine[1]/state", 3);
		throttle1_fdm.setValue(throttle1.getValue()*0.96+0.04);
		eng_two_n2_checkt.stop();
		eng_two_loopt.start();
	}
}

var eng_two_loop = func {
	if (getprop("/engines/engine[1]/state") == 3) {
		var e = engines[1];
		e.getNode("n1-actual").setValue(e.getNode("n1").getValue());
		e.getNode("n2-actual").setValue(e.getNode("n2").getValue());
	}
}

###################
# Stop Engine Two #
###################

var eng_two_stop = func {
	setprop("/controls/engines/engine[1]/start-switch", 0);
	eng_two_startt.stop();
	eng_two_n2_checkt.stop();
	eng_two_loopt.stop();
	setprop("/engines/engine[1]/state", 4);
	interpolate(engines[1].getNode("n1-actual"), n1_wm, shutdown_time);
	interpolate(engines[1].getNode("n2-actual"), n2_wm, shutdown_time);
	interpolate(engines[1].getNode("egt-actual"), 42, egt_shutdown_time);
}

#############
# Start APU #
#############

setlistener("/controls/switches/apu-master", func {
	if ((getprop("/controls/switches/apu-master") == 2) and ((getprop("/controls/fuel/switches/start-pump") == 1) or (getprop("/controls/fuel/switches/right-aft") == 1)) 
	and (getprop("/systems/electrical/on") == 1)) {
		interpolate(apu[0].getNode("rpm"), apu_max, spinup_time);
		interpolate(apu[0].getNode("egt"), apu_egt_max, spinup_time);
		apu_startt.start();
	} else if (getprop("/controls/switches/apu-master") == 0) {
		apu_stop();
	}
});

var apu_start = func {
	if (getprop("/systems/apu/rpm") >= 20) {
		setprop("/controls/switches/apu-master", 1);
		apu_startt.stop();
	}
}

############
# Stop APU #
############

var apu_stop = func {
	interpolate(apu[0].getNode("rpm"), 0, spinup_time);
	interpolate(apu[0].getNode("egt"), 42, spinup_time);
}

#######################
# Various other stuff #
#######################

setlistener("controls/engines/engine[0]/throttle", func {
  if (getprop("/engines/engine[0]/state") == 3) {
    throttle0_fdm.setValue(throttle0.getValue()*0.96+0.04);
  } else {
    setprop("controls/engines/engine[0]/throttle-fdm", 0);
  }
});
setlistener("controls/engines/engine[1]/throttle", func {
  if (getprop("/engines/engine[1]/state") == 3) {
    throttle1_fdm.setValue(throttle1.getValue()*0.96+0.04);
  } else {
    setprop("controls/engines/engine[1]/throttle-fdm", 0);
  }
});

setlistener("/controls/engines/ignition", func {
	if (getprop("/controls/engines/ignition") == 0) {
		if (getprop("/controls/engines/engine[0]/state") == 1) {
			eng_one_stop();
		}
		if (getprop("/controls/engines/engine[1]/state") == 1) {
			eng_two_stop();
		}
	}
});

# Timers
var eng_one_startt = maketimer(0.5, eng_one_start);
var eng_one_n2_checkt = maketimer(0.5, eng_one_n2_check);
var eng_one_loopt = maketimer(0, eng_one_loop);
var eng_two_startt = maketimer(0.5, eng_two_start);
var eng_two_n2_checkt = maketimer(0.5, eng_two_n2_check);
var eng_two_loopt = maketimer(0, eng_two_loop);
var apu_startt = maketimer(0, apu_start);
