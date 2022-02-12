math coord.ucs
AdvancedCalibration
pdbSet Grid Adaptive 1
pdbSet Grid SnMesh UseLines 1
pdbSet Grid SnMesh min.normal.size 80<nm>
pdbSet Grid SnMesh normal.growth.ratio.2d 1.4
pdbSet Diffuse Compute.Regrid.Steps 10
pdbSet Diffuse Growth.Regrid.Steps 10
math numThreadsInterp=2

;# list of all relevant dimensional parameters
;# all values in um
set l_locos     2           
set l_contact   2
set l_gate      2
set sim_extension 1.5
set l_sim       [expr 2 * $l_locos + 2 * $l_contact + $l_gate + $sim_extension]
set t_bottom    1.5

;# define simulation area
;# we start with 1D processes, so leave 1D for now
line x location=0.0 tag=SiTop spacing=80<nm>
line x location=$t_bottom<um> tag=SiBottom spacing=80<nm>

region Silicon
init concentration=1.0e+15<cm-3> field=Boron wafer.orient=100

;# initial implant
implant Boron dose=4.0e13<cm-2> energy=100<keV> tilt=7

;# growth of stress relief SiO2
temp_ramp name= stress_ramp temp=800<C>  t.final=850<C>  time=5<min>   N2 
temp_ramp name= stress_ramp temp=850<C>  time=10<min>   N2 
temp_ramp name= stress_ramp temp=850<C>  time=12<min>  H2O  
temp_ramp name= stress_ramp temp=850<C>  time=10<min>   N2 
temp_ramp name= stress_ramp temp=850<C> t.final=800<C>   time=8.25<min>   N2
diffuse temp_ramp= stress_ramp
temp_ramp clear
gas_flow  clear 

;# deposition of Si3N4; not worried about temp here
set t_nitride   .2
deposit 1D Nitride type=isotropic thickness=$t_nitride<um>


;# definition of two dimensional geometry
set refine_size .02
line y location=-$sim_extension tag=SimLeft spacing=125<nm>
line y location=$l_sim<um> tag=SimRight spacing=125<nm>
set refine_box_w    .08
set gate_stack_refine_l      [expr $l_locos + $l_contact + .5 * $l_gate - .5 * $refine_box_w]
set gate_stack_refine_r      [expr $l_locos + $l_contact + .5 * $l_gate + .5 * $refine_box_w]
refinebox min= {-10 $gate_stack_refine_l} max= {10 $gate_stack_refine_r} xrefine= $refine_size yrefine=$refine_size

set para_1_refine_l      [expr .5 * $l_locos - .5 * $refine_box_w]
set para_1_refine_r      [expr .5 * $l_locos + .5 * $refine_box_w]
refinebox min= {-10 $para_1_refine_l} max= {10 $para_1_refine_r} xrefine= $refine_size yrefine=$refine_size

set contact_refine_l      [expr .5 * $l_contact + $l_locos - .5 * $refine_box_w]
set contact_refine_r      [expr .5 * $l_contact + $l_locos + .5 * $refine_box_w]
refinebox min= {-10 $contact_refine_l} max= {10 $contact_refine_r} xrefine= $refine_size yrefine=$refine_size

set para_2_refine_l      [expr $l_sim - $sim_extension - .5 * $l_locos - .5 * $refine_box_w]
set para_2_refine_r      [expr $l_sim - $sim_extension - .5 * $l_locos + .5 * $refine_box_w]
refinebox min= {-10 $para_2_refine_l} max= {10 $para_2_refine_r} xrefine= $refine_size yrefine=$refine_size

;# etch holes in nitride mask
set r_locos_start       [expr $l_locos + 2 * $l_contact + $l_gate]
set r_locos_end         [expr 2 * $l_locos + 2 * $l_contact + $l_gate]
mask name=nitride_mask segments = {0.0 $l_locos<um> $r_locos_start<um> $r_locos_end<um>} negative
etch Nitride type=anisotropic thickness="1.001 * $t_nitride"<um> mask=nitride_mask

;# isolation implant; step 2.7
implant Boron dose=1.0e15<cm-2> energy=30<keV> tilt=7

struct tdr=POST_ISO_IMPL

;# pre-diffusion clean; step 2.79
set hf_etch .0025 
etch Oxide type=anisotropic thickness=$hf_etch<um>

struct tdr=TESTING

;# LOCOS growth; step 2.8
temp_ramp name= locos_ramp temp=800<C>  t.final=1000<C>  time=20<min>   N2 
temp_ramp name= locos_ramp temp=1000<C>  time=10<min>   N2 
temp_ramp name= locos_ramp temp=1000<C> t.final=1000<C>  time=100<min>  H2O  
temp_ramp name= locos_ramp temp=1000<C>  time=10<min>   N2 
temp_ramp name= locos_ramp temp=1000<C> t.final=800<C>   time=33<min>   N2
diffuse temp_ramp= locos_ramp 
temp_ramp clear
gas_flow  clear 

;# oxidized nitride strip; step 2.85 (.75min * .09um/min)
etch Oxide type=anisotropic thickness=.0675<um>

;# remove nitride; step 2.90
;# Overetch? approximating by just etching oxide where no nitride exists
etch Oxide type=anisotropic thickness=.0068<um>
strip nitride

;# pre-diffusion clean; step 2.93
etch Oxide type=anisotropic thickness=$hf_etch<um>

;# Kooi oxidation; step 2.95
diffuse temperature=850<C> time=15<min> H2O

;# pre diffusion clean; step 3.0
etch Oxide type=anisotropic thickness=$hf_etch<um>

;# Kooi oxide strip; something like .005um/min for 11 min; step 3.05
etch Oxide type=anisotropic thickness=.055<um>  ;# what thickness?

;# gate oxide; step 3.15
temp_ramp name= gate_ramp temp=800<C>  t.final=900<C>  time=10<min>   N2 
temp_ramp name= gate_ramp temp=900<C>  time=10<min>   N2 
temp_ramp name= gate_ramp temp=900<C>  time=20<min>   O2  
temp_ramp name= gate_ramp temp=900<C>  time=10<min>   N2 
temp_ramp name= gate_ramp temp=900<C> t.final=800<C>   time=16.5<min>   N2
diffuse temp_ramp= gate_ramp
temp_ramp clear
gas_flow  clear

struct tdr=PRE_POLY

;# deposition of gate poly (exact thickness?); step 3.2
set t_gate  .25
deposit Polysilicon type=isotropic thickness=$t_gate<um>

;# etch poly
set locos_gate_start       [expr 0]
set locos_gate_end         [expr $l_locos]
set main_gate_start        [expr $l_locos + $l_contact]
set main_gate_end          [expr $l_locos + $l_contact + $l_gate]
mask name=gate_poly_mask segments = {$locos_gate_start<um> $locos_gate_end<um> $main_gate_start<um> $main_gate_end<um>}
etch Polysilicon type=anisotropic thickness="1.15 * $t_gate"<um> mask=gate_poly_mask

;# step 3.6 -- poly over-etch??

struct tdr=POST_POLY

;# polymer sidewall strip; step 3.7
etch Oxide type=anisotropic thickness=$hf_etch<um>

;# gate + s/d implant
implant Phosphorus dose=5.0e15<cm-2> energy=50<keV> tilt=7

struct tdr=POST_SD_IMPL

;# pre diffusion clean; step 3.9
etch Oxide type=anisotropic thickness=$hf_etch<um>

;# LTO growth; step 4.0
set t_lto    0.6
deposit Oxide type=isotropic thickness=$t_lto<um>

;# lto densification; step 4.1
temp_ramp name= densify_ramp temp=800<C>  t.final=950<C>  	time=15<min>   N2
temp_ramp name= densify_ramp temp=950<C>  time=10<min>   N2 
temp_ramp name= densify_ramp temp=950<C> t.final=950<C>  	time=30<min>   H2O
temp_ramp name= densify_ramp temp=950<C>  time=10<min>   N2 
temp_ramp name= densify_ramp temp=950<C> t.final=800<C>  	time=25<min>   N2
diffuse temp_ramp= densify_ramp 
temp_ramp clear
gas_flow  clear 

struct tdr=POST_LTO

;# LTO etching (overetch?); step 4.5
set l_metal_contact     .75
set start_l_contact       [expr $l_locos + .5 * $l_contact - .5 * $l_metal_contact]
set end_l_contact         [expr $l_locos + .5 * $l_contact + .5 * $l_metal_contact]
set start_r_contact       [expr $l_locos + $l_gate + 1.5 * $l_contact - .5 * $l_metal_contact]
set end_r_contact         [expr $l_locos + $l_gate + 1.5 * $l_contact + .5 * $l_metal_contact]
set start_para_1_contact       [expr -.5 * $l_contact - .5 * $l_metal_contact]
set end_para_1_contact         [expr -.5 * $l_contact + .5 * $l_metal_contact]
set start_para_2_contact       [expr $l_sim - $sim_extension + .5 * $l_contact - .5 * $l_metal_contact]
set end_para_2_contact         [expr $l_sim - $sim_extension + .5 * $l_contact + .5 * $l_metal_contact]
mask name=contact_mask segments = {$start_para_1_contact<um> $end_para_1_contact<um> $start_l_contact<um> $end_l_contact<um> 
    $start_r_contact<um> $end_r_contact<um> $start_para_2_contact<um> $end_para_2_contact<um>} negative
etch Oxide type=anisotropic thickness="1.15 * $t_lto"<um> mask=contact_mask

;# pre metal clean; step 4.7
etch Oxide type=anisotropic thickness=$hf_etch<um>

;# Contact formation
set t_ti    .005
set t_tin   .020
set t_al    .6
deposit Titanium type=isotropic thickness=$t_ti<um>
deposit TiNitride type=isotropic thickness=$t_tin<um>
deposit Aluminum type=isotropic thickness=$t_al<um>


struct tdr=FINAL_STRUCT
