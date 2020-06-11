# TCL File Generated by Component Editor 18.1
# Fri Jun 12 01:32:28 CEST 2020
# DO NOT MODIFY


# 
# buttons_controller "buttons_controller" v1.0
#  2020.06.12.01:32:28
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module buttons_controller
# 
set_module_property DESCRIPTION ""
set_module_property NAME buttons_controller
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME buttons_controller
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL buttons_controller
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file buttons_controller.vhd VHDL PATH ../hdl/buttons_controller.vhd TOP_LEVEL_FILE


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
add_interface_port as as_read read Input 1
add_interface_port as as_readdata readdata Output 32
add_interface_port as as_write write Input 1
add_interface_port as as_writedata writedata Input 32
set_interface_assignment as embeddedsw.configuration.isFlash 0
set_interface_assignment as embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment as embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment as embeddedsw.configuration.isPrintableDevice 0


# 
# connection point interrupt_sender
# 
add_interface interrupt_sender interrupt end
set_interface_property interrupt_sender associatedAddressablePoint as
set_interface_property interrupt_sender associatedClock clock
set_interface_property interrupt_sender bridgedReceiverOffset ""
set_interface_property interrupt_sender bridgesToReceiver ""
set_interface_property interrupt_sender ENABLED true
set_interface_property interrupt_sender EXPORT_OF ""
set_interface_property interrupt_sender PORT_NAME_MAP ""
set_interface_property interrupt_sender CMSIS_SVD_VARIABLES ""
set_interface_property interrupt_sender SVD_ADDRESS_GROUP ""

add_interface_port interrupt_sender irq irq Output 1


# 
# connection point conduit
# 
add_interface conduit conduit end
set_interface_property conduit associatedClock clock
set_interface_property conduit associatedReset reset
set_interface_property conduit ENABLED true
set_interface_property conduit EXPORT_OF ""
set_interface_property conduit PORT_NAME_MAP ""
set_interface_property conduit CMSIS_SVD_VARIABLES ""
set_interface_property conduit SVD_ADDRESS_GROUP ""

add_interface_port conduit switch switch Input 10
add_interface_port conduit buttons buttons Input 3

