module SRAM_1 (
    input [3:0] addr ,
    output reg [`DATA_WIDTH-1:0] Dout ,
    input EN ,
    input clk 
);
reg [`DATA_WIDTH-1:0] RAM [8:0] ;
initial begin

    RAM[0]=1;

    RAM[1]=6;

    RAM[2]=5;

    RAM[3]=0;

    // other addr
    RAM[4]=0;
    RAM[5]=0;
    RAM[6]=0;
    RAM[7]=0;
    RAM[8]=0;

end

always @(posedge clk) begin
    if (EN) begin
        Dout <= RAM[addr] ;
    end
end
    
endmodule