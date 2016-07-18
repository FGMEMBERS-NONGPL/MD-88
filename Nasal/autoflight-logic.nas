# IT AUTOFLIGHT Logic by Joshua Davidson (it0uchpods/411).
# V2.11 Beta 2

var ap_logic_init = func {
	setprop("/controls/it2/ap_master", 0);
	setprop("/controls/it2/at_master", 0);
	setprop("/controls/it2/hdg", 1);
	setprop("/controls/it2/nav", 0);
	setprop("/controls/it2/loc", 0);
	setprop("/controls/it2/loc1", 0);
	setprop("/controls/it2/alt", 0);
	setprop("/controls/it2/vs", 0);
	setprop("/controls/it2/app", 0);
	setprop("/controls/it2/app1", 0);
	setprop("/controls/it2/altc", 0);
	setprop("/controls/it2/flch", 1);
	setprop("/controls/it2/vnav", 0);
	setprop("/controls/it2/land", 0);
	setprop("/controls/it2/aplatmode", 0);
	setprop("/controls/it2/aphldtrk", 0);
	setprop("/controls/it2/apvertmode", 3);
	setprop("/controls/it2/aphldtrk2", 0);
	setprop("/controls/it2/thr", 1);
	setprop("/controls/it2/idle", 0);
	setprop("/controls/it2/clb", 0);
	setprop("/controls/it2/apthrmode", 0);
	setprop("/controls/it2/apthrmode2", 0);
	print("IT-AUTOFLIGHT LOGIC ... OK!");
}

# AP Master System
setlistener("/controls/it2/ap_mastersw", func {
  var apmas = getprop("/controls/it2/ap_mastersw");
  if (apmas == 0) {
	setprop("/controls/it2/ap_master", 0);
    ap_off();
  } else if (apmas == 1) {
	setprop("/controls/it2/ap_master", 1);
    ap_refresh();
  }
});

# AFDS OVRD OFF
setlistener("/controls/it2/afds_ovrdsw", func {
	setprop("/controls/it2/ap_master", 0);
    ap_off();
	setprop("/controls/it2/at_master", 0);
    at_off();
});

# AT Master System
setlistener("/controls/it2/at_mastersw", func {
  var atmas = getprop("/controls/it2/at_mastersw");
  if (atmas == 0) {
	setprop("/controls/it2/at_master", 0);
    at_off();
  } else if (atmas == 1) {
	setprop("/controls/it2/at_master", 1);
    at_refresh();
  }
});

# Flight Director Master System
setlistener("/controls/it2/fd_mastersw", func {
  var fdmas = getprop("/controls/it2/fd_mastersw");
  if (fdmas == 0) {
	setprop("/controls/it2/fd_master", 0);
  } else if (fdmas == 1) {
	setprop("/controls/it2/fd_master", 0);  # Because FD is not yet implemented. Will be 1 later.
  }
});

# Master Lateral
setlistener("/controls/it2/aplatset", func {
  var latset = getprop("/controls/it2/aplatset");
  if (latset == 0) {
	setprop("/controls/it2/hdg", 1);
	setprop("/controls/it2/nav", 0);
	setprop("/controls/it2/loc", 0);
	setprop("/controls/it2/loc1", 0);
	setprop("/controls/it2/app", 0);
	setprop("/controls/it2/app1", 0);
	setprop("/controls/it2/aplatmode", 0);
	setprop("/controls/it2/aphldtrk", 0);
    hdg_master();
  } else if (latset == 1) {
	setprop("/controls/it2/hdg", 0);
	setprop("/controls/it2/nav", 1);
	setprop("/controls/it2/loc", 0);
	setprop("/controls/it2/loc1", 0);
	setprop("/controls/it2/app", 0);
	setprop("/controls/it2/app1", 0);
	setprop("/controls/it2/aplatmode", 1);
	setprop("/controls/it2/aphldtrk", 1);
    nav_master();
  } else if (latset == 2) {
	setprop("/instrumentation/nav/signal-quality-norm", 0);
	setprop("/controls/it2/hdg", 0);
	setprop("/controls/it2/nav", 0);
	setprop("/controls/it2/loc", 1);
	setprop("/controls/it2/loc1", 1);
	setprop("/controls/it2/apilsmode", 0);
  } else if (latset == 3) {
	setprop("/controls/it2/hdg", 1);
	setprop("/controls/it2/nav", 0);
	setprop("/controls/it2/loc", 0);
	setprop("/controls/it2/loc1", 0);
	setprop("/controls/it2/app", 0);
	setprop("/controls/it2/app1", 0);
	setprop("/controls/it2/aplatmode", 0);
	setprop("/controls/it2/aphldtrk", 0);
    var hdgnow = int(getprop("/orientation/heading-magnetic-deg")+0.5);
	setprop("/autopilot/settings/heading-bug-deg", hdgnow);
    hdg_master();
  }
});

# Master Vertical
setlistener("/controls/it2/apvertset", func {
  var vertset = getprop("/controls/it2/apvertset");
  if (vertset == 0) {
	setprop("/controls/it2/alt", 1);
	setprop("/controls/it2/vs", 0);
	setprop("/controls/it2/app", 0);
	setprop("/controls/it2/app1", 0);
	setprop("/controls/it2/altc", 0);
	setprop("/controls/it2/flch", 0);
	setprop("/controls/it2/apvertmode", 0);
	setprop("/controls/it2/aphldtrk2", 0);
	setprop("/controls/it2/apilsmode", 0);
    var altnow = int((getprop("/instrumentation/altimeter/indicated-altitude-ft")+50)/100)*100;
	setprop("/autopilot/settings/target-altitude-ft", altnow);
	setprop("/autopilot/settings/target-altitude-ft-actual", altnow);
	flchthrust();
    alt_master();
  } else if (vertset == 1) {
    var altinput = getprop("/autopilot/settings/target-altitude-ft");
	setprop("/autopilot/settings/target-altitude-ft-actual", altinput);
	setprop("/controls/it2/alt", 0);
	setprop("/controls/it2/vs", 1);
	setprop("/controls/it2/app", 0);
	setprop("/controls/it2/app1", 0);
	setprop("/controls/it2/altc", 0);
	setprop("/controls/it2/flch", 0);
	setprop("/controls/it2/apvertmode", 1);
	setprop("/controls/it2/aphldtrk2", 0);
	setprop("/controls/it2/apilsmode", 0);
	flchthrust();
    vs_master();
  } else if (vertset == 2) {
	setprop("/instrumentation/nav/signal-quality-norm", 0);
	setprop("/controls/it2/hdg", 0);
	setprop("/controls/it2/nav", 0);
	setprop("/controls/it2/loc", 1);
	setprop("/controls/it2/loc1", 1);
	setprop("/instrumentation/nav/gs-rate-of-climb", 0);
	setprop("/controls/it2/alt", 0);
	setprop("/controls/it2/vs", 0);
	setprop("/controls/it2/app", 1);
	setprop("/controls/it2/app1", 1);
	setprop("/controls/it2/altc", 0);
	setprop("/controls/it2/flch", 0);
	setprop("/controls/it2/apilsmode", 1);
  } else if (vertset == 3) {
	setprop("/controls/it2/alt", 0);
	setprop("/controls/it2/vs", 0);
	setprop("/controls/it2/altc", 1);
	setprop("/controls/it2/flch", 0);
	setprop("/controls/it2/apvertmode", 0);
	setprop("/controls/it2/aphldtrk2", 0);
    altcap_master();
  } else if (vertset == 4) {
    var altinput = getprop("/autopilot/settings/target-altitude-ft");
	setprop("/autopilot/settings/target-altitude-ft-actual", altinput);
	setprop("/controls/it2/alt", 0);
	setprop("/controls/it2/vs", 0);
	setprop("/controls/it2/app", 0);
	setprop("/controls/it2/app1", 0);
	setprop("/controls/it2/altc", 0);
	setprop("/controls/it2/flch", 1);
	setprop("/controls/it2/apvertmode", 4);
	setprop("/controls/it2/aphldtrk2", 2);
	setprop("/controls/it2/apilsmode", 0);
	flchtimer.start();
    flch_master();
  }
});

# Capture Logic
setlistener("/controls/it2/apvertmode", func {
  var vertm = getprop("/controls/it2/apvertmode");
	if (vertm == 1) {
      altcaptt.start();
    } else if (vertm == 4) {
      altcaptt.start();	
	} else {
	  altcaptt.stop();
    }
});

var altcapt = func {
  var calt = getprop("/instrumentation/altimeter/indicated-altitude-ft");
  var alt = getprop("/autopilot/settings/target-altitude-ft-actual");
  var dif = calt - alt;
  if (dif < 500 and dif > -500) {
    setprop("/controls/it2/apvertset", 3);
    setprop("/controls/it2/apthrmode2", 0);
  }
  var altinput = getprop("/autopilot/settings/target-altitude-ft");
  setprop("/autopilot/settings/target-altitude-ft-actual", altinput);
}

# FLCH Thrust Mode Selector
var flchthrust = func {
  var calt = getprop("/instrumentation/altimeter/indicated-altitude-ft");
  var alt = getprop("/autopilot/settings/target-altitude-ft-actual");
  var vertm = getprop("/controls/it2/apvertmode");
  if (vertm == 4) {
    if (calt < alt) {
	  setprop("/controls/it2/apthrmode2", 2);
    } else if (calt > alt) {
      setprop("/controls/it2/apthrmode2", 1);
    } else {
	  setprop("/controls/it2/apthrmode2", 0);
	  setprop("/controls/it2/apvertset", 3);
	}
  } else {
	setprop("/controls/it2/apthrmode2", 0);
	flchtimer.stop();
  }
}

# Thrust Modes
setlistener("/controls/it2/apthrmode2", func {
  var thrmode2 = getprop("/controls/it2/apthrmode2");
  if (thrmode2 == 0) {
	setprop("/controls/it2/thr", 1);
	setprop("/controls/it2/idle", 0);
	setprop("/controls/it2/clb", 0);
	thr_master();
  } else if (thrmode2 == 1) {
	setprop("/controls/it2/thr", 0);
	setprop("/controls/it2/idle", 1);
	setprop("/controls/it2/clb", 0);
	idle_master();
  } else if (thrmode2 == 2) {
	setprop("/controls/it2/thr", 0);
	setprop("/controls/it2/idle", 0);
	setprop("/controls/it2/clb", 1);
	clb_master();
  }
});

# Timers
var altcaptt = maketimer(0.5, altcapt);
var flchtimer = maketimer(0.5, flchthrust);