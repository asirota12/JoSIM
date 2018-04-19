#pragma once
#include "j_std_include.hpp"

/*
	Function that writes the output file as requested by the user
*/
void write_data(InputFile& iFile);
/*
	Function that writes a legacy output file in JSIM_N format
*/
void write_legacy_data(InputFile& iFile);