set_global_assignment -entity "PLL_MLCK" -library "lib_PLL_MLCK" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "PLL_MLCK" -library "lib_PLL_MLCK" -name IP_TOOL_VERSION "17.0"
set_global_assignment -entity "PLL_MLCK" -library "lib_PLL_MLCK" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_PLL_MLCK" -name SPD_FILE [file join $::quartus(sip_path) "PLL_MLCK.spd"]

set_global_assignment -library "lib_PLL_MLCK" -name MISC_FILE [file join $::quartus(sip_path) "PLL_MLCK_sim/PLL_MLCK.vho"]
