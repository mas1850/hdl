quartus_sh -t compile.tcl
pause
quartus_pgm --mode=JTAG -o P;output_files\processor.sof@2
pause