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


// arith_machine: execute a series of arithmetic instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock  (input)  - the clock signal
// reset  (input)  - set to 1 to set all registers to zero, set to 0 for normal execution.

module arith_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst;  
    wire [31:0] PC;  

    wire overflow, zero, negative;
    wire rd_src, writeenable;
    wire [1:0] alu_src2;
    wire [2:0]alu_op;

    wire [31:0]out;
    wire [31:0]signimm32;
    wire [31:0]zeroimm32;
    wire [4:0]w_addr;
    wire [31:0]rt;
    wire [31:0]rs;
    wire [31:0]B_input;
    wire [31:0]nextPC;


    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg( PC, nextPC, clock, 1'h1, reset );

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im( inst, PC[31:2] );

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf ( rs, rt, inst[25:21], inst[20:16], w_addr, out, writeenable, clock, reset );

    /* add other modules */
    alu32 pcplus4 (nextPC, , , , PC[31:0], 32'h4, 3'h2);
    mux2v #(5) rdchoice (w_addr, inst[15:11], inst[20:16], rd_src);
    mips_decode decode_(rd_src, writeenable, alu_src2, alu_op, except, inst[31:26], inst[5:0]);
    alu32 out_ (out, overflow, zero, negative, rs, B_input, alu_op[2:0]);
    sign_extender signextend(signimm32, inst[15:0]);
    zero_extender zeroextend(zeroimm32, inst[15:0]);
    mux3v #(32) Binput(B_input, rt, signimm32, zeroimm32, alu_src2);

endmodule // arith_machine


