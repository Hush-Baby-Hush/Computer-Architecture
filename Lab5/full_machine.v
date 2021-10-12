module sign_extender (out, in);
    output  [31:0]out;
    input   [15:0]in;
    assign out[31:16] = {16{in[15]}};
    assign out[15:0] = in[15:0];
endmodule //sign_extender

module zero_extender (out, in);
    output  [31:0]out;
    input   [15:0]in;
    assign out[31:16] = in[15:0]&(16'h0000);
    assign out[15:0] = in[15:0];
endmodule //zero_extender



// full_machine: execute a series of MIPS instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock   (input) - the clock signal
// reset   (input) - set to 1 to set all registers to zero, set to 0 for normal execution.

module full_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst;  
    wire [31:0] PC;  //given above

//own
    wire [5:0] opcode = inst[31:26];
    wire [5:0] funct =  inst[5:0];
    wire [1:0] control_type;
    wire  mem_read, word_we, byte_we, byte_load, slt, lui, addm;

    wire [4:0] rs = inst[25:21];
    wire [4:0] rt = inst[20:16];
    wire [4:0] rd = inst[15:11];
    wire [31:0] rsData, rtData, rdData, w_data;

    wire overflow, zero, negative; 
    wire writeenable, rd_src;
    wire [1:0] alu_src2;
    wire [2:0] alu_op;
    wire [31:0]out;
    wire [31:0]signimm32;
    wire [31:0]zeroimm32;
    wire [4:0]w_addr;
    wire [31:0]B_input;
    wire [31:0] nextPC;


    wire [31:0] branch_offset = signimm32[29:0] << 2;
    wire [31:0] pc_a, pc_b;
    wire [31:0] pc_c = {pc_a[31:28], inst[25:0], 2'b0};
    wire [31:0] pc_d = rsData;


    wire [31:0] lui1 = {inst[15:0], 16'b0};
    wire [31:0] sltData, byte_data, mem_out;
    wire [31:0] memData, byteOut, addm_out, addr;

    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg( PC, nextPC, clock, 1'h1, reset);

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im( inst, PC[31:2] );

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf ( rsData, rtData, rs, rt, w_addr, rdData, writeenable, clock, reset);

    /* add other modules */

    //mips_decoder
    mips_decode mips(alu_op, writeenable, rd_src, alu_src2, except, control_type,
                       mem_read, word_we, byte_we, byte_load,  slt, lui, addm,
                       opcode, funct, zero);

    //register file
    mux2v #(5) waddr_mux(w_addr, rd, rt, rd_src);

    sign_extender signextend(signimm32, inst[15:0]);
    zero_extender zeroextend(zeroimm32, inst[15:0]);
    mux3v #(32) Binput(B_input, rtData, signimm32, zeroimm32, alu_src2);

    wire extra;
    assign  extra = (negative & (~overflow)) |((~negative) & overflow);
    mux2v #(32) slt_mux(sltData, out, {31'b0, extra}, slt);
    mux2v #(32) w_data_mux(w_data, memData, lui1, lui);
    mux2v #(32) mem_Out_mux(memData, sltData, byteOut, mem_read);

    alu32 out_(out, overflow, zero, negative, rsData, B_input, alu_op[2:0]);

    //data memory
    data_mem memory(mem_out, addr, rtData, word_we, byte_we, clock, reset);
    wire [7:0] byte_mux;
    assign byte_data = {24'h0, byte_mux[7:0]};
    mux4v #(8) byte(byte_mux, mem_out[7:0], mem_out[15:8], mem_out[23:16], mem_out[31:24], out[1:0]);
    mux2v #(32) byte2(byteOut, mem_out, byte_data, byte_load);

    //PC
    alu32 a_alu(pc_a, , , , PC, 32'h4, 3'h2);
    alu32 b_alu(pc_b, , , , pc_a, branch_offset, 3'h2);
    mux4v pc_mux(nextPC, pc_a, pc_b, pc_c, pc_d, control_type);

    //addm_ 
    mux2v #(32) add1(addr, out, rsData, addm);
    mux2v #(32) add2(rdData, w_data, addm_out, addm);
    alu32 addm_(addm_out, , , , mem_out, rtData, 3'h2);




endmodule // full_machine
