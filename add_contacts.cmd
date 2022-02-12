pdbSet Grid Adaptive 1
pdbSet Grid SnMesh UseLines 1
math coord.ucs
AdvancedCalibration
pdbSet Grid SnMesh min.normal.size 100<nm>
pdbSet Grid SnMesh normal.growth.ratio.2d 1.4
math numThreadsInterp=2

set test [pdbGet Oxide H2O B0.h]
LogFile "$test"
set test [pdbGet Oxide H2O BW.h]
LogFile "$test"

;# list of all relevant dimensional parameters
;# all values in um
set l_locos     2           
set l_contact   2
set l_gate      2
set sim_extension 1.5
set l_sim       [expr 2 * $l_locos + 2 * $l_contact + $l_gate + $sim_extension]
set t_bottom    1.5

;# define simulation area

init tdr=FINAL_STRUCT

set t_nitride   .2
set r_locos_start       [expr $l_locos + 2 * $l_contact + $l_gate]
set r_locos_end         [expr 2 * $l_locos + 2 * $l_contact + $l_gate]
set t_gate  .25
set locos_gate_start       [expr 0]
set locos_gate_end         [expr $l_locos]
set main_gate_start        [expr $l_locos + $l_contact]
set main_gate_end          [expr $l_locos + $l_contact + $l_gate]
set t_lto    0.6
set l_metal_contact     .75
set start_l_contact       [expr $l_locos + .5 * $l_contact - .5 * $l_metal_contact]
set end_l_contact         [expr $l_locos + .5 * $l_contact + .5 * $l_metal_contact]
set start_r_contact       [expr $l_locos + $l_gate + 1.5 * $l_contact - .5 * $l_metal_contact]
set end_r_contact         [expr $l_locos + $l_gate + 1.5 * $l_contact + .5 * $l_metal_contact]
set start_para_1_contact       [expr -.5 * $l_contact - .5 * $l_metal_contact]
set end_para_1_contact         [expr -.5 * $l_contact + .5 * $l_metal_contact]
set start_para_2_contact       [expr $l_sim - $sim_extension + .5 * $l_contact - .5 * $l_metal_contact]
set end_para_2_contact         [expr $l_sim - $sim_extension + .5 * $l_contact + .5 * $l_metal_contact]
set t_ti    .005
set t_tin   .020
set t_al    .6

set t_metal_etch          [expr 1.1 * ($t_ti + $t_tin + $t_al)]
mask name=contacts segments = {0 $l_locos $main_gate_start<um> $main_gate_end<um> 
    $end_r_contact $r_locos_start $r_locos_end $start_para_2_contact} negative
etch material= {Aluminum TiNitride Titanium} type=anisotropic thickness=$t_metal_etch<um> mask=contacts

contact name= gate region= PolySilicon_1.1
contact name= para_1_gate region= PolySilicon_1.4
contact name= para_2_gate region= Titanium_1.5

contact name= drain region= Aluminum_1.2
contact name= source region= Aluminum_1.4

contact name= para_1_drain region= Titanium_1.3
contact name= para_2_source region= Titanium_1.1
contact bottom name= substrate
struct tdr=CONTACTS

set gate_stack_slice      [expr $l_locos + $l_contact + .5 * $l_gate]
set para_1_slice      [expr .5 * $l_locos]
set contact_slice      [expr .5 * $l_contact + $l_locos]
set para_2_slice      [expr $l_sim - $sim_extension - .5 * $l_locos]

diffuse temperature=800<C> time=0<min>

SheetResistance y=$gate_stack_slice
SheetResistance y=$contact_slice
select z=NetActive
set layerInfo [layers y=$gate_stack_slice]
slice y= $gate_stack_slice

set layerInfo [layers y=$para_1_slice]
slice y= $para_1_slice

set layerInfo [layers y=$contact_slice]
slice y= $contact_slice

set layerInfo [layers y=$para_2_slice]
slice y= $para_2_slice