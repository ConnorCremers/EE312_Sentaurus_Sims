File {
* input files:
Grid = "CONTACTS_fps.tdr"
* output files:
Plot = "vt_extract.tdr"
Current = "vt_extract.plt"
Output = "vt_extract.log"
}
Electrode {
{ Name="source" Voltage=0}
#{ Name="para_2_source" Voltage=0 Barrier=-.272 }
#{ Name="para_1_drain" Voltage=0 Barrier=-.272 }
{ Name="drain" Voltage=0 }
{ Name="gate" Voltage=0 Barrier=-0.51 }
#{ Name="para_1_gate" Voltage=0 Barrier=-0.51 }
#{ Name="para_2_gate" Voltage=0 Barrier=-0.272 }
{ Name="substrate" Voltage=0.0 }
}
Physics {
Mobility (DopingDependence HighFieldSat Enormal)
EffectiveIntrinsicDensity (BandGapNarrowing (OldSlotboom))
}
Plot {
eDensity hDensity eCurrent hCurrent
Potential SpaceCharge ElectricField
eMobility hMobility eVelocity hVelocity
Doping DonorConcentration AcceptorConcentration
}
Math {
Extrapolate
RelErrControl
}
Solve {
#-initial solution:
Poisson
Coupled { Poisson Electron Hole }
#-ramp gate:
Quasistationary ( MaxStep=0.01
Goal{ Name="drain" Voltage=5 } 
Goal{ Name="gate" Voltage=5 } )
{ Coupled { Poisson Electron Hole } }
}
