module MAC_new (
    input clk ,
    input mulsel,
    input addsel,
    input [`DATA_WIDTH-1:0] data_0 ,
    input [`DATA_WIDTH-1:0] data_1 ,
    output reg [`DATA_WIDTH-1:0] mac_out
);
reg [`DATA_WIDTH-1:0] mult_out ;
initial begin
    mult_out=1;
end
always @(posedge clk) begin
    mult_out <= (mulsel)?(data_0 * mult_out):(data_0 * data_1);
    mac_out <=  (addsel)? (mult_out+mac_out):(mult_out);
end

endmodule