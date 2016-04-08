var set_elec = func {

var battery_on = getprop("/controls/switches/battery");
var external_on = getprop("/controls/switches/cart");
var apugen1_on = getprop("/systems/apu/running");
var engine1_on = getprop("engines/engine[0]/running");
var engine2_on = getprop("engines/engine[1]/running");

    if (battery_on or external_on or apugen1_on or engine1_on or engine2_on) {
        setprop("systems/electrical/on", 1);
        setprop("systems/electrical/outputs/avionics-fan", 0);
        setprop("systems/electrical/outputs/gps-mfd", 0);
        setprop("systems/electrical/outputs/gps", 0);
        setprop("systems/electrical/outputs/hsi", 0);
        setprop("systems/electrical/outputs/comm", 0);
        setprop("systems/electrical/outputs/comm[1]", 0);
        setprop("systems/electrical/outputs/nav", 0);
        setprop("systems/electrical/outputs/nav[1]", 0);
        setprop("systems/electrical/outputs/dme", 0);
        setprop("systems/electrical/outputs/dme[1]", 0);
        setprop("systems/electrical/outputs/adf", 0);
        setprop("systems/electrical/outputs/adf[1]", 0);
        setprop("systems/electrical/outputs/mk-viii", 0);
        setprop("systems/electrical/outputs/tacan", 0);
        setprop("systems/electrical/outputs/turn-coordinator", 0);
        setprop("systems/electrical/outputs/audio-panel", 0);
        setprop("systems/electrical/outputs/audio-panel[1]", 0);
        setprop("systems/electrical/outputs/transponder", 0);
		setprop("systems/electrical/outputs/efis", 0);	
    } else {
        setprop("systems/electrical/on", 0);
        setprop("systems/electrical/outputs/avionics-fan", 0);
        setprop("systems/electrical/outputs/gps-mfd", 0);
        setprop("systems/electrical/outputs/gps", 0);
        setprop("systems/electrical/outputs/hsi", 0);
        setprop("systems/electrical/outputs/comm", 0);
        setprop("systems/electrical/outputs/comm[1]", 0);
        setprop("systems/electrical/outputs/nav", 0);
        setprop("systems/electrical/outputs/nav[1]", 0);
        setprop("systems/electrical/outputs/dme", 0);
        setprop("systems/electrical/outputs/dme[1]", 0);
        setprop("systems/electrical/outputs/adf", 0);
        setprop("systems/electrical/outputs/adf[1]", 0);
        setprop("systems/electrical/outputs/mk-viii", 0);
        setprop("systems/electrical/outputs/tacan", 0);
        setprop("systems/electrical/outputs/turn-coordinator", 0);
        setprop("systems/electrical/outputs/audio-panel", 0);
        setprop("systems/electrical/outputs/audio-panel[1]", 0);
        setprop("systems/electrical/outputs/transponder", 0);
		setprop("systems/electrical/outputs/efis", 0);	
    }
}