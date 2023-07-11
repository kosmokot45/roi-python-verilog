`timescale 1ns/100ps
module roi_tb();

parameter WIDTH = 1920;
parameter HEIGHT = 1080;
parameter PIXEL_SIZE = 8;

logic clk = 1'b0;
logic rst_n = 1'b0;

always begin #10 clk = ~clk; end
// w = roi_end_x_i - roi_start_x_i + 1
// h = roi_end_y_i - roi_start_y_i + 1
logic [$clog2( WIDTH)-1:0] roi_start_x_i = 1320;
logic [$clog2(HEIGHT)-1:0] roi_start_y_i = 280;
logic [$clog2( WIDTH)-1:0] roi_end_x_i = 1420;
logic [$clog2(HEIGHT)-1:0] roi_end_y_i = 380;
// input interface
logic [PIXEL_SIZE-1:0]     data_i = 0;
logic                      valid_i = 0;
logic                      last_i = 0;
// output interface
wire [PIXEL_SIZE-1:0]    data_o;
wire valid_o;
wire last_o;

roi  #( WIDTH, HEIGHT, PIXEL_SIZE ) 
    roi_dut
    (   .clk(clk),
        .roi_start_x_i(roi_start_x_i),
        .roi_start_y_i(roi_start_y_i),
        .roi_end_x_i(roi_end_x_i),
        .roi_end_y_i(roi_end_y_i),
        .data_i(data_tst),
        .valid_i(valid_tst),
        .last_i(last_tst),
        .data_o(data_o),
        .valid_o(valid_o),
        .last_o(last_o),
        .rst_n(rst_n)
);

initial begin
    #10 rst_n = 1'b1;
    #10 rst_n = 1'b0;
end

integer times = WIDTH*HEIGHT*21;
initial begin
    $dumpfile("roi.vcd");
    $dumpvars();
    $display("testing...");
    #times $finish;
end

logic [7:0] image_i [(WIDTH*HEIGHT):0];
logic [7:0] image_o [(WIDTH*HEIGHT):0];

logic [7:0] data_tst = 0;
logic valid_tst = 0;
logic last_tst = 0;

int size = WIDTH * HEIGHT;
int fd_i;

initial begin
    #50010;
    fd_i = $fopen("data_to_fpga.txt", "r");
    #20 valid_tst = 1;
    while (! $feof(fd_i)) begin
            #20;
            $fscanf(fd_i, "%d\n", data_tst);
    end
    last_tst = 1;
    $fclose(fd_i);
    #20;
    data_tst = 0;
    valid_tst = 0;
    last_tst = 0;
end

int j = 0;
logic [7:0] image_tst_o [0:(WIDTH*HEIGHT)];

int fd_o;

initial begin
    fd_o = $fopen("data_from_fpga.txt", "w");
    #10;
    for (j=0; j < times; j++) begin
        #20;
        if (valid_o) begin
            $fdisplay(fd_o, data_o);
            if (last_o)
                $fclose(fd_o);
        end
    end
end

endmodule