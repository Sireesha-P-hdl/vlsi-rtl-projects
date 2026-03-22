`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal Project
// Engineer: Sireesha P
// Create Date: 21.03.2026
// Design Name: RISC-V RV32I Decoder
// Module Name: Decoder
// Project Name: RISC-V-RV32I-RTL-Design
// Target Devices: Generic FPGA / Xilinx Vivado
// Tool Versions: Vivado
// Description:
// This module implements the instruction decoder for a RISC-V RV32I processor.
// It classifies instructions based on opcode, funct3, and funct7[5], and
// generates control signals for the datapath such as ALU control, register
// file write enable, write-back mux selection, immediate type selection,
// memory write request, CSR control, illegal instruction detection, and
// misalignment detection for load/store operations.
// 
// Dependencies:
// ALU
// Immediate Generator
// Register File
// Load Unit
// Store Unit
// Write-Back Mux
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Added comments and detailed control signal explanation
// Additional Comments:
// This decoder is designed for educational and project-based RTL learning.
// Verified using a Verilog testbench and waveform analysis in Vivado.
module Decoder(
    input  trap_taken_in, funct7_5_in,
    input  [6:0] opcode_in,
    input  [2:0] funct3_in,
    input  [1:0] iadder_out_1_to_0_in,
    output [2:0] wb_mux_sel_out, imm_type_out, csr_op_out,
    output mem_wr_req_out, load_unsigned_out, alu_src_out, iadder_src_out,
    output csr_wr_en_out, rf_wr_en_out, illegal_instr_out,
    output misaligned_load_out, misaligned_store_out,
    output [3:0] alu_opcode_out,
    output [1:0] load_size_out
);

// Opcode values are taken from the RV32I instruction format.
// These correspond to opcode_in[6:2], which identifies the instruction class.
parameter OPCODE_BRANCH   = 5'b11000;
parameter OPCODE_JAL      = 5'b11011;
parameter OPCODE_JALR     = 5'b11001;
parameter OPCODE_AUIPC    = 5'b00101;
parameter OPCODE_LUI      = 5'b01101;
parameter OPCODE_OP       = 5'b01100;
parameter OPCODE_OP_IMM   = 5'b00100;
parameter OPCODE_LOAD     = 5'b00000;
parameter OPCODE_STORE    = 5'b01000;
parameter OPCODE_SYSTEM   = 5'b11100;
parameter OPCODE_MISC_MEM = 5'b00011;

// funct3 values used to identify ALU and immediate operations.
parameter FUNCT3_ADD   = 3'b000;
parameter FUNCT3_SUB   = 3'b000;
parameter FUNCT3_SLT   = 3'b010;
parameter FUNCT3_SLTU  = 3'b011;
parameter FUNCT3_AND   = 3'b111;
parameter FUNCT3_OR    = 3'b110;
parameter FUNCT3_XOR   = 3'b100;
parameter FUNCT3_SLL   = 3'b001;
parameter FUNCT3_SRL   = 3'b101;
parameter FUNCT3_SRA   = 3'b101;

// Internal instruction classification flags.
reg is_branch;
reg is_jal;
reg is_jalr;
reg is_auipc;
reg is_lui;
reg is_load;
reg is_store;
reg is_system;
wire is_csr;
reg is_op;
reg is_op_imm;
reg is_misc_mem;

// Internal flags for OP-IMM sub-instructions.
reg is_addi;
reg is_slti;
reg is_sltiu;
reg is_andi;
reg is_ori;
reg is_xori;

// Internal helper signals.
wire is_implemented_instr;
wire mal_word;
wire mal_half;
wire misaligned;

always @(*) begin
    case (opcode_in[6:2])

        // 11 control signals are grouped together.
        // Only one instruction class is asserted at a time.
        OPCODE_OP       : {is_op, is_op_imm, is_load, is_store, is_branch, is_jal, is_jalr, is_lui, is_auipc, is_misc_mem, is_system} = 11'b10000000000;
        OPCODE_OP_IMM   : {is_op, is_op_imm, is_load, is_store, is_branch, is_jal, is_jalr, is_lui, is_auipc, is_misc_mem, is_system} = 11'b01000000000;
        OPCODE_LOAD     : {is_op, is_op_imm, is_load, is_store, is_branch, is_jal, is_jalr, is_lui, is_auipc, is_misc_mem, is_system} = 11'b00100000000;
        OPCODE_STORE    : {is_op, is_op_imm, is_load, is_store, is_branch, is_jal, is_jalr, is_lui, is_auipc, is_misc_mem, is_system} = 11'b00010000000;
        OPCODE_BRANCH   : {is_op, is_op_imm, is_load, is_store, is_branch, is_jal, is_jalr, is_lui, is_auipc, is_misc_mem, is_system} = 11'b00001000000;
        OPCODE_JAL      : {is_op, is_op_imm, is_load, is_store, is_branch, is_jal, is_jalr, is_lui, is_auipc, is_misc_mem, is_system} = 11'b00000100000;
        OPCODE_JALR     : {is_op, is_op_imm, is_load, is_store, is_branch, is_jal, is_jalr, is_lui, is_auipc, is_misc_mem, is_system} = 11'b00000010000;
        OPCODE_LUI      : {is_op, is_op_imm, is_load, is_store, is_branch, is_jal, is_jalr, is_lui, is_auipc, is_misc_mem, is_system} = 11'b00000001000;
        OPCODE_AUIPC    : {is_op, is_op_imm, is_load, is_store, is_branch, is_jal, is_jalr, is_lui, is_auipc, is_misc_mem, is_system} = 11'b00000000100;
        OPCODE_MISC_MEM : {is_op, is_op_imm, is_load, is_store, is_branch, is_jal, is_jalr, is_lui, is_auipc, is_misc_mem, is_system} = 11'b00000000010;
        OPCODE_SYSTEM   : {is_op, is_op_imm, is_load, is_store, is_branch, is_jal, is_jalr, is_lui, is_auipc, is_misc_mem, is_system} = 11'b00000000001;

        // If opcode is unknown, no instruction class is selected.
        default         : {is_op, is_op_imm, is_load, is_store, is_branch, is_jal, is_jalr, is_lui, is_auipc, is_misc_mem, is_system} = 11'b00000000000;
    endcase
end

always @(*) begin
    case (funct3_in)

        // 6 control signals are grouped together for OP-IMM instructions.
        // Only the matching immediate ALU instruction is enabled.
        FUNCT3_ADD    : {is_addi, is_slti, is_sltiu, is_andi, is_ori, is_xori} = {is_op_imm, 1'b0,      1'b0,       1'b0,    1'b0,   1'b0};
        FUNCT3_SLT    : {is_addi, is_slti, is_sltiu, is_andi, is_ori, is_xori} = {1'b0,      is_op_imm, 1'b0,       1'b0,    1'b0,   1'b0};
        FUNCT3_SLTU   : {is_addi, is_slti, is_sltiu, is_andi, is_ori, is_xori} = {1'b0,      1'b0,      is_op_imm,  1'b0,    1'b0,   1'b0};
        FUNCT3_AND    : {is_addi, is_slti, is_sltiu, is_andi, is_ori, is_xori} = {1'b0,      1'b0,      1'b0,       is_op_imm,1'b0,   1'b0};
        FUNCT3_OR     : {is_addi, is_slti, is_sltiu, is_andi, is_ori, is_xori} = {1'b0,      1'b0,      1'b0,       1'b0,    is_op_imm,1'b0};
        FUNCT3_XOR    : {is_addi, is_slti, is_sltiu, is_andi, is_ori, is_xori} = {1'b0,      1'b0,      1'b0,       1'b0,    1'b0,   is_op_imm};

        default       : {is_addi, is_slti, is_sltiu, is_andi, is_ori, is_xori} = 6'b000000;
    endcase
end

// For load instructions:
// funct3[1:0] gives the data size: byte / halfword / word.
assign load_size_out     = funct3_in[1:0];

// funct3[2] tells whether the load is signed or unsigned.
// 0 = signed, 1 = unsigned.
assign load_unsigned_out = funct3_in[2];

// Selects ALU second operand source based on opcode encoding.
// In this design it is derived directly from opcode bit[5].
assign alu_src_out       = opcode_in[5];

// CSR = Control and Status Register.
// A CSR instruction is a SYSTEM instruction with funct3 != 000.
assign is_csr        = is_system & (funct3_in[2] | funct3_in[1] | funct3_in[0]);

// Enable CSR write when instruction is CSR-type.
assign csr_wr_en_out = is_csr;

// CSR operation is directly encoded by funct3.
assign csr_op_out    = funct3_in;

// Immediate adder is used for effective address / target address calculation.
// Required for LOAD, STORE, and JALR.
assign iadder_src_out = is_load | is_store | is_jalr;

// Register file write enable is asserted for instructions that write a result to rd.
assign rf_wr_en_out   = is_lui | is_auipc | is_jalr | is_jal | is_op | is_load | is_csr | is_op_imm;

// Lower 3 bits of ALU opcode come directly from funct3.
assign alu_opcode_out[2:0] = funct3_in;

// Upper ALU opcode bit distinguishes operations like ADD vs SUB, SRL vs SRA.
// For immediate instructions like ADDI/ORI/XORI, funct7[5] is ignored.
assign alu_opcode_out[3] = funct7_5_in & ~(is_addi | is_slti | is_sltiu | is_andi | is_ori | is_xori);

// Write-back mux select decides what value is written into rd.
// Example: ALU result, memory data, PC+4, immediate, or CSR value.
assign wb_mux_sel_out[0] = is_load | is_auipc | is_jal | is_jalr;
assign wb_mux_sel_out[1] = is_lui | is_auipc;
assign wb_mux_sel_out[2] = is_csr | is_jal | is_jalr;

// Immediate type select tells the Immediate Generator which format to use:
// I-type, S-type, B-type, U-type, J-type, or CSR-type.
assign imm_type_out[0] = is_op_imm | is_load | is_jalr | is_branch | is_jal;
assign imm_type_out[1] = is_store | is_branch | is_csr;
assign imm_type_out[2] = is_lui | is_auipc | is_jal | is_csr;

// Indicates whether the instruction belongs to a supported instruction class.
assign is_implemented_instr = is_op | is_op_imm | is_branch | is_jal | is_jalr |
                              is_auipc | is_lui | is_system | is_load | is_store | is_misc_mem;

// An instruction is illegal if:
// 1) opcode[1] is 0, or
// 2) opcode[0] is 0, or
// 3) the instruction class is not implemented.
assign illegal_instr_out = ~opcode_in[1] | ~opcode_in[0] | ~is_implemented_instr;

// Word access must be 4-byte aligned, so address[1:0] must be 00.
// If not, mal_word becomes 1.
assign mal_word = (funct3_in[1] | funct3_in[0]) & (iadder_out_1_to_0_in[1] | iadder_out_1_to_0_in[0]);

// Halfword access must be 2-byte aligned, so address[0] must be 0.
// If not, mal_half becomes 1.
assign mal_half = ~funct3_in[1] & funct3_in[0] & iadder_out_1_to_0_in[0];

// Combined misalignment flag.
assign misaligned = mal_word | mal_half;

// Assert load/store misalignment outputs only for load/store instructions.
assign misaligned_store_out = is_store & misaligned;
assign misaligned_load_out  = is_load  & misaligned;

// Memory write request is enabled only for a valid store,
// with aligned address and no active trap.
assign mem_wr_req_out = is_store & ~misaligned & ~trap_taken_in;

endmodule
//////////////////////////////////////////////////////////////////////////////////
