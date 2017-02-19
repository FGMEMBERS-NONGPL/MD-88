# McDonnell Douglas MD-88
#
# Initialization
#
# Gary Neely aka 'Buckaroo'
#
var engine_dialog = gui.Dialog.new("Aircraft/MD-88/Systems/announcements-dialog.xml");

aircraft.livery.init("Aircraft/MD-88/Models/Liveries");
								# Set up screen message windows
var MD88_screenmssg	= screen.window.new(nil, -150, 2, 5);
var MD88_screenmssg2	= screen.window.new(nil, -180, 2, 5);

								# Lighting setup

								# Install beacon timer and controller
beacon_switch = props.globals.getNode("/controls/lighting/beacon", 1);
beacon_switch.setBoolValue(0);
aircraft.light.new("/sim/model/lighting/beacon", [0.2, 2], beacon_switch);
								# Pass beacon timer over MP (aliasing the timer value
								# doesn't seem to work, so a listener is used)
								# Use MP var float[3]
var MD88_BeaconState	= props.globals.getNode("sim/model/lighting/beacon/state[0]", 1);
var MD88_MPBeaconState	= props.globals.getNode("/sim/multiplay/generic/float[3]", 1);
setlistener(MD88_BeaconState, func {
  if (MD88_BeaconState.getBoolValue())	{ MD88_MPBeaconState.setValue(1) }
  else					{ MD88_MPBeaconState.setValue(0) }
});

var controls_nav	= props.globals.getNode("/controls/lighting/nav");
var controls_wingtipaft	= props.globals.getNode("/controls/lighting/wingtipaft");
var controls_beacon	= props.globals.getNode("/controls/lighting/beacon");
var lights_nav_toggle = func {
  if (controls_nav.getValue()) {
    controls_nav.setValue(0);
    controls_wingtipaft.setValue(0);
  }
  else {
    controls_nav.setValue(1);
    controls_wingtipaft.setValue(1);
  }
}
var lights_beacon_toggle = func {
  if (controls_beacon.getValue()) {
    controls_beacon.setBoolValue(0);
  }
  else {
    controls_beacon.setBoolValue(1);
  }
}


								# Establish which settings are saved on exit
var MD88_Savedata = func {
  aircraft.data.add("/controls/lighting/digital-norm");		# Numeric readouts lighting
  aircraft.data.add("/controls/lighting/pfd-norm");		# Primary flight display lighting
  aircraft.data.add("/controls/lighting/nd-norm");		# Navigational display lighting
  aircraft.data.add("/controls/lighting/panel-norm");		# Standard instrument lighting
  aircraft.data.add("/options/retrofit");	# Retrofit
}



								# Initialization:

setlistener("/sim/signals/fdm-initialized", func {
  systems.elec_init();
  systems.fuel_init();
  FlightSurfaceInit();
  InstrumentationInit();
  itaf.ap_init();
  nd_init();
  setprop("/engines/engine/oil-q", 14);
  setprop("/engines/engine[1]/oil-q", 13);
  var autopilot = gui.Dialog.new("sim/gui/dialogs/autopilot/dialog", "Aircraft/MD-88/Systems/autopilot-dlg.xml");
  setlistener("engines/engine[0]/epr-actual", func {
    setprop("engines/engine[0]/epr-actualx100", (getprop("engines/engine[0]/epr-actual") * 100));
  });
  setlistener("engines/engine[1]/epr-actual", func {
  	setprop("engines/engine[1]/epr-actualx100", (getprop("engines/engine[1]/epr-actual") * 100));
  });
  MD88_Savedata();
});


