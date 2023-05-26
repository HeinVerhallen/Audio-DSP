set_global_assignment -entity "PLL_overclock" -library "lib_PLL_overclock" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "PLL_overclock" -library "lib_PLL_overclock" -name IP_TOOL_VERSION "17.0"
set_global_assignment -entity "PLL_overclock" -library "lib_PLL_overclock" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_PLL_overclock" -name SPD_FILE [file join $::quartus(sip_path) "PLL_overclock.spd"]

set_global_assignment -library "lib_PLL_overclock" -name MISC_FILE [file join $::quartus(sip_path) "PLL_overclock_sim/PLL_overclock.vho"]
