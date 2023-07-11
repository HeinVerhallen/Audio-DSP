set_global_assignment -entity "PLL_audio_codec" -library "lib_PLL_audio_codec" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "PLL_audio_codec" -library "lib_PLL_audio_codec" -name IP_TOOL_VERSION "17.0"
set_global_assignment -entity "PLL_audio_codec" -library "lib_PLL_audio_codec" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_PLL_audio_codec" -name SPD_FILE [file join $::quartus(sip_path) "PLL_audio_codec.spd"]

set_global_assignment -library "lib_PLL_audio_codec" -name MISC_FILE [file join $::quartus(sip_path) "PLL_audio_codec_sim/PLL_audio_codec.vho"]
