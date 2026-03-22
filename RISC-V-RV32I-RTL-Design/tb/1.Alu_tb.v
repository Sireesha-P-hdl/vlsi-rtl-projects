`timescale 1ns / 1ps
module ALU_tb();
    reg [31:0] in1;
    reg [31:0] in2;
    reg [3:0]op;
    wire [31:0]res;
    ALU uut( in1, in2,op,res);
    initial 
    begin
    in1=32'h00000004;
    in2=32'h00000002;
    op=4'b0000;
    #10;
    op=4'b0000;
    #10;
    #10;
    op=4'b1000;
    #10;
    #10;
    op=4'b0010;
    #10;
    #10;
    op=4'b0011;
    #10;
    #10;
    op=4'b0111;
    #10;
    #10;
    op=4'b0110;
    #10;
    #10;
    op=4'b0010;
    #10;
    #10;
    op=4'b0001;
    #10;
    #10;
    op=4'b0101;
    #10;
    #10;
    op=4'b1101;
    #10;
    $finish;
    end

endmodule
    
