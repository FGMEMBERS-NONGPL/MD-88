# IT AUTOFLIGHT System Controller V3.2.5
# Copyright (c) 2019 Joshua Davidson (it0uchpods)
# This program is 100% GPL!

var trueSpeedKts = 0;
var locdefl = 0;
var locdefl_b = 0;
var signal = 0;
var signal_b = 0;
var bank_limit_sw = 0;
var gnds_mps = 0;
var current_course = 0;
var wp_fly_from = 0;
var wp_fly_to = 0;
var next_course = 0;
var max_bank_limit = 0;
var delta_angle = 0;
var max_bank = 0;
var radius = 0;
var time = 0;
var delta_angle_rad = 0;
var R = 0;
var dist_coeff = 0;
var turn_dist = 0;
var vsnow = 0;
var fpanow = 0;
var altinput = 0;
var rollKp = 0;
var pitchKp = 0;
var hdgKp = 0;
setprop("/it-autoflight/internal/heading-deg", 0);
setprop("/it-autoflight/internal/track-deg", 0);
setprop("/it-autoflight/internal/vert-speed-fpm", 0);
setprop("/it-autoflight/internal/heading-predicted", 0);
setprop("/it-autoflight/internal/altitude-predicted", 0);
setprop("/it-autoflight/config/tuning-mode", 0);

var ap_init = func {
	setprop("/it-autoflight/input/kts-mach", 0);
	setprop("/it-autoflight/input/ap1", 0);
	setprop("/it-autoflight/input/ap2", 0);
	setprop("/it-autoflight/input/athr", 0);
	setprop("/it-autoflight/input/fd1", 0);
	setprop("/it-autoflight/input/fd2", 0);
	setprop("/it-autoflight/input/hdg", 360);
	setprop("/it-autoflight/input/alt", 10000);
	setprop("/it-autoflight/input/vs", 0);
	setprop("/it-autoflight/input/fpa", 0);
	setprop("/it-autoflight/input/lat", 5);
	setprop("/it-autoflight/input/lat-arm", 0);
	setprop("/it-autoflight/input/vert", 7);
	setprop("/it-autoflight/input/trk", 0);
	setprop("/it-autoflight/input/true-course", 0);
	setprop("/it-autoflight/input/toga", 0);
	setprop("/it-autoflight/input/bank-limit-sw", 0);
	setprop("/it-autoflight/output/ap1", 0);
	setprop("/it-autoflight/output/ap2", 0);
	setprop("/it-autoflight/output/athr", 0);
	setprop("/it-autoflight/output/fd1", 0);
	setprop("/it-autoflight/output/fd2", 0);
	setprop("/it-autoflight/output/loc-armed", 0);
	setprop("/it-autoflight/output/appr-armed", 0);
	setprop("/it-autoflight/output/thr-mode", 2);
	setprop("/it-autoflight/output/lat", 5);
	setprop("/it-autoflight/output/vert", 7);
	setprop("/it-autoflight/settings/use-nav2-radio", 0);
	setprop("/it-autoflight/internal/min-vs", -500);
	setprop("/it-autoflight/internal/max-vs", 500);
	setprop("/it-autoflight/internal/bank-limit-auto", 25);
	setprop("/it-autoflight/internal/bank-limit", 25);
	setprop("/it-autoflight/internal/alt", 10000);
	setprop("/it-autoflight/internal/fpa", 0);
	setprop("/it-autoflight/internal/top-of-des-nm", 0);
	setprop("/it-autoflight/mode/thr", "PITCH");
	setprop("/it-autoflight/mode/arm", " ");
	setprop("/it-autoflight/mode/lat", "T/O");
	setprop("/it-autoflight/mode/vert", "T/O CLB");
	setprop("/it-autoflight/input/spd-kts", 250);
	setprop("/it-autoflight/input/spd-mach", 0.68);
	ap_varioust.start();
	thrustmode();
}

setlistener("/sim/signals/fdm-initialized", func {
    ap_init();
});

# AP 1 Master System
setlistener("/it-autoflight/input/ap1", func {
	var apmas = getprop("/it-autoflight/input/ap1");
	var apout = getprop("/it-autoflight/output/ap1");
	if (apmas != apout) {
		AP1Master();
	}
});

var AP1Master = func {
	var apmas = getprop("/it-autoflight/input/ap1");
	if (apmas == 0) {
		setprop("/it-autoflight/output/ap1", 0);
		if (getprop("/it-autoflight/settings/disable-final") != 1) {
			setprop("/controls/flight/aileron", 0);
			setprop("/controls/flight/elevator", 0);
			setprop("/controls/flight/rudder", 0);
		}
		if (getprop("/it-autoflight/sound/enableapoffsound") == 1) {
			setprop("/it-autoflight/sound/apoffsound", 1);
			setprop("/it-autoflight/sound/enableapoffsound", 0);	  
		}
	} else if (apmas == 1) {
		if ((getprop("/gear/gear[1]/wow") == 0) and (getprop("/gear/gear[2]/wow") == 0)) {
			setprop("/controls/flight/rudder", 0);
			setprop("/it-autoflight/output/ap1", 1);
			setprop("/it-autoflight/sound/enableapoffsound", 1);
			setprop("/it-autoflight/sound/apoffsound", 0);
		}
	}
	
	var apout = getprop("/it-autoflight/output/ap1");
	if (apmas != apout) {
		setprop("/it-autoflight/input/ap1", apout);
	}
}

# AP 2 Master System
setlistener("/it-autoflight/input/ap2", func {
	var apmas = getprop("/it-autoflight/input/ap2");
	var apout = getprop("/it-autoflight/output/ap2");
	
	if (apmas != apout) {
		AP2Master();
	}
});

var AP2Master = func {
	var apmas = getprop("/it-autoflight/input/ap2");
	if (apmas == 0) {
		setprop("/it-autoflight/output/ap2", 0);
		if (getprop("/it-autoflight/settings/disable-final") != 1) {
			setprop("/controls/flight/aileron", 0);
			setprop("/controls/flight/elevator", 0);
			setprop("/controls/flight/rudder", 0);
		}
		if (getprop("/it-autoflight/sound/enableapoffsound2") == 1) {
			setprop("/it-autoflight/sound/apoffsound2", 1);	
			setprop("/it-autoflight/sound/enableapoffsound2", 0);	  
		}
	} else if (apmas == 1) {
		if ((getprop("/gear/gear[1]/wow") == 0) and (getprop("/gear/gear[2]/wow") == 0)) {
			setprop("/controls/flight/rudder", 0);
			setprop("/it-autoflight/output/ap2", 1);
			setprop("/it-autoflight/sound/enableapoffsound2", 1);
			setprop("/it-autoflight/sound/apoffsound2", 0);
		}
	}
	
	var apout = getprop("/it-autoflight/output/ap2");
	if (apmas != apout) {
		setprop("/it-autoflight/input/ap2", apout);
	}
}

# ATHR Master System
setlistener("/it-autoflight/input/athr", func {
	var athrmas = getprop("/it-autoflight/input/athr");
	var athrout = getprop("/it-autoflight/output/athr");
	
	if (athrmas != athrout) {
		ATHRMaster();
	}
});

var ATHRMaster = func {
	var athrmas = getprop("/it-autoflight/input/athr");
	if (athrmas == 0) {
		setprop("/it-autoflight/output/athr", 0);
	} else if (athrmas == 1) {
		thrustmode();
		setprop("/it-autoflight/output/athr", 1);
	}
	
	var athrout = getprop("/it-autoflight/output/athr");
	if (athrmas != athrout) {
		setprop("/it-autoflight/input/athr", athrout);
	}
}

# Flight Director 1 Master System
setlistener("/it-autoflight/input/fd1", func {
	var fdmas = getprop("/it-autoflight/input/fd1");
	var fdout = getprop("/it-autoflight/output/fd1");
	
	if (fdmas != fdout) {
		FD1Master();
	}
});

var FD1Master = func {
	var fdmas = getprop("/it-autoflight/input/fd1");
	if (fdmas == 0) {
		setprop("/it-autoflight/output/fd1", 0);
	} else if (fdmas == 1) {
		setprop("/it-autoflight/output/fd1", 1);
	}
	
	var fdout = getprop("/it-autoflight/output/fd1");
	if (fdmas != fdout) {
		setprop("/it-autoflight/input/fd1", fdout);
	}
}

# Flight Director 2 Master System
setlistener("/it-autoflight/input/fd2", func {
	var fdmas = getprop("/it-autoflight/input/fd2");
	var fdout = getprop("/it-autoflight/output/fd2");
	
	if (fdmas != fdout) {
		FD2Master();
	}
});

var FD2Master = func {
	var fdmas = getprop("/it-autoflight/input/fd2");
	if (fdmas == 0) {
		setprop("/it-autoflight/output/fd2", 0);
	} else if (fdmas == 1) {
		setprop("/it-autoflight/output/fd2", 1);
	}
	
	var fdout = getprop("/it-autoflight/output/fd2");
	if (fdmas != fdout) {
		setprop("/it-autoflight/input/fd2", fdout);
	}
}

# Master Lateral
setlistener("/it-autoflight/input/lat", func {
	if ((getprop("/gear/gear[1]/wow") == 0) and (getprop("/gear/gear[2]/wow") == 0)) {
		setprop("/it-autoflight/input/lat-arm", 0);
		lateral();
	} else {
		lat_arm();
	}
});

var lateral = func {
	var latset = getprop("/it-autoflight/input/lat");
	if (latset == 0) {
		alandt.stop();
		alandt1.stop();
		setprop("/it-autoflight/input/lat-arm", 0);
		setprop("/it-autoflight/output/loc-armed", 0);
		setprop("/it-autoflight/output/appr-armed", 0);
		setprop("/it-autoflight/output/lat", 0);
		setprop("/it-autoflight/mode/lat", "HDG");
		setprop("/it-autoflight/mode/arm", " ");
	} else if (latset == 1) {
		if (getprop("/autopilot/route-manager/route/num") > 0 and getprop("/autopilot/route-manager/active") == 1 and getprop("/position/gear-agl-ft") >= getprop("/it-autoflight/settings/lat-agl-ft")) {
			make_lnav_active();
		} else {
			if (getprop("/it-autoflight/output/lat") != 1) {
				setprop("/it-autoflight/input/lat-arm", 1);
				setprop("/it-autoflight/mode/arm", "LNV");
			}
		}
	} else if (latset == 2) {
		if (getprop("/instrumentation/nav[0]/in-range") == 1 and getprop("/it-autoflight/settings/use-nav2-radio") == 0) {
			locdefl = abs(getprop("/instrumentation/nav[0]/heading-needle-deflection-norm"));
			if (locdefl < 0.95 and locdefl != 0 and getprop("/instrumentation/nav[0]/signal-quality-norm") > 0.99) {
				make_loc_active();
			} else {
				if (getprop("/it-autoflight/output/lat") != 2) {
					setprop("/it-autoflight/input/lat-arm", 0);
					setprop("/it-autoflight/output/loc-armed", 1);
					setprop("/it-autoflight/mode/arm", "LOC");
				}
			}
		} else if (getprop("/instrumentation/nav[1]/in-range") == 1 and getprop("/it-autoflight/settings/use-nav2-radio") == 1) {
			locdefl_b = abs(getprop("/instrumentation/nav[1]/heading-needle-deflection-norm"));
			if (locdefl_b < 0.95 and locdefl_b != 0 and getprop("/instrumentation/nav[1]/signal-quality-norm") > 0.99) {
				make_loc_active();
			} else {
				if (getprop("/it-autoflight/output/lat") != 2) {
					setprop("/it-autoflight/input/lat-arm", 0);
					setprop("/it-autoflight/output/loc-armed", 1);
					setprop("/it-autoflight/mode/arm", "LOC");
				}
			}
		} else {
			setprop("/instrumentation/nav[0]/signal-quality-norm", 0);
			setprop("/instrumentation/nav[1]/signal-quality-norm", 0);
		}
	} else if (latset == 3) {
		alandt.stop();
		alandt1.stop();
		setprop("/it-autoflight/input/lat-arm", 0);
		setprop("/it-autoflight/output/loc-armed", 0);
		setprop("/it-autoflight/output/appr-armed", 0);
		var hdgpredic = math.round(getprop("/it-autoflight/internal/heading-predicted"));
		setprop("/it-autoflight/input/hdg", hdgpredic);
		setprop("/it-autoflight/output/lat", 0);
		setprop("/it-autoflight/mode/lat", "HDG");
		setprop("/it-autoflight/mode/arm", " ");
	} else if (latset == 4) {
		setprop("/it-autoflight/input/lat-arm", 0);
		setprop("/it-autoflight/output/lat", 4);
		setprop("/it-autoflight/mode/lat", "ALGN");
	} else if (latset == 5) {
		setprop("/it-autoflight/input/lat-arm", 0);
		setprop("/it-autoflight/output/lat", 5);
	}
}

var lat_arm = func {
	var latset = getprop("/it-autoflight/input/lat");
	if (latset == 0) {
		setprop("/it-autoflight/input/lat-arm", 0);
		setprop("/it-autoflight/mode/arm", " ");
	} else if (latset == 1) {
		if (getprop("/autopilot/route-manager/route/num") > 0 and getprop("/autopilot/route-manager/active") == 1) {
			setprop("/it-autoflight/input/lat-arm", 1);
			setprop("/it-autoflight/mode/arm", "LNV");
		}
	} else if (latset == 3) {
		if (getprop("/it-autoflight/input/true-course") == 1) {
			var hdgnow = math.round(getprop("/it-autoflight/internal/track-deg"));
		} else {
			var hdgnow = math.round(getprop("/it-autoflight/internal/heading-deg"));
		}
		setprop("/it-autoflight/input/hdg", hdgnow);
		setprop("/it-autoflight/input/lat-arm", 0);
		setprop("/it-autoflight/mode/arm", " ");
	}
}

# Master Vertical
setlistener("/it-autoflight/input/vert", func {
	if ((getprop("/gear/gear[1]/wow") == 0) and (getprop("/gear/gear[2]/wow") == 0)) {
		vertical();
	}
});

var vertical = func {
	var vertset = getprop("/it-autoflight/input/vert");
	if (vertset == 0) {
		alandt.stop();
		alandt1.stop();
		setprop("/it-autoflight/output/appr-armed", 0);
		setprop("/it-autoflight/output/vert", 0);
		setprop("/it-autoflight/mode/vert", "ALT HLD");
		if (getprop("/it-autoflight/output/loc-armed")) {
			setprop("/it-autoflight/mode/arm", "LOC");
		} else {
			setprop("/it-autoflight/mode/arm", " ");
		}
		var altpredic = math.round(getprop("/it-autoflight/internal/altitude-predicted"), 100);
		setprop("/it-autoflight/input/alt", altpredic);
		setprop("/it-autoflight/internal/alt", altpredic);
		thrustmode();
	} else if (vertset == 1) {
		alandt.stop();
		alandt1.stop();
		setprop("/it-autoflight/output/appr-armed", 0);
		altinput = getprop("/it-autoflight/input/alt");
		setprop("/it-autoflight/internal/alt", altinput);
		vsnow = math.clamp(math.round(getprop("/it-autoflight/internal/vert-speed-fpm"), 100), -6000, 6000);
		setprop("/it-autoflight/input/vs", vsnow);
		setprop("/it-autoflight/output/vert", 1);
		setprop("/it-autoflight/mode/vert", "V/S");
		if (getprop("/it-autoflight/output/loc-armed")) {
			setprop("/it-autoflight/mode/arm", "LOC");
		} else {
			setprop("/it-autoflight/mode/arm", " ");
		}
		thrustmode();
	} else if (vertset == 2) {
		if (getprop("/instrumentation/nav[0]/in-range") == 1 and getprop("/it-autoflight/settings/use-nav2-radio") == 0) {
			locdefl = abs(getprop("/instrumentation/nav[0]/heading-needle-deflection-norm"));
			if (locdefl < 0.95 and locdefl != 0 and getprop("/instrumentation/nav[0]/signal-quality-norm") > 0.99) {
				make_loc_active();
			} else {
				if (getprop("/it-autoflight/output/lat") != 2) {
					setprop("/it-autoflight/output/loc-armed", 1);
				}
			}
			signal = getprop("/instrumentation/nav[0]/gs-needle-deflection-norm");
			if (((signal < 0 and signal >= -0.20) or (signal > 0 and signal <= 0.20)) and getprop("/it-autoflight/output/lat") == 2) {
				make_appr_active();
			} else {
				if (getprop("/it-autoflight/output/vert") != 2 and getprop("/it-autoflight/output/vert") != 6) {
					setprop("/it-autoflight/output/appr-armed", 1);
					setprop("/it-autoflight/mode/arm", "ILS");
				}
			}
		} else if (getprop("/instrumentation/nav[1]/in-range") == 1 and getprop("/it-autoflight/settings/use-nav2-radio") == 1) {
			locdefl_b = abs(getprop("/instrumentation/nav[1]/heading-needle-deflection-norm"));
			if (locdefl_b < 0.95 and locdefl_b != 0 and getprop("/instrumentation/nav[1]/signal-quality-norm") > 0.99) {
				make_loc_active();
			} else {
				if (getprop("/it-autoflight/output/lat") != 2) {
					setprop("/it-autoflight/output/loc-armed", 1);
				}
			}
			signal_b = getprop("/instrumentation/nav[1]/gs-needle-deflection-norm");
			if (((signal_b < 0 and signal_b >= -0.20) or (signal_b > 0 and signal_b <= 0.20)) and getprop("/it-autoflight/output/lat") == 2) {
				make_appr_active();
			} else {
				if (getprop("/it-autoflight/output/vert") != 2 and getprop("/it-autoflight/output/vert") != 6) {
					setprop("/it-autoflight/output/appr-armed", 1);
					setprop("/it-autoflight/mode/arm", "ILS");
				}
			}
		} else {
			setprop("/instrumentation/nav[0]/signal-quality-norm", 0);
			setprop("/instrumentation/nav[1]/signal-quality-norm", 0);
			setprop("/instrumentation/nav[0]/gs-rate-of-climb", 0);
			setprop("/instrumentation/nav[1]/gs-rate-of-climb", 0);
		}
	} else if (vertset == 3) {
		alandt.stop();
		alandt1.stop();
		var calt = getprop("/instrumentation/altimeter/indicated-altitude-ft");
		var alt = getprop("/it-autoflight/internal/alt");
		var dif = calt - alt;
		vsnow = getprop("/it-autoflight/internal/vert-speed-fpm");
		if (calt < alt) {
			setprop("/it-autoflight/internal/max-vs", vsnow);
		} else if (calt > alt) {
			setprop("/it-autoflight/internal/min-vs", vsnow);
		}
		minmaxtimer.start();
		thrustmode();
		setprop("/it-autoflight/output/vert", 0);
		setprop("/it-autoflight/mode/vert", "ALT CAP");
	} else if (vertset == 4) {
		alandt.stop();
		alandt1.stop();
		setprop("/it-autoflight/output/appr-armed", 0);
		altinput = getprop("/it-autoflight/input/alt");
		setprop("/it-autoflight/internal/alt", altinput);
		var calt = getprop("/instrumentation/altimeter/indicated-altitude-ft");
		var alt = getprop("/it-autoflight/internal/alt");
		var dif = calt - alt;
		if (dif < 250 and dif > -250) {
			alt_on();
		} else {
			flch_on();
		}
		if (getprop("/it-autoflight/output/loc-armed")) {
			setprop("/it-autoflight/mode/arm", "LOC");
		} else {
			setprop("/it-autoflight/mode/arm", " ");
		}
	} else if (vertset == 5) {
		alandt.stop();
		alandt1.stop();
		setprop("/it-autoflight/output/appr-armed", 0);
		altinput = getprop("/it-autoflight/input/alt");
		setprop("/it-autoflight/internal/alt", altinput);
		fpanow = math.clamp(math.round(getprop("/it-autoflight/internal/fpa"), 0.1), -9.9, 9.9);
		setprop("/it-autoflight/input/fpa", fpanow);
		setprop("/it-autoflight/output/vert", 5);
		setprop("/it-autoflight/mode/vert", "FPA");
		if (getprop("/it-autoflight/output/loc-armed") == 1) {
			setprop("/it-autoflight/mode/arm", "LOC");
		} else {
			setprop("/it-autoflight/mode/arm", " ");
		}
		thrustmode();
	} else if (vertset == 6) {
		setprop("/it-autoflight/output/vert", 6);
		setprop("/it-autoflight/mode/vert", "LAND");
		setprop("/it-autoflight/mode/arm", " ");
		thrustmode();
		alandt.stop();
		alandt1.start();
	} else if (vertset == 7) {
		alandt.stop();
		alandt1.stop();
		setprop("/it-autoflight/output/vert", 7);
		setprop("/it-autoflight/mode/arm", " ");
		altinput = getprop("/it-autoflight/input/alt");
		setprop("/it-autoflight/internal/alt", altinput);
		thrustmodet.start();
	}
}

# Helpers
setlistener("/autopilot/route-manager/current-wp", func {
	setprop("/autopilot/internal/wp-change-time", getprop("/sim/time/elapsed-sec"));
});

var ap_various = func {
	# Calculate Roll and Pitch Kp
	if (getprop("/it-autoflight/settings/disable-final") != 1) {
		rollKp = getprop("/it-autoflight/config/roll/kp-low") + (getprop("/velocities/airspeed-kt") - 140) * ((getprop("/it-autoflight/config/roll/kp-high") - getprop("/it-autoflight/config/roll/kp-low")) / (360 - 140));
		pitchKp = getprop("/it-autoflight/config/pitch/kp-low") + (getprop("/velocities/airspeed-kt") - 140) * ((getprop("/it-autoflight/config/pitch/kp-high") - getprop("/it-autoflight/config/pitch/kp-low")) / (360 - 140));
		
		if (getprop("/it-autoflight/config/roll/kp-low") > getprop("/it-autoflight/config/roll/kp-high")) {
			rollKp = math.clamp(rollKp, getprop("/it-autoflight/config/roll/kp-high"), getprop("/it-autoflight/config/roll/kp-low"));
		} else if (getprop("/it-autoflight/config/roll/kp-low") < getprop("/it-autoflight/config/roll/kp-high")) {
			rollKp = math.clamp(rollKp, getprop("/it-autoflight/config/roll/kp-low"), getprop("/it-autoflight/config/roll/kp-high"));
		}
		if (getprop("/it-autoflight/config/pitch/kp-low") > getprop("/it-autoflight/config/pitch/kp-high")) {
			pitchKp = math.clamp(pitchKp, getprop("/it-autoflight/config/pitch/kp-high"), getprop("/it-autoflight/config/pitch/kp-low"));
		} else if (getprop("/it-autoflight/config/pitch/kp-low") < getprop("/it-autoflight/config/pitch/kp-high")) {
			pitchKp = math.clamp(pitchKp, getprop("/it-autoflight/config/pitch/kp-low"), getprop("/it-autoflight/config/pitch/kp-high"));
		}
		
		setprop("/it-autoflight/config/roll/kp", rollKp);
		setprop("/it-autoflight/config/pitch/kp", pitchKp);
	} else {
		setprop("/it-autoflight/config/roll/kp", 0);
		setprop("/it-autoflight/config/pitch/kp", 0);
	}
	
	# Calculate HDG Kp
	hdgKp = getprop("/it-autoflight/config/cmd/hdg") + (getprop("/velocities/airspeed-kt") - 140) * ((getprop("/it-autoflight/config/cmd/hdg") + 1.0 - getprop("/it-autoflight/config/cmd/hdg")) / (360 - 140));
	
	hdgKp = math.clamp(hdgKp, getprop("/it-autoflight/config/cmd/hdg"), getprop("/it-autoflight/config/cmd/hdg") + 1.0);
	
	setprop("/it-autoflight/config/cmd/hdg-kp", hdgKp);
	
	trueSpeedKts = getprop("/instrumentation/airspeed-indicator/true-speed-kt");
	if (trueSpeedKts > 420) {
		if (getprop("/it-autoflight/settings/auto-bank-max-deg") < 10) {
			setprop("/it-autoflight/internal/bank-limit-auto", 5);
		} else if (getprop("/it-autoflight/settings/auto-bank-max-deg") < 15) {
			setprop("/it-autoflight/internal/bank-limit-auto", 10);
		} else {
			setprop("/it-autoflight/internal/bank-limit-auto", 15);
		}
	} else if (trueSpeedKts > 340) {
		if (getprop("/it-autoflight/settings/auto-bank-max-deg") < 10) {
			setprop("/it-autoflight/internal/bank-limit-auto", 5);
		} else if (getprop("/it-autoflight/settings/auto-bank-max-deg") < 15) {
			setprop("/it-autoflight/internal/bank-limit-auto", 10);
		} else if (getprop("/it-autoflight/settings/auto-bank-max-deg") < 20) {
			setprop("/it-autoflight/internal/bank-limit-auto", 15);
		} else {
			setprop("/it-autoflight/internal/bank-limit-auto", 20);
		}
	} else {
		if (getprop("/it-autoflight/settings/auto-bank-max-deg") < 10) {
			setprop("/it-autoflight/internal/bank-limit-auto", 5);
		} else if (getprop("/it-autoflight/settings/auto-bank-max-deg") < 15) {
			setprop("/it-autoflight/internal/bank-limit-auto", 10);
		} else if (getprop("/it-autoflight/settings/auto-bank-max-deg") < 20) {
			setprop("/it-autoflight/internal/bank-limit-auto", 15);
		} else if (getprop("/it-autoflight/settings/auto-bank-max-deg") < 25) {
			setprop("/it-autoflight/internal/bank-limit-auto", 20);
		} else if (getprop("/it-autoflight/settings/auto-bank-max-deg") < 30) {
			setprop("/it-autoflight/internal/bank-limit-auto", 25);
		} else {
			setprop("/it-autoflight/internal/bank-limit-auto", 30);
		}
	}
	
	bank_limit_sw = getprop("/it-autoflight/input/bank-limit-sw");
	if (bank_limit_sw == 0) {
		setprop("/it-autoflight/internal/bank-limit", getprop("/it-autoflight/internal/bank-limit-auto"));
	} else if (bank_limit_sw == 1) {
		setprop("/it-autoflight/internal/bank-limit", 5);
	} else if (bank_limit_sw == 2) {
		setprop("/it-autoflight/internal/bank-limit", 10);
	} else if (bank_limit_sw == 3) {
		setprop("/it-autoflight/internal/bank-limit", 15);
	} else if (bank_limit_sw == 4) {
		setprop("/it-autoflight/internal/bank-limit", 20);
	} else if (bank_limit_sw == 5) {
		setprop("/it-autoflight/internal/bank-limit", 25);
	} else if (bank_limit_sw == 6) {
		setprop("/it-autoflight/internal/bank-limit", 30);
	}
	
	if (getprop("/autopilot/route-manager/route/num") > 0 and getprop("/autopilot/route-manager/active") == 1) {
		if ((getprop("/autopilot/route-manager/current-wp") + 1) < getprop("/autopilot/route-manager/route/num")) {
			gnds_mps = getprop("/velocities/groundspeed-kt") * 0.5144444444444;
			wp_fly_from = getprop("/autopilot/route-manager/current-wp");
			if (wp_fly_from < 0) {
				wp_fly_from = 0;
			}
			current_course = getprop("/autopilot/route-manager/route/wp[" ~ wp_fly_from ~ "]/leg-bearing-true-deg");
			wp_fly_to = getprop("/autopilot/route-manager/current-wp") + 1;
			if (wp_fly_to < 0) {
				wp_fly_to = 0;
			}
			next_course = getprop("/autopilot/route-manager/route/wp[" ~ wp_fly_to ~ "]/leg-bearing-true-deg");
			max_bank_limit = getprop("/it-autoflight/internal/bank-limit");

			delta_angle = math.abs(geo.normdeg180(current_course - next_course));
			max_bank = delta_angle * 1.5;
			if (max_bank > max_bank_limit) {
				max_bank = max_bank_limit;
			}
			radius = (gnds_mps * gnds_mps) / (9.81 * math.tan(max_bank / 57.2957795131));
			time = 0.64 * gnds_mps * delta_angle * 0.7 / (360 * math.tan(max_bank / 57.2957795131));
			delta_angle_rad = (180 - delta_angle) / 114.5915590262;
			R = radius/math.sin(delta_angle_rad);
			dist_coeff = delta_angle * -0.011111 + 2;
			if (dist_coeff < 1) {
				dist_coeff = 1;
			}
			turn_dist = math.cos(delta_angle_rad) * R * dist_coeff / 1852;
			if (getprop("/gear/gear[0]/wow") == 1 and turn_dist < 1) {
				turn_dist = 1;
			}
			setprop("/it-autoflight/internal/lnav-advance-nm", turn_dist);
			if (getprop("/sim/time/elapsed-sec")-getprop("/autopilot/internal/wp-change-time") > 60) {
				setprop("/autopilot/internal/wp-change-check-period", time);
			}
			
			if (getprop("/autopilot/route-manager/wp/dist") <= turn_dist) {
				setprop("/autopilot/route-manager/current-wp", getprop("/autopilot/route-manager/current-wp") + 1);
			}
		}
	}
}

var flch_on = func {
	setprop("/it-autoflight/output/appr-armed", 0);
	setprop("/it-autoflight/output/vert", 4);
	thrustmodet.start();
}
var alt_on = func {
	setprop("/it-autoflight/output/appr-armed", 0);
	setprop("/it-autoflight/output/vert", 0);
	setprop("/it-autoflight/mode/vert", "ALT CAP");
	setprop("/it-autoflight/internal/max-vs", 500);
	setprop("/it-autoflight/internal/min-vs", -500);
	minmaxtimer.start();
}

setlistener("/it-autoflight/input/kts-mach", func {
	var ias = getprop("/it-autoflight/input/spd-kts") or 0;
	var mach = getprop("/it-autoflight/input/spd-mach") or 0;
	if (getprop("/it-autoflight/input/kts-mach") == 0) {
		if (ias >= 100 and ias <= 350) {
			setprop("/it-autoflight/input/spd-kts", math.round(ias, 1));
		} else if (ias < 100) {
			setprop("/it-autoflight/input/spd-kts", 100);
		} else if (ias > 350) {
			setprop("/it-autoflight/input/spd-kts", 350);
		}
	} else if (getprop("/it-autoflight/input/kts-mach") == 1) {
		if (mach >= 0.50 and mach <= 0.90) {
			setprop("/it-autoflight/input/spd-mach", math.round(mach, 0.001));
		} else if (mach < 0.50) {
			setprop("/it-autoflight/input/spd-mach", 0.50);
		} else if (mach > 0.90) {
			setprop("/it-autoflight/input/spd-mach", 0.90);
		}
	}
});

# Takeoff Modes
# TOGA
setlistener("/it-autoflight/input/toga", func {
	if (getprop("/it-autoflight/input/toga") == 1) {
		setprop("/it-autoflight/input/vert", 7);
		vertical();
		setprop("/it-autoflight/output/loc-armed", 0);
		setprop("/it-autoflight/output/appr-armed", 0);
		setprop("/it-autoflight/input/toga", 0);
		togasel();
	}
});

var togasel = func {
	if ((getprop("/gear/gear[1]/wow") == 0) and (getprop("/gear/gear[2]/wow") == 0)) {
		var iasnow = math.round(getprop("/instrumentation/airspeed-indicator/indicated-speed-kt"));
		setprop("/it-autoflight/input/spd-kts", iasnow);
		setprop("/it-autoflight/input/kts-mach", 0);
		setprop("/it-autoflight/mode/vert", "G/A CLB");
		setprop("/it-autoflight/input/lat", 3);
	} else {
		setprop("/it-autoflight/input/lat", 5);
		lateral();
		setprop("/it-autoflight/mode/lat", "T/O");
		setprop("/it-autoflight/mode/vert", "T/O CLB");
		setprop("/it-autoflight/input/athr", 1);
	}
}

setlistener("/it-autoflight/mode/vert", func {
	var vertm = getprop("/it-autoflight/mode/vert");
	if (vertm == "T/O CLB") {
		reduct.start();
	} else {
		reduct.stop();
	}
});

var toga_reduc = func {
	if (getprop("/position/gear-agl-ft") >= getprop("/it-autoflight/settings/reduc-agl-ft")) {
		setprop("/it-autoflight/input/vert", 4);
	}
}

# Altitude Capture and FPA Timer Logic
setlistener("/it-autoflight/output/vert", func {
	var vertm = getprop("/it-autoflight/output/vert");
	if (vertm == 1) {
		altcaptt.start();
	} else if (vertm == 4) {
		altcaptt.start();
	} else if (vertm == 5) {
		altcaptt.start();
	} else if (vertm == 7) {
		altcaptt.start();
	} else {
		altcaptt.stop();
	}
});

# Altitude Capture
var altcapt = func {
	vsnow = getprop("/it-autoflight/internal/vert-speed-fpm");
	setprop("/it-autoflight/internal/captvs", math.round(abs(vsnow) / (-1 * getprop("/it-autoflight/config/cmd/alt-gain")), 100));
	setprop("/it-autoflight/internal/captvsneg", -1 * math.round(abs(vsnow) / (-1 * getprop("/it-autoflight/config/cmd/alt-gain")), 100));
	var calt = getprop("/instrumentation/altimeter/indicated-altitude-ft");
	var alt = getprop("/it-autoflight/internal/alt");
	var dif = calt - alt;
	if (dif < getprop("/it-autoflight/internal/captvs") and dif > getprop("/it-autoflight/internal/captvsneg")) {
		if (vsnow > 0 and dif < 0) {
			setprop("/it-autoflight/input/vert", 3);
			setprop("/it-autoflight/output/thr-mode", 0);
			setprop("/it-autoflight/mode/thr", "THRUST");
		} else if (vsnow < 0 and dif > 0) {
			setprop("/it-autoflight/input/vert", 3);
			setprop("/it-autoflight/output/thr-mode", 0);
			setprop("/it-autoflight/mode/thr", "THRUST");
		}
	}
	altinput = getprop("/it-autoflight/input/alt");
	setprop("/it-autoflight/internal/alt", altinput);
}

# Min and Max Pitch Reset
var minmax = func {
	var calt = getprop("/instrumentation/altimeter/indicated-altitude-ft");
	var alt = getprop("/it-autoflight/internal/alt");
	var dif = calt - alt;
	if (dif < 50 and dif > -50) {
		setprop("/it-autoflight/internal/max-vs", 500);
		setprop("/it-autoflight/internal/min-vs", -500);
		var vertmode = getprop("/it-autoflight/output/vert");
		if (vertmode == 1 or vertmode == 2 or vertmode == 4 or vertmode == 5 or vertmode == 6 or vertmode == 7) {
			# Do not change the vertical mode because we are not trying to capture altitude.
		} else {
			setprop("/it-autoflight/mode/vert", "ALT HLD");
		}
		minmaxtimer.stop();
	}
}

# Thrust Mode Selector
var thrustmode = func {
	var calt = getprop("/instrumentation/altimeter/indicated-altitude-ft");
	var alt = getprop("/it-autoflight/internal/alt");
	if (getprop("/it-autoflight/output/vert") == 4) {
		if (calt < alt) {
			setprop("/it-autoflight/output/thr-mode", 2);
			setprop("/it-autoflight/mode/thr", " PITCH");
			setprop("/it-autoflight/mode/vert", "SPD CLB");
		} else if (calt > alt) {
			setprop("/it-autoflight/output/thr-mode", 1);
			setprop("/it-autoflight/mode/thr", " PITCH");
			setprop("/it-autoflight/mode/vert", "SPD DES");
		} else {
			setprop("/it-autoflight/output/thr-mode", 0);
			setprop("/it-autoflight/mode/thr", "THRUST");
			setprop("/it-autoflight/input/vert", 3);
		}
	} else if (getprop("/it-autoflight/output/vert") == 7) {
		setprop("/it-autoflight/output/thr-mode", 2);
		setprop("/it-autoflight/mode/thr", " PITCH");
	} else {
		setprop("/it-autoflight/output/thr-mode", 0);
		setprop("/it-autoflight/mode/thr", "THRUST");
		thrustmodet.stop();
	}
}

# ILS and Autoland
# Retard
setlistener("/controls/flight/flaps", func {
	var flapc = getprop("/controls/flight/flaps");
	var flapl = getprop("/it-autoflight/settings/land-flap");
	if (flapc >= flapl) {
		retardt.start();
	} else {
		retardt.stop();
	}
});

var retardchk = func {
	if (getprop("/it-autoflight/settings/retard-enable") == 1) {
		var altpos = getprop("/position/gear-agl-ft");
		var retardalt = getprop("/it-autoflight/settings/retard-ft");
		var aton = getprop("/it-autoflight/output/athr");
		if (altpos < retardalt) {
			if (aton == 1) {
				thrustmodet.stop();
				setprop("/it-autoflight/output/thr-mode", 1);
				setprop("/it-autoflight/mode/thr", "RETARD");
				atofft.start();
			} else {
				thrustmode();
			}
		}
	}
}

var atoffchk = func{
	var gear1 = getprop("/gear/gear[1]/wow");
	var gear2 = getprop("/gear/gear[2]/wow");
	if (gear1 == 1 or gear2 == 1) {
		setprop("/it-autoflight/input/athr", 0);
		setprop("/controls/engines/engine[0]/throttle", 0);
		setprop("/controls/engines/engine[1]/throttle", 0);
		setprop("/controls/engines/engine[2]/throttle", 0);
		setprop("/controls/engines/engine[3]/throttle", 0);
		setprop("/controls/engines/engine[4]/throttle", 0);
		setprop("/controls/engines/engine[5]/throttle", 0);
		setprop("/controls/engines/engine[6]/throttle", 0);
		setprop("/controls/engines/engine[7]/throttle", 0);
		atofft.stop();
	}
}

# LOC and G/S arming
setlistener("/it-autoflight/input/lat-arm", func {
	check_arms();
});

setlistener("/it-autoflight/output/loc-armed", func {
	check_arms();
});

setlistener("/it-autoflight/output/appr-armed", func {
	check_arms();
});

var check_arms = func {
	if (getprop("/it-autoflight/input/lat-arm") or getprop("/it-autoflight/output/loc-armed") or getprop("/it-autoflight/output/appr-armed")) {
		update_armst.start();
	} else {
		update_armst.stop();
	}
}

var update_arms = func {
	if (getprop("/it-autoflight/input/lat-arm") == 1 and getprop("/autopilot/route-manager/route/num") > 0 and getprop("/autopilot/route-manager/active") == 1 and getprop("/position/gear-agl-ft") >= getprop("/it-autoflight/settings/lat-agl-ft")) {
		make_lnav_active();
	}
	if (getprop("/instrumentation/nav[0]/in-range") == 1 and getprop("/it-autoflight/settings/use-nav2-radio") == 0) {
		if (getprop("/it-autoflight/output/loc-armed")) {
			locdefl = abs(getprop("/instrumentation/nav[0]/heading-needle-deflection-norm"));
			if (locdefl < 0.95 and locdefl != 0 and getprop("/instrumentation/nav[0]/signal-quality-norm") > 0.99) {
				make_loc_active();
			} else {
				return 0;
			}
		}
		if (getprop("/it-autoflight/output/appr-armed")) {
			signal = getprop("/instrumentation/nav[0]/gs-needle-deflection-norm");
			if (((signal < 0 and signal >= -0.20) or (signal > 0 and signal <= 0.20)) and getprop("/it-autoflight/output/lat") == 2) {
				make_appr_active();
			} else {
				return 0;
			}
		}
	} else if (getprop("/instrumentation/nav[1]/in-range") == 1 and getprop("/it-autoflight/settings/use-nav2-radio") == 1) {
		if (getprop("/it-autoflight/output/loc-armed")) {
			locdefl_b = abs(getprop("/instrumentation/nav[1]/heading-needle-deflection-norm"));
			if (locdefl_b < 0.95 and locdefl_b != 0 and getprop("/instrumentation/nav[1]/signal-quality-norm") > 0.99) {
				make_loc_active();
			} else {
				return 0;
			}
		}
		if (getprop("/it-autoflight/output/appr-armed")) {
			signal_b = getprop("/instrumentation/nav[1]/gs-needle-deflection-norm");
			if (((signal_b < 0 and signal_b >= -0.20) or (signal_b > 0 and signal_b <= 0.20)) and getprop("/it-autoflight/output/lat") == 2) {
				make_appr_active();
			} else {
				return 0;
			}
		}
	}
}

var make_lnav_active = func {
	if (getprop("/it-autoflight/output/lat") != 1) {
		alandt.stop();
		alandt1.stop();
		setprop("/it-autoflight/input/lat-arm", 0);
		setprop("/it-autoflight/output/loc-armed", 0);
		setprop("/it-autoflight/output/appr-armed", 0);
		setprop("/it-autoflight/output/lat", 1);
		setprop("/it-autoflight/mode/lat", "LNAV");
		setprop("/it-autoflight/mode/arm", " ");
	}
}

var make_loc_active = func {
	if (getprop("/it-autoflight/output/lat") != 2) {
		setprop("/it-autoflight/input/lat-arm", 0);
		setprop("/it-autoflight/output/loc-armed", 0);
		setprop("/it-autoflight/output/lat", 2);
		setprop("/it-autoflight/mode/lat", "LOC");
		if (getprop("/it-autoflight/output/appr-armed") == 1) {
			# Do nothing because G/S is armed
		} else {
			setprop("/it-autoflight/mode/arm", " ");
		}
	}
}

var make_appr_active = func {
	if (getprop("/it-autoflight/output/vert") != 2) {
		setprop("/it-autoflight/output/appr-armed", 0);
		setprop("/it-autoflight/output/vert", 2);
		setprop("/it-autoflight/mode/vert", "G/S");
		setprop("/it-autoflight/mode/arm", " ");
		alandt.start();
		thrustmode();
	}
}

# Autoland Stage 1 Logic (Land)
var aland = func {
	var ap1 = getprop("/it-autoflight/output/ap1");
	var ap2 = getprop("/it-autoflight/output/ap2");
	var landoption = getprop("/it-autoflight/settings/autoland-without-ap");
	if (getprop("/position/gear-agl-ft") <= 100) {
		if (ap1 == 1 or ap2 == 1) {
			setprop("/it-autoflight/input/lat", 4);
			setprop("/it-autoflight/input/vert", 6);
		} else if (ap1 == 0 and ap2 == 0 and landoption) {
			setprop("/it-autoflight/input/lat", 4);
			setprop("/it-autoflight/input/vert", 6);
		} else {
			alandt.stop();
			alandt1.stop();
		}
	}
}

var aland1 = func {
	var aglal = getprop("/position/gear-agl-ft");
	if (aglal <= 50 and aglal > 5) {
		setprop("/it-autoflight/mode/vert", "FLARE");
	}
	if ((getprop("/it-autoflight/output/ap1") == 0) and (getprop("/it-autoflight/output/ap2") == 0) and (getprop("/it-autoflight/settings/autoland-without-ap") == 0)) {
		alandt.stop();
		alandt1.stop();
		setprop("/it-autoflight/output/loc-armed", 0);
		setprop("/it-autoflight/output/lat", 2);
		setprop("/it-autoflight/mode/lat", "LOC");
		setprop("/it-autoflight/output/appr-armed", 0);
		setprop("/it-autoflight/output/vert", 2);
		setprop("/it-autoflight/mode/vert", "G/S");
		setprop("/it-autoflight/mode/arm", " ");
	}
	var gear1 = getprop("/gear/gear[1]/wow");
	var gear2 = getprop("/gear/gear[2]/wow");
	if (gear1 == 1 or gear2 == 1) {
		alandt1.stop();
		setprop("/it-autoflight/mode/lat", "RLOU");
		setprop("/it-autoflight/mode/vert", "ROLLOUT");
	}
}

# For Canvas Nav Display.
setlistener("/it-autoflight/input/hdg", func {
	setprop("/autopilot/settings/heading-bug-deg", getprop("/it-autoflight/input/hdg"));
});

setlistener("/it-autoflight/internal/alt", func {
	setprop("/autopilot/settings/target-altitude-ft", getprop("/it-autoflight/internal/alt"));
});

# Timers
var update_armst = maketimer(0.5, update_arms);
var altcaptt = maketimer(0.5, altcapt);
var thrustmodet = maketimer(0.5, thrustmode);
var minmaxtimer = maketimer(0.5, minmax);
var retardt = maketimer(0.5, retardchk);
var atofft = maketimer(0.5, atoffchk);
var alandt = maketimer(0.5, aland);
var alandt1 = maketimer(0.5, aland1);
var reduct = maketimer(0.5, toga_reduc);
var ap_varioust = maketimer(1, ap_various);
