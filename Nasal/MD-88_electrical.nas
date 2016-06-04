# Electrical system for MD-88/MD-90 by Joshua Davidson (it0uchpods/411).

var ELEC_UPDATE_PERIOD	= 0.5;						# A periodic update in secs
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

									# Other property handles:
var engines	= props.globals.getNode("/engines").getChildren("engine");
var sources	= props.globals.getNode("/systems/electrical").getChildren("power-source");
var apu_running	= props.globals.getNode("/systems/apu/running");
var sw_batt	= props.globals.getNode("/controls/switches/battery");
var sw_cart	= props.globals.getNode("/controls/switches/cart");
var cart_wow	= props.globals.getNode("/gear/gear[0]/wow");
var gndspd	= props.globals.getNode("velocities/groundspeed-kt",1);
var sw_gen	= props.globals.getNode("/controls/switches").getChildren("generator");
var test_dc	= props.globals.getNode("/systems/electrical/test-volts-dc");
var test_ac	= props.globals.getNode("/systems/electrical/test-volts-ac");
var bus_dc	= props.globals.getNode("/systems/electrical/bus-dc");
var bus_ac	= props.globals.getNode("/systems/electrical/bus-ac");


var elec_main = func {
	var battery_on = getprop("/controls/switches/battery");
	var external_on = getprop("/controls/switches/cart");
	var apugen1_on = getprop("/systems/apu/running");
	var engine1_on = getprop("engines/engine[0]/state");
	var engine2_on = getprop("engines/engine[1]/state");
    if (battery_on or apugen1_on) {
        setprop("systems/electrical/on", 1);
		setprop("systems/electrical/outputs/efis", 25);	
		aispin.start();
	} else if (engine1_on == 3 or engine2_on == 3) {
        setprop("systems/electrical/on", 1);
		setprop("systems/electrical/outputs/efis", 25);	
		aispin.start();
    } else {
        setprop("systems/electrical/on", 0);
		setprop("systems/electrical/outputs/efis", 0);	
		ai_spin.setValue(0.2);
		aispin.stop();
    }
}

var ai_spin	= props.globals.getNode("/instrumentation/attitude-indicator/spin");

var aispinfunc = func {
  ai_spin.setValue(1);
}

var aispin = maketimer(5, aispinfunc);

var update_bus = func {
  var volts_ac = 0;							# Assume no volts on bus
  var volts_dc = 0;							# Assume no volts on bus
  for(var i=0; i<size(feed_status); i+=1) {				# Check all possible feeds
    if (feed_status[i]) {						# If feed is on
      var source_volts = sources[i].getNode("volts").getValue();
      if (sources[i].getNode("flow").getValue() == "ac") {
        if (source_volts > volts_ac) {					# Volts takes on largest source value
          volts_ac = source_volts;
        }
      }
      else {
        if (source_volts > volts_dc) {					# Volts takes on largest source value
          volts_dc = source_volts;
        }
      }
    }
  }
  bus_dc.getNode("volts").setValue(volts_dc);				# Bus takes on largest source value
  bus_ac.getNode("volts").setValue(volts_ac);				# Bus takes on largest source value
}

var update_voltmeter = func {
  interpolate(test_dc,bus_dc.getNode("volts").getValue(),1.5);
  interpolate(test_ac,bus_ac.getNode("volts").getValue(),1.5);
}

  
var update_electrical = func {
  elec_main();
  feed_status[feed["apu"]] = apu_running.getValue();
  feed_status[feed["batt"]] = sw_batt.getValue();
  update_bus();
  #update_bus_outputs();
  update_voltmeter();
  

  
  settimer(update_electrical,ELEC_UPDATE_PERIOD);			# Schedule next run
}


settimer(update_electrical, 2);						# Give a few seconds for vars to initialize