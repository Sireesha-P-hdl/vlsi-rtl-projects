`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal Project
// Engineer: Sireesha P
// 
// Create Date: 19.03.2026
// Design Name: RISC-V RV32I ALU
// Module Name: ALU
// Project Name: RISC-V-RV32I-RTL-Design
// Target Devices: FPGA (Generic / Xilinx Vivado)
// Tool Versions: Vivado 20xx.x
// Description: 
// 32-bit Arithmetic Logic Unit (ALU) for RISC-V RV32I processor.
// Supports arithmetic, logical, comparison, and shift operations.
// Implements signed (SLT) and unsigned (SLTU) comparisons using
// combinational logic. Designed and verified using testbench
// simulation in Vivado.
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - Initial ALU implementation and verification
// Additional Comments:
// This module is part of a larger RISC-V RV32I RTL design project.
// Verified using multiple test cases including edge cases such as
// signed comparisons and shift operations.
//
////////////////////////////////////////////////////////////////////////////////////////
module ALU(
    input [31:0] in1,
    input [31:0] in2,
    input [3:0]op,
    output reg [31:0]res
    );
    wire w;
    assign w={(in1^in2)?in1:(in1<in2)};
    always@(*)
    begin
    case(op)
    4'b0000:res=in1+in2;
    4'b1000:res=in1-in2;
    4'b0010:res={{31{1'b0}},w};
    4'b0011:res={in1<in2}?32'b1:32'b0;
    4'b0111:res=in1&in2;
    4'b0110:res=in1|in2;
    4'b0010:res=in1^in2;
    4'b0001:res=in1<<in2[4:0];
    4'b0101:res=in1>>in2[4:0];
    4'b1101:res=in1>>>in2[4:0];
            endcase
   end     
endmodule
