module roi #(
  parameter WIDTH      = 800,
  parameter HEIGHT     = 534,
  parameter PIXEL_SIZE = 8
)(
  input logic                      clk,
  input logic                      rst_n,
  // control interface
  input logic [$clog2( WIDTH)-1:0] roi_start_x_i,
  input logic [$clog2(HEIGHT)-1:0] roi_start_y_i,
  input logic [$clog2( WIDTH)-1:0] roi_end_x_i,
  input logic [$clog2(HEIGHT)-1:0] roi_end_y_i,
  // input interface
  input logic [PIXEL_SIZE-1:0]     data_i,
  input logic                      valid_i,
  input logic                      last_i,
  // output interface
  output logic [PIXEL_SIZE-1:0]    data_o,
  output logic                     valid_o,
  output logic                     last_o
);

logic [$clog2(WIDTH)-1:0]  cnt_w;
logic [$clog2(HEIGHT)-1:0] cnt_h;

always_ff @( posedge clk, negedge rst_n ) begin
  if (rst_n) begin 
    cnt_w <= 0;
    cnt_h <= 0;
  end
  else begin
    if (valid_i) begin
      if (cnt_w < WIDTH)
        cnt_w <= cnt_w + 1;
      else begin
        cnt_w <= 1;
        cnt_h <= cnt_h + 1; 
      end
    end
    else begin
      cnt_w <= 0;
      cnt_h <= 0;
    end
  end
end

always_ff @( posedge clk, negedge rst_n) begin
  if (rst_n) begin 
    data_o <= 0;
    valid_o <= 0;
    last_o <= 0;
  end
  else begin
    if (valid_i) begin
      if (cnt_w >= roi_start_x_i & cnt_w <= roi_end_x_i & cnt_h >= roi_start_y_i & cnt_h <= roi_end_y_i) begin
        valid_o <= 1;
        data_o <= data_i;
        if (cnt_h == roi_end_y_i & cnt_w == roi_end_x_i)
          last_o <= 1;
      end
      else begin
        valid_o <= 0;
        last_o <= 0;
      end
    end
  end
end

endmodule