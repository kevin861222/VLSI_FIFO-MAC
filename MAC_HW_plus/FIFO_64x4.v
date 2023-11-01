`include "param.v"

module FIFO_64x4
// #(parameter DATA_WIDTH = `DATA_WIDTH)
(output n_full , input [`DATA_WIDTH-1:0] Din , output reg [`DATA_WIDTH-1:0] Dout , input clk_in , input clk_out , input WE , input RE , output n_empty);
reg [`DATA_WIDTH-1:0] RAM [0:3] ; 
reg [2:0] in_count , out_count ;
initial begin
    in_count = 2'd0 ;
    out_count = 2'd0 ;
end

always @(posedge clk_in) begin
    if (WE) begin
        RAM[in_count[1:0]] <= Din;
        if (in_count[2]&&out_count[2]) begin
            in_count <= {1'b0,in_count[1:0]}+1'b1;
            out_count <= {1'b0,out_count[1:0]} ;
        end else begin
            in_count <= in_count+1'b1 ;
        end
    end
end

always @(posedge clk_out) begin
    if (RE) begin
        Dout <= RAM[out_count[1:0]] ;
        if (in_count[2]&&out_count[2]) begin
            out_count <= {1'b0,out_count[1:0]}+1'b1;
            in_count <= {1'b0,in_count[1:0]};
        end else begin
            out_count <= out_count+1'b1 ;
        end
    end
end

assign n_full = ~(in_count==out_count+3'd3) ;
assign n_empty = ~(in_count==out_count) ;

endmodule