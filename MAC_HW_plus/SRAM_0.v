module SRAM_0 (
    input [3:0] addr ,
    output reg [`DATA_WIDTH-1:0] Dout ,
    input EN ,
    input clk 
);
reg [`DATA_WIDTH-1:0] RAM [8:0] ;
initial begin
    RAM[0]=3;
    RAM[1]=1;
    RAM[2]=2;
    RAM[3]=6;
    RAM[4]=0;
    RAM[5]=5;
    RAM[6]=0;
    RAM[7]=0;
    RAM[8]=3;
    // other addr
end

always @(posedge clk) begin
    if (EN) begin
        Dout <= RAM[addr] ;
    end
end
    
endmodule