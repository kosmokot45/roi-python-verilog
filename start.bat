iverilog -g2012 -o qqq roi.sv roi_tb.sv
vvp qqq
gtkwave roi.vcd