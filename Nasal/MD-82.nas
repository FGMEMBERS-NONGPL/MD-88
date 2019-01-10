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
  nd_init();
  setprop("/engines/engine/oil-q", 14);
  setprop("/engines/engine[1]/oil-q", 13);
  setlistener("engines/engine[0]/epr-actual", func {
    setprop("engines/engine[0]/epr-actualx100", (getprop("engines/engine[0]/epr-actual") * 100));
  });
  setlistener("engines/engine[1]/epr-actual", func {
  	setprop("engines/engine[1]/epr-actualx100", (getprop("engines/engine[1]/epr-actual") * 100));
  });
  MD88_Savedata();
});


