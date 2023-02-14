// Tom Clancy's Splinter Cell Autosplitter by Distro
// Maintained and updated by MatthewDoomer and Distro 
// Needs extensive testing. Please contact MatthewDoomer or Distro in case you find a bug or have suggestions for improvements.

state("SplinterCell") {
  string255 map: "SNDDSound3DDLL_VBR.dll", 0x6146C;
  bool fireMenu: "EchelonHUD.DLL", 0x4AD08, 0xB54; 
  bool menu: "Engine.dll", 0xECF00, 0x0;
  bool saveLoad: "Engine.dll", 0x2EFBB0, 0x0;
  int levelLoad: "Engine.dll", 0x2B4644, 0x330; // set to 32 when loading level, 96 otherwise.
}

isLoading {
  return (current.saveLoad || current.levelLoad == 32);
}

start {
  return (!old.fireMenu && current.fireMenu && current.map != "menu");
}

reset {
  return (!current.fireMenu && current.map == "0_0_2_Training" && current.levelLoad == 96);
}

split {
  bool levelChange = (current.levelLoad == 32 && old.levelLoad == 96 && current.map != "0_0_1_Training");

  return levelChange && !current.menu;
}
