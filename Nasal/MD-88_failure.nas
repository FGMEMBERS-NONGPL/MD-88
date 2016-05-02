var preset_malfunction_timerL = maketimer(1, func
{
    var speed = getprop("/instrumentation/airspeed-indicator/indicated-speed-kt");
    var L100armed = getprop("/controls/switches/Lengine100fail");
   
    if (!L100armed ) # if not armed then only check every second
        preset_malfunction_timerL.restart(1);
 
   if (speed >= 95 and speed <= 105){                                    # Checks if "speed" is equal to 100 or not.
        setprop("engines/engine[0]/state", 4);                              # Sets the LEFT engine (0) state to 4 (shutdown)
        setprop("/controls/engines/engine[0]/cutoff",1);                     # Sets the fuel switch to cutoff.
        setprop("/controls/switches/Lengine100fail",0);      
        preset_malfunction_timerL.stop();
    }
    preset_malfunction_timerL.restart(0);
    setprop("/controls/switches/Lengine100fail",0);
} );

 var enginePresetFailureL = func {                                             # Start of function, checkbox should call this.
     setprop("/controls/switches/Lengine100fail",1);
     preset_malfunction_timerL.restart(1);
 };





var preset_malfunction_timerR = maketimer(1, func
{
    var speed = getprop("/instrumentation/airspeed-indicator/indicated-speed-kt");
    var R100armed = getprop("/controls/switches/Rengine100fail");
   
    if (!R100armed ) # if not armed then only check every second
        preset_malfunction_timerR.restart(1);
 
   if (speed >= 95 and speed <= 105){                                    # Checks if "speed" is equal to 100 or not.
        setprop("engines/engine[1]/state", 4);                              # Sets the LEFT engine (0) state to 4 (shutdown)
        setprop("/controls/engines/engine[1]/cutoff",1);                     # Sets the fuel switch to cutoff.
        setprop("/controls/switches/Rengine100fail",0);      
        preset_malfunction_timerR.stop();
    }
    preset_malfunction_timerR.restart(0);
    setprop("/controls/switches/Rengine100fail",0);
} );

 var enginePresetFailureR = func {                                             # Start of function, checkbox should call this.
     setprop("/controls/switches/Rengine100fail",1);
     preset_malfunction_timerR.restart(1);
 };