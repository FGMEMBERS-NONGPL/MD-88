# Aircraft Config Center
# Joshua Davidson (Octal450)

setprop("/systems/acconfig/autoconfig-running", 0);
var main_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/main/dialog", "Aircraft/MD-88/AircraftConfig/main.xml");
var welcome_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/welcome/dialog", "Aircraft/MD-88/AircraftConfig/welcome.xml");
var ps_load_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/psload/dialog", "Aircraft/MD-88/AircraftConfig/psload.xml");
var ps_loaded_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/psloaded/dialog", "Aircraft/MD-88/AircraftConfig/psloaded.xml");
var init_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/init/dialog", "Aircraft/MD-88/AircraftConfig/ac_init.xml");
init_dlg.open();

setlistener("/sim/signals/fdm-initialized", func {
	init_dlg.close();
	welcome_dlg.open();
});

################
# Panel States #
################

# Cold and Dark
var colddark = func {
	ps_load_dlg.open();
	setprop("/systems/acconfig/autoconfig-running", 1);
	# Initial shutdown, and reinitialization.
	setprop("/controls/engines/ignition", 0);
	setprop("/controls/engines/engine[0]/cutoff", 1);
	setprop("/controls/engines/engine[1]/cutoff", 1);
	setprop("/controls/flight/slats", 0.000);
	setprop("/controls/flight/flaps", 0.000);
	setprop("/controls/flight/flap-lever", 0);
	MD88.spoiler_disarm();
	setprop("/controls/gear/gear-down", 1);
	systems.elec_init();
	itaf.ITAF.init();
	MD88.nd_init();
	if (getprop("/engines/engine[1]/n2-actual") < 2) {
		colddark_b();
	} else {
		var colddark_eng_off = setlistener("/engines/engine[1]/n2-actual", func {
			if (getprop("/engines/engine[1]/n2-actual") < 2) {
				removelistener(colddark_eng_off);
				colddark_b();
			}
		});
	}
}
var colddark_b = func {
	# Continues the Cold and Dark script, after engines fully shutdown.
	setprop("/controls/engines/engine[0]/start-switch", 0);
	setprop("/controls/engines/engine[1]/start-switch", 0);
	setprop("/controls/engines/ignition", 0);
	setprop("/controls/switches/apu-master", 0);
	setprop("/controls/switches/apu-air", 0);
	systems.fuel_init();
	MD88.FlightSurfaceInit();
	MD88.InstrumentationInit();
	setprop("/systems/acconfig/autoconfig-running", 0);
	ps_load_dlg.close();
	ps_loaded_dlg.open();
}

# Ready to Start Eng
var beforestart = func {
	ps_load_dlg.open();
	setprop("/systems/acconfig/autoconfig-running", 1);
	# First, we set everything to cold and dark.
	setprop("/controls/engines/ignition", 0);
	setprop("/controls/engines/engine[0]/cutoff", 1);
	setprop("/controls/engines/engine[1]/cutoff", 1);
	setprop("/controls/flight/slats", 0.000);
	setprop("/controls/flight/flaps", 0.000);
	setprop("/controls/flight/flap-lever", 0);
	MD88.spoiler_disarm();
	setprop("/controls/gear/gear-down", 1);
	systems.elec_init();
	itaf.ITAF.init();
	MD88.nd_init();
	setprop("/controls/engines/engine[0]/start-switch", 0);
	setprop("/controls/engines/engine[1]/start-switch", 0);
	setprop("/controls/engines/ignition", 0);
	setprop("/controls/switches/apu-master", 0);
	setprop("/controls/switches/apu-air", 0);
	systems.fuel_init();
	MD88.FlightSurfaceInit();
	MD88.InstrumentationInit();
	
	# Now the Startup!
	setprop("/controls/electrical/battery", 1);
	setprop("/controls/electrical/emerpwr", 1);
	setprop("/controls/fuel/switches/start-pump", 1);
	setprop("/controls/switches/apu-master", 2);
	var apu_rpm_chk = setlistener("/systems/apu/rpm", func {
		if (getprop("/systems/apu/rpm") >= 99) {
			removelistener(apu_rpm_chk);
			beforestart_b();
		}
	});
}
var beforestart_b = func {
	# Continue with engine start prep.
	setprop("/controls/electrical/apu/Lsw", 1);
	setprop("/controls/electrical/apu/Rsw", 1);
	setprop("/controls/electrical/emerpwr", 0);
	setprop("/controls/switches/apu-air", 1);
	setprop("/controls/pneumatic/engine[0]/bleed", 1);
	setprop("/controls/pneumatic/engine[1]/bleed", 1);
	setprop("/controls/engines/ignition", 1);
	setprop("/controls/fuel/switches/left-fwd", 1);
	setprop("/controls/fuel/switches/left-aft", 1);
	setprop("/controls/fuel/switches/center-fwd", 1);
	setprop("/controls/fuel/switches/center-aft", 1);
	setprop("/controls/fuel/switches/right-fwd", 1);
	setprop("/controls/fuel/switches/right-aft", 1);
	setprop("/controls/fuel/switches/start-pump", 0);
	setprop("/systems/acconfig/autoconfig-running", 0);
	ps_load_dlg.close();
	ps_loaded_dlg.open();
}

# Ready to Taxi
var taxi = func {
	ps_load_dlg.open();
	setprop("/systems/acconfig/autoconfig-running", 1);
	# First, we set everything to cold and dark.
	setprop("/controls/engines/ignition", 0);
	setprop("/controls/engines/engine[0]/cutoff", 1);
	setprop("/controls/engines/engine[1]/cutoff", 1);
	setprop("/controls/flight/slats", 0.000);
	setprop("/controls/flight/flaps", 0.000);
	setprop("/controls/flight/flap-lever", 0);
	MD88.spoiler_disarm();
	setprop("/controls/gear/gear-down", 1);
	systems.elec_init();
	itaf.ITAF.init();
	MD88.nd_init();
	setprop("/controls/engines/engine[0]/start-switch", 0);
	setprop("/controls/engines/engine[1]/start-switch", 0);
	setprop("/controls/engines/ignition", 0);
	setprop("/controls/switches/apu-master", 0);
	setprop("/controls/switches/apu-air", 0);
	systems.fuel_init();
	MD88.FlightSurfaceInit();
	MD88.InstrumentationInit();
	
	# Now the Startup!
	setprop("/controls/electrical/battery", 1);
	setprop("/controls/electrical/emerpwr", 1);
	setprop("/controls/fuel/switches/start-pump", 1);
	setprop("/controls/switches/apu-master", 2);
	var apu_rpm_chk = setlistener("/systems/apu/rpm", func {
		if (getprop("/systems/apu/rpm") >= 99) {
			removelistener(apu_rpm_chk);
			taxi_b();
		}
	});
}
var taxi_b = func {
	# Continue with engine start prep, and start engine 2.
	setprop("/controls/electrical/apu/Lsw", 1);
	setprop("/controls/electrical/apu/Rsw", 1);
	setprop("/controls/electrical/emerpwr", 0);
	setprop("/controls/switches/apu-air", 1);
	setprop("/controls/pneumatic/engine[0]/bleed", 1);
	setprop("/controls/pneumatic/engine[1]/bleed", 1);
	setprop("/controls/engines/ignition", 1);
	setprop("/controls/fuel/switches/left-fwd", 1);
	setprop("/controls/fuel/switches/left-aft", 1);
	setprop("/controls/fuel/switches/center-fwd", 1);
	setprop("/controls/fuel/switches/center-aft", 1);
	setprop("/controls/fuel/switches/right-fwd", 1);
	setprop("/controls/fuel/switches/right-aft", 1);
	setprop("/controls/fuel/switches/start-pump", 0);
	setprop("/controls/engines/engine[1]/start-switch", 1);
	var eng_two_chk = setlistener("/engines/engine[1]/n2-actual", func {
		if (getprop("/engines/engine[1]/n2-actual") >= 23) {
			removelistener(eng_two_chk);
			taxi_c();
		}
	});
}
var taxi_c = func {
	# Add fuel to engine 2.
	setprop("/controls/engines/engine[1]/cutoff", 0);
	var eng_two_chk_b = setlistener("/engines/engine[1]/n2-actual", func {
		if (getprop("/engines/engine[1]/state") == 3) {
			removelistener(eng_two_chk_b);
			taxi_d();
		}
	});
}
var taxi_d = func {
	# Start engine 1.
	setprop("/controls/engines/engine[0]/start-switch", 1);
	var eng_one_chk = setlistener("/engines/engine[0]/n2-actual", func {
		if (getprop("/engines/engine[0]/n2-actual") >= 23) {
			removelistener(eng_one_chk);
			taxi_e();
		}
	});
}
var taxi_e = func {
	# Add fuel to engine 1.
	setprop("/controls/engines/engine[0]/cutoff", 0);
	var eng_one_chk_b = setlistener("/engines/engine[0]/n2-actual", func {
		if (getprop("/engines/engine[0]/state") == 3) {
			removelistener(eng_one_chk_b);
			taxi_f();
		}
	});
}
var taxi_f = func {
	# After Start items.
	setprop("/controls/engines/ignition", 0);
	setprop("/controls/electrical/galley", 1);
	setprop("/controls/electrical/apu/Lsw", 0);
	setprop("/controls/electrical/apu/Rsw", 0);
	setprop("/controls/switches/apu-air", 0);
	setprop("/controls/switches/apu-master", 0);
	setprop("/systems/acconfig/autoconfig-running", 0);
	ps_load_dlg.close();
	ps_loaded_dlg.open();
}

# Ready to Takeoff
var takeoff = func {
	# The same as taxi, except we set some things afterwards.
	taxi();
	var eng_one_chk_c = setlistener("/engines/engine[0]/n2-actual", func {
		if (getprop("/engines/engine[0]/n2-actual") >= 56) {
			removelistener(eng_one_chk_c);
			MD88.spoiler_arm();
			setprop("/controls/flight/slats", 0.750);
			setprop("/controls/flight/flaps", 0.275);
			setprop("/controls/flight/flap-lever", 2);
			setprop("/controls/flight/elevator-trim", -0.2);
		}
	});
}
