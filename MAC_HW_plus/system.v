`timescale 1ns/1ns
`include "param.v"
`include "SRAM_0.v"
`include "SRAM_1.v"
`include "FIFO_64x4.v"
`include "MAC_new.v"
module system ();
initial begin
    $dumpfile("MACsystem.vcd");
    $dumpvars();
end
reg clk_slow ;
initial begin
    clk_slow = 0;
    forever begin
        #7 clk_slow = (~clk_slow);
    end
end    
reg clk_quick ;
initial begin
    clk_quick = 0;
    forever begin
        #5 clk_quick = (~clk_quick);
    end
end    
initial begin
    #5000 ;
    $finish ;
end

// controller
wire WE , RE , n_empty , n_full ;
assign WE = n_full ;
assign RE = n_empty ;

// golden test data 
reg [`DATA_WIDTH-1:0] golden_mult , golden_add ;
initial begin
    golden_add = 3+1+2+6+0+5+0+0+3;
    golden_mult = 0 ;
end
localparam RESET_mult = 2'd0 ;
localparam RESET_add = 2'd3 ;
localparam MULT = 2'd1;
localparam ADD  = 2'd2;
reg [1:0] mode ;
initial begin
    mode= 0 ;
end
wire [`DATA_WIDTH-1:0] ramout0 , ramout1 ;
reg [3:0] addr_0 , addr_1 ;
initial begin
    addr_0 = 0 ;
    addr_1 = 0 ;
end
reg [3:0] count ;
initial begin 
    count = 0 ;
end
always @(posedge clk_quick) begin
    if (mode==MULT) begin
        if (mac_out==golden_mult) begin
            addr_0 <= 0 ;
            addr_1 <= 0 ;
            mode<=RESET_add;
            $display("MULT result = %d.",mac_out);
            $display("MULT TEST PASS");
        end else if (WE) begin
            addr_0 <= (addr_0==8)?(0):(addr_0+1) ;
            addr_1 <= 0 ;
        end
    end else if (mode==ADD) begin
        if (mac_out==golden_add) begin
            addr_0 <= 0 ;
            addr_1 <= 0 ;
            mode<=MULT;
            $display("ADD result = %d.",mac_out);
            $display("ADD TEST PASS");
            $finish ;
        end else if (WE) begin
                addr_0 <= (addr_0==8)?(0):(addr_0+1) ;
                addr_1 <= 0 ;
        end
    end else if (mode==RESET_mult) begin
        if (mac_out==0) begin
            addr_0 <= 0 ;
            addr_1 <= 0 ;
            mode<=MULT;
        end else begin
            addr_0 <= 1 ; // zero
            addr_1 <= 0 ;
        end
    end else if (mode==RESET_add) begin
        if (count==4'd8) begin
            addr_0 <= 0 ;
            addr_1 <= 0 ;
            count <= 0 ;
            mode<=ADD;
        end else begin
            count <= count+1;
            addr_0 <= 7 ; // zero
            addr_1 <= 7 ;
        end
    end
end
SRAM_0 SRAM0(.addr(addr_0),   .EN(WE),  .clk(clk_quick), .Dout(ramout0));
SRAM_1 SRAM1(.addr(addr_1),   .EN(WE),  .clk(clk_quick), .Dout(ramout1));

// output n_full , input [`DATA_WIDTH-1:0] Din , output reg [`DATA_WIDTH-1:0] Dout , input clk_in , input clk_out , input WE , input RE , output n_empty
wire [`DATA_WIDTH-1:0] data_0 , data_1 ;
FIFO_64x4 FIFO0(.n_full(n_full),  .Din(ramout0), .Dout(data_0), .clk_in(clk_quick),  .clk_out(clk_slow), .WE(WE),  .RE(RE),  .n_empty(n_empty));
FIFO_64x4 FIFO1(.n_full(),  .Din(ramout1), .Dout(data_1),   .clk_in(clk_quick),  .clk_out(clk_slow), .WE(WE),  .RE(RE),  .n_empty());

wire [`DATA_WIDTH-1:0] mac_out ;
reg mulsel , addsel ;
MAC_new DUT(.clk(clk_slow), .mulsel(mulsel),  .addsel(addsel),  .data_0(data_0),  .data_1(data_1),  .mac_out(mac_out));
always @(*) begin
    case (mode)
        MULT: begin
            mulsel = 1 ;
            addsel = 0 ;
        end 
        ADD : begin
            mulsel = 0 ;
            addsel = 1 ;
        end
        default: begin
            mulsel = 0 ;
            addsel = 0 ;
        end
    endcase
end
    
endmodule