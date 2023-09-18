// Tom Clancy's Splinter Cell Autosplitter by Distro
// Maintained and updated by MatthewDoomer and Distro 
// Needs extensive testing. Please contact MatthewDoomer or Distro in case you find a bug or have suggestions for improvements.

state("SplinterCell") {
  string255 map: "SNDDSound3DDLL_VBR.dll", 0x6146C;
  bool fireMenu: "EchelonHUD.DLL", 0x4AD08, 0xB54; 
  bool menu: "Engine.dll", 0xECF00, 0x0;
  bool missionComplete: "Engine.dll", 0x2B4644, 0xC8; // actually checks for disappearance of the HUD.
  byte health: "Engine.dll", 0x2DEBC8, 0x8, 0x34, 0x2A8, 0x330; // health ranges between 0 and 200. We are using this to avoid erroneous splits to deaths caused by damage.
  float xcoord: "Engine.dll", 0x2EA024, 0x30, 0x0, 0x18, 0x88, 0x34, 0x2A8, 0xD8;
  float ycoord: "Engine.dll", 0x2EA024, 0x30, 0x0, 0x18, 0x88, 0x34, 0x2A8, 0xD4;
  // float zcoord: "Engine.dll", 0x2EA024, 0x30, 0x0, 0x18, 0x88, 0x34, 0x2A8, 0xDC; // Altitude. Keeping it in just in case.
  int levelLoad: "Engine.dll", 0x2B4644, 0x330; // set to 32 when loading level, 96 otherwise.
}

startup
{
    settings.Add("intro_skip", true, "Intro Skip");
    settings.Add("run_end_split", false, "Split at End of Run (READ DESCRIPTION FIRST!)");

    settings.SetToolTip("intro_skip", "Auto start timer for runners who choose to skip the intro.");

    settings.SetToolTip("run_end_split", @"This will erroneously split on Presidential Palace and Vselka Submarine 
    when the HUD disappears to any Mission Fail other than dying to damage. 
    Activate this at your own risk and only if you know what you are doing!");

    // The starting coordinates on Training
    vars.xstart = 3844.277832f;
    vars.ystart = -1142.266724f;
    // vars.zstart = 56.13057327f; // Altitude. Keeping it in just in case.
}

isLoading {
  return current.levelLoad == 32;
}

start {
  if (settings["intro_skip"]) {
    return (current.xcoord != vars.xstart && old.xcoord == vars.xstart
    && current.ycoord != vars.ystart && old.ycoord == vars.ystart);
  }
  return !old.fireMenu && current.fireMenu && current.map != "menu";
}

reset {
  return !current.fireMenu && current.map == "0_0_2_Training" && current.levelLoad == 96;
}

split {
  bool levelChange = current.levelLoad == 32 && old.levelLoad == 96 && current.map != "0_0_1_Training";

  if (settings["run_end_split"] && (current.map == "5_1_2_PresidentialPalace" || current.map == "1_7_1_2Vselka")) {
      return levelChange || (current.missionComplete && !old.missionComplete && current.health != 0);
  }

  return levelChange && !current.menu;
}
