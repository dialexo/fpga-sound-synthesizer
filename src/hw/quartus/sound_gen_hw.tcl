# TCL File Generated by Component Editor 18.1
# Sat Jun 13 18:06:06 CEST 2020
# DO NOT MODIFY


# 
# sound_gen "sound_gen" v1.0
#  2020.06.13.18:06:06
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module sound_gen
# 
set_module_property DESCRIPTION ""
set_module_property NAME sound_gen
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME sound_gen
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL sound_gen
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file sound_gen.vhd VHDL PATH ../hdl/sound_gen.vhd TOP_LEVEL_FILE
add_fileset_file linear_diff.vhd VHDL PATH ../hdl/linear_diff.vhd
add_fileset_file osc.vhd VHDL PATH ../hdl/osc.vhd


# 
# parameters
# 


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset_n reset_n Input 1


# 
# connection point as
# 
add_interface as avalon end
set_interface_property as addressUnits WORDS
set_interface_property as associatedClock clock
set_interface_property as associatedReset reset
set_interface_property as bitsPerSymbol 8
set_interface_property as burstOnBurstBoundariesOnly false
set_interface_property as burstcountUnits WORDS
set_interface_property as explicitAddressSpan 0
set_interface_property as holdTime 0
set_interface_property as linewrapBursts false
set_interface_property as maximumPendingReadTransactions 0
set_interface_property as maximumPendingWriteTransactions 0
set_interface_property as readLatency 0
set_interface_property as readWaitTime 1
set_interface_property as setupTime 0
set_interface_property as timingUnits Cycles
set_interface_property as writeWaitTime 0
set_interface_property as ENABLED true
set_interface_property as EXPORT_OF ""
set_interface_property as PORT_NAME_MAP ""
set_interface_property as CMSIS_SVD_VARIABLES ""
set_interface_property as SVD_ADDRESS_GROUP ""

add_interface_port as as_address address Input 2
add_interface_port as as_write write Input 1
add_interface_port as as_writedata writedata Input 32
set_interface_assignment as embeddedsw.configuration.isFlash 0
set_interface_assignment as embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment as embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment as embeddedsw.configuration.isPrintableDevice 0


# 
# connection point audio
# 
add_interface audio conduit end
set_interface_property audio associatedClock clock
set_interface_property audio associatedReset ""
set_interface_property audio ENABLED true
set_interface_property audio EXPORT_OF ""
set_interface_property audio PORT_NAME_MAP ""
set_interface_property audio CMSIS_SVD_VARIABLES ""
set_interface_property audio SVD_ADDRESS_GROUP ""

add_interface_port audio aud_clk12 aud_clk12 Input 1
add_interface_port audio aud_daclrck aud_daclrck Output 1
add_interface_port audio aud_dacdat aud_dacdat Output 1


# 
# connection point debug
# 
add_interface debug conduit end
set_interface_property debug associatedClock clock
set_interface_property debug associatedReset ""
set_interface_property debug ENABLED true
set_interface_property debug EXPORT_OF ""
set_interface_property debug PORT_NAME_MAP ""
set_interface_property debug CMSIS_SVD_VARIABLES ""
set_interface_property debug SVD_ADDRESS_GROUP ""

add_interface_port debug debug_daclrck debug_daclrck Output 1
add_interface_port debug debug_dacdat debug_dacdat Output 1


# 
# connection point vu_meter
# 
add_interface vu_meter conduit end
set_interface_property vu_meter associatedClock clock
set_interface_property vu_meter associatedReset ""
set_interface_property vu_meter ENABLED true
set_interface_property vu_meter EXPORT_OF ""
set_interface_property vu_meter PORT_NAME_MAP ""
set_interface_property vu_meter CMSIS_SVD_VARIABLES ""
set_interface_property vu_meter SVD_ADDRESS_GROUP ""

add_interface_port vu_meter vu_meter vu_meter Output 10

