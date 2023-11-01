`include "FIFO_64x4.v"

module test_FIFO ();
wire n_full ,n_empty;
reg WE , RE ;
reg clk_in , clk_out ;
reg [63:0] Din ;
initial begin
    Din = 64'd1;
end
wire [63:0] Dout ;

initial begin
    $dumpfile("test_FIFO.vcd");
    $dumpvars();
end

initial begin
    clk_in = 0;
    forever begin
        #5 clk_in = (~clk_in);
    end
end


initial begin
    clk_out = 0;
    forever begin
        #7 clk_out = (~clk_out);
    end
end    

always @(posedge clk_in) begin
    if (WE) begin
        Din <= Din + 1'b1 ;
    end 
end
always @(*) begin
    WE = n_full ;
end
always @(*) begin
    RE = n_empty;
end


initial begin
    #500 ;
    $finish ;
end

FIFO_64x4 DUT1(.n_full(n_full),.Din(Din) ,.Dout(Dout) ,.clk_in(clk_in) ,.clk_out(clk_out) ,.WE(WE) ,.RE(RE),.n_empty(n_empty));
endmodule