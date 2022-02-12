File {
* input files:
Grid = "CONTACTS_fps.tdr"
* output files:
Plot = "n1_des.tdr"
Current = "n1_des.plt"
Output = "n1_des.log"
}
Electrode {
{ Name="source" Voltage=0.0 }
{ Name="drain" Voltage=0 }
{ Name="gate" Voltage=0 Barrier=-0.51 }
{ Name="substrate" Voltage=0.0 }
}
Physics {
Mobility (DopingDependence HighFieldSat )
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
Save (FilePrefix="vg0")

Quasistationary
(InitialStep=0.1 Maxstep=0.1 MinStep=0.01
Goal { name="gate" voltage=.25 } )
{ Coupled { Poisson Electron Hole } }
Save(FilePrefix="vg25")

Quasistationary
(InitialStep=0.1 Maxstep=0.1 MinStep=0.01
Goal { name="gate" voltage=.5 } )
{ Coupled { Poisson Electron Hole } }
Save(FilePrefix="vg05")

Quasistationary
(InitialStep=0.1 Maxstep=0.1 MinStep=0.01
Goal { name="gate" voltage=.75 } )
{ Coupled { Poisson Electron Hole } }
Save(FilePrefix="vg75")

Quasistationary
(InitialStep=0.1 Maxstep=0.1 MinStep=0.01
Goal { name="gate" voltage=1.0 } )
{ Coupled { Poisson Electron Hole } }
Save(FilePrefix="vg1")

Quasistationary
(InitialStep=0.1 Maxstep=0.1 MinStep=0.01
Goal { name="gate" voltage=1.25 } )
{ Coupled { Poisson Electron Hole } }
Save(FilePrefix="vg125")

Quasistationary
(InitialStep=0.1 Maxstep=0.1 MinStep=0.01
Goal { name="gate" voltage=1.5 } )
{ Coupled { Poisson Electron Hole } }
Save(FilePrefix="vg15")

Quasistationary
(InitialStep=0.1 Maxstep=0.1 MinStep=0.01
Goal { name="gate" voltage=1.75 } )
{ Coupled { Poisson Electron Hole } }
Save(FilePrefix="vg175")

Quasistationary
(InitialStep=0.1 Maxstep=0.1 MinStep=0.01
Goal { name="gate" voltage=2.0 } )
{ Coupled { Poisson Electron Hole } }
Save(FilePrefix="vg2")

Load(FilePrefix="vg0")
NewCurrentPrefix="vg0_"
Quasistationary
(InitialStep=0.01 Maxstep=0.1 MinStep=0.0001
Goal{ name="drain" voltage=3.0 }
)
{ Coupled {Poisson Electron Hole }
CurrentPlot (time=
(range = (0 0.2) intervals=20;
range = (0.2 1.0)))}

Load(FilePrefix="vg25")
NewCurrentPrefix="vg25_"
Quasistationary
(InitialStep=0.01 Maxstep=0.1 MinStep=0.0001
Goal{ name="drain" voltage=3.0 }
)
{ Coupled {Poisson Electron Hole }
CurrentPlot (time=
(range = (0 0.2) intervals=20;
range = (0.2 1.0)))}

Load(FilePrefix="vg05")
NewCurrentPrefix="vg05_"
Quasistationary
(InitialStep=0.01 Maxstep=0.1 MinStep=0.0001
Goal{ name="drain" voltage=3.0 }
)
{ Coupled {Poisson Electron Hole }
CurrentPlot (time=
(range = (0 0.2) intervals=20;
range = (0.2 1.0)))}

Load(FilePrefix="vg75")
NewCurrentPrefix="vg75_"
Quasistationary
(InitialStep=0.01 Maxstep=0.1 MinStep=0.0001
Goal{ name="drain" voltage=3.0 }
)
{ Coupled {Poisson Electron Hole }
CurrentPlot (time=
(range = (0 0.2) intervals=20;
range = (0.2 1.0)))}

Load(FilePrefix="vg1")
NewCurrentPrefix="vg1_"
Quasistationary
(InitialStep=0.01 Maxstep=0.1 MinStep=0.0001
Goal{ name="drain" voltage=3.0 }
)
{Coupled {Poisson Electron Hole }
CurrentPlot (time=
(range = (0 0.2) intervals=20;
range = (0.2 1.0)))}

Load(FilePrefix="vg125")
NewCurrentPrefix="vg125_"
Quasistationary
(InitialStep=0.01 Maxstep=0.1 MinStep=0.0001
Goal{ name="drain" voltage=3.0 }
)
{ Coupled {Poisson Electron Hole }
CurrentPlot (time=
(range = (0 0.2) intervals=20;
range = (0.2 1.0)))}

Load(FilePrefix="vg15")
NewCurrentPrefix="vg15_"
Quasistationary
(InitialStep=0.01 Maxstep=0.1 MinStep=0.0001
Goal{ name="drain" voltage=3.0 }
)
{ Coupled {Poisson Electron Hole }
CurrentPlot (time=
(range = (0 0.2) intervals=20;
range = (0.2 1.0)))}

Load(FilePrefix="vg175")
NewCurrentPrefix="vg175_"
Quasistationary
(InitialStep=0.01 Maxstep=0.1 MinStep=0.0001
Goal{ name="drain" voltage=3.0 }
)
{ Coupled {Poisson Electron Hole }
CurrentPlot (time=
(range = (0 0.2) intervals=20;
range = (0.2 1.0)))}

Load(FilePrefix="vg2")
NewCurrentPrefix="vg2_"
Quasistationary
(InitialStep=0.01 Maxstep=0.1 MinStep=0.0001
Goal{ name="drain" voltage=3.0 }
)
{ Coupled {Poisson Electron Hole }
CurrentPlot (time=
(range = (0 0.2) intervals=20;
range = (0.2 1.0)))}

}
