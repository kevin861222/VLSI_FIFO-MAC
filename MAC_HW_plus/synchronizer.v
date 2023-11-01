`timescale 1ns/1ns

module tester ();
    initial begin
        $dumpfile("synchronizer.vcd");
        $dumpvars();
    end
    reg clk_A , clk_B , Din ;
    wire Dout ;

    initial begin
        clk_A = 0;
        forever begin
            #7 clk_A = (~clk_A);
        end
    end

    initial begin
        clk_B = 0;
        forever begin
            #5 clk_B = (~clk_B);
        end
    end    

    initial begin
        Din = 0 ;
        forever begin
            @(posedge clk_A);
            #1; Din = (~Din);
        end
    end

    initial begin
        #300 ;
        $finish ;
    end

    synchronizer DUT1 (.clk_A(clk_A),.clk_B(clk_B),.Din(Din),.Dout(Dout));




endmodule


module synchronizer (
    input clk_A , input clk_B , input Din , output reg Dout
);
    reg Dout_A;
    always @(posedge clk_A) begin
        Dout_A <= Din ;
    end

    reg Dout_B;
    always @(posedge clk_B) begin
        Dout_B <= Dout_A;
        Dout   <= Dout_B;
    end
endmodule