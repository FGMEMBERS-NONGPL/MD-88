# This file converts the IT-AUTOFLIGHT Mode numbers, and converts them into text strings needed for the FMA.
# Joshua Davidson (it0uchpods/411)

# Speed or Mach?
var speedmach = func {
  if (getprop("/it-autoflight/apvertmode") == 4) {
    # Do nothing because it's in FLCH mode.
  } else {
    if (getprop("/it-autoflight/apthrmode") == 0) {
      setprop("/FMA/thr", "SPD");
    } else if (getprop("/it-autoflight/apthrmode") == 1) {
      setprop("/FMA/thr", "MACH");
    }
  }
}

# IAS or MACH FLCH?
var speedmach = func {
  if (getprop("/it-autoflight/apvertmode") == 4) {
    if (getprop("/it-autoflight/apthrmode") == 0) {
      setprop("/FMA/pitch", "SPD");
    } else if (getprop("/it-autoflight/apthrmode") == 1) {
      setprop("/FMA/pitch", "MACH");
    }
  }
}

# Update Speed or Mach
setlistener("/it-autoflight/apthrmode", func {
  speedmach();
  flch-spdmach();
});

# Master Thrust
setlistener("/it-autoflight/apthrmode2", func {
  var latset = getprop("/it-autoflight/apthrmode2");
  if (latset == 0) {
	speedmach();
  } else if (latset == 1) {
	setprop("/FMA/thr", "IDLE");
  } else if (latset == 2) {
	setprop("/FMA/thr", "CLMP");
  }
});

# Master Lateral
setlistener("/it-autoflight/aplatmode", func {
  var latset = getprop("/it-autoflight/aplatmode");
  if (latset == 0) {
	setprop("/FMA/roll", "HDG");
	setprop("/FMA/roll2", "SEL");
  } else if (latset == 1) {
	setprop("/FMA/roll", "NAV");
	setprop("/FMA/roll2", "TRK");
  } else if (latset == 2) {
	setprop("/FMA/roll", "LOC");
	setprop("/FMA/roll2", "TRK");
  }
});

# Master Vertical
setlistener("/it-autoflight/apvertmode", func {
  var latset = getprop("/it-autoflight/apvertmode");
  if (latset == 0) {
	setprop("/FMA/pitch", "ALT");
	setprop("/FMA/pitch2", "HLD");
  } else if (latset == 1) {
	setprop("/FMA/pitch", "V/S");
	setprop("/FMA/pitch2", "TRK");
  } else if (latset == 2) {
	setprop("/FMA/pitch", "G/S");
	setprop("/FMA/pitch2", "TRK");
  } else if (latset == 4) {
	flch-spdmach();
	setprop("/FMA/pitch2", " ");
  }
});

var arm = func {
  var loc = getprop("/it-autoflight/loc1");
  var app = getprop("/it-autoflight/app1");
  if (app) {
    setprop("/FMA/arm", "ILS");
  } else if (loc) {
    setprop("/FMA/arm", "LOC");
  } else {
    setprop("/FMA/arm", " ");
  }
}

# Arm LOC
setlistener("/it-autoflight/loc-arm", func {
  arm();
});

# Arm G/S
setlistener("/it-autoflight/app-arm", func {
  arm();
});