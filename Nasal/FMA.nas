# This file converts the IT-AUTOFLIGHT Outputs, and converts them into text strings needed for the FMA.
# Joshua Davidson (it0uchpods/411)

# IAS or MACH FLCH?
var flch-speedmach = func {
  if (getprop("/it-autoflight/output/vert") == 4) {
    if (getprop("/it-autoflight/input/kts-mach") == 0) {
      setprop("/FMA/pitch", "IAS");
    } else if (getprop("/it-autoflight/input/kts-mach") == 1) {
      setprop("/FMA/pitch", "MACH");
    }
  }
}

# Update Speed or Mach
setlistener("/it-autoflight/input/kts-mach", func {
  flch-spdmach();
});

# Master Lateral
setlistener("/it-autoflight/mode/lat", func {
  var lat = getprop("/it-autoflight/output/lat");
  if (lat == "HDG") {
	setprop("/FMA/roll", "HDG");
	setprop("/FMA/roll2", "HLD");
  } else if (lat == "LNAV") {
	setprop("/FMA/roll", "NAV");
	setprop("/FMA/roll2", "TRK");
  } else if (lat == "LOC") {
	setprop("/FMA/roll", "LOC");
	setprop("/FMA/roll2", "TRK");
  } else if (lat == "ALGN") {
	setprop("/FMA/roll", "ALN");
	setprop("/FMA/roll2", " ");
  } else if (lat == "T/O") {
	setprop("/FMA/roll", "TAK");
	setprop("/FMA/roll2", "OFF");
  }
});

# Master Vertical
setlistener("/it-autoflight/mode/vert", func {
  var vert = getprop("/it-autoflight/mode/vert");
  if (vert == "ALT HLD") {
	setprop("/FMA/pitch", "ALT");
	setprop("/FMA/pitch2", "HLD");
  } else if (vert == "ALT CAP") {
	setprop("/FMA/pitch", "ALT");
	setprop("/FMA/pitch2", "CAP");
  } else if (vert == "V/S") {
	setprop("/FMA/pitch", "V/S");
	setprop("/FMA/pitch2", "TRK");
  } else if (vert == "G/S") {
	setprop("/FMA/pitch", "G/S");
	setprop("/FMA/pitch2", "TRK");
  } else if ((vert == "SPD CLB") or (vert == "SPD DES")) {
	flch-spdmach();
	setprop("/FMA/pitch2", " ");
  } else if (vert == "FPA") {
	setprop("/FMA/pitch", "FPA");
	setprop("/FMA/pitch2", "TRK");
  } else if (vert == "LAND 3") {
	setprop("/FMA/pitch", "AUT");
	setprop("/FMA/pitch2", "LND");
  } else if (vert == "FLARE") {
	setprop("/FMA/pitch", "FLAR");
	setprop("/FMA/pitch2", " ");
  } else if (vert == "T/O CLB") {
	setprop("/FMA/pitch", "TAK");
	setprop("/FMA/pitch2", "OFF");
  } else if (vert == "G/A CLB") {
	setprop("/FMA/pitch", "G/A");
	setprop("/FMA/pitch2", " ");
  }
});

var arm = func {
  var loc = getprop("/it-autoflight/output/loc-armed");
  var app = getprop("/it-autoflight/output/appr-armed");
  if (app) {
    setprop("/FMA/arm", "ILS");
  } else if (loc) {
    setprop("/FMA/arm", "LOC");
  } else {
    setprop("/FMA/arm", " ");
  }
}

# Arm LOC
setlistener("/it-autoflight/output/loc-armed", func {
  arm();
});

# Arm G/S
setlistener("/it-autoflight/output/appr-armed", func {
  arm();
});
