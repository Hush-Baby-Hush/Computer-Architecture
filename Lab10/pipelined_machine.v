module pipelined_machine(clk, reset);
    input        clk, reset;

    wire [31:0]  PC;
    wire [31:2]  next_PC, PC_plus4, PC_target;
    wire [31:2]  nPC_plus4;

    wire [31:0]  inst;

    wire [31:0]  ninst;
    wire [31:0]  imm = {{ 16{ninst[15]} }, ninst[15:0] };  // sign-extended immediate
    wire [4:0]   rs = ninst[25:21];
    wire [4:0]   rt = ninst[20:16];
    wire [4:0]   rd = ninst[15:11];
    wire [5:0]   opcode = ninst[31:26];
    wire [5:0]   funct = ninst[5:0];

    wire [4:0]   wr_regnum;
    wire [4:0]   nwr_regnum;
    
    wire [2:0]   ALUOp;

    wire         RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst;
    wire         nRegWrite, nMemRead, nMemWrite, nMemToReg;

    wire         PCSrc, zero;
    wire [31:0]  rd1_data, rd2_data, B_data, alu_out_data, load_data, wr_data;
    wire [31:0]  nrd1_data, nrd2_data, nalu_out_data, newrd2_data;

    wire for1 = (nwr_regnum == rs) & (nwr_regnum != 0) & (nRegWrite);
    wire for2 = (nwr_regnum == rt) & (nwr_regnum != 0) & (nRegWrite);
    wire stall = (nwr_regnum == rs | nwr_regnum == rt) & (nwr_regnum != 0) &  (nMemRead);

    register #(32) pipef1(ninst, inst, clk, ~stall,  PCSrc | reset);

    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(30, 30'h100000) PC_reg(PC[31:2], next_PC[31:2], clk, /* enable */~stall, reset);

    assign PC[1:0] = 2'b0;  // bottom bits hard coded to 00
    adder30 next_PC_adder(PC_plus4, PC[31:2], 30'h1);
    adder30 target_PC_adder(PC_target, nPC_plus4, imm[29:0]); //modify
    register #(30) pipef2(nPC_plus4, PC_plus4, clk, ~stall,  PCSrc | reset);

    mux2v #(30) branch_mux(next_PC, PC_plus4, PC_target, PCSrc);
    assign PCSrc = BEQ & zero;

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory imem(inst, PC[31:2]);

    register #(1) piped1(nRegWrite, RegWrite, clk, /* enable */1'b1, stall | reset);
    register #(1) piped2(nMemRead, MemRead, clk, /* enable */1'b1, stall | reset);
    register #(1) piped3(nMemWrite, MemWrite, clk, /* enable */1'b1, stall | reset);
    register #(1) piped4(nMemToReg, MemToReg, clk, /* enable */1'b1, stall | reset);
//above are added

    mips_decode decode(ALUOp, RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst,
                      opcode, funct);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (rd1_data, rd2_data,
               rs, rt, nwr_regnum, wr_data,
               nRegWrite, clk, reset);
//are modified
    register #(5) pipem3(nwr_regnum, wr_regnum, clk, /* enable */1'b1, stall | reset);
    register #(32) pipem1(nalu_out_data, alu_out_data, clk, /* enable */1'b1, stall | reset);

    mux2v #(32) rd2Data_mux(newrd2_data, rd2_data, nalu_out_data, for2);
//the above line are added
    mux2v #(32) imm_mux(B_data, newrd2_data, imm, ALUSrc);
//newrd2_data are modified
    mux2v #(32) rd1Data_mux(nrd1_data, rd1_data, nalu_out_data, for1);
//the above line are added
    alu32 alu(alu_out_data, zero, ALUOp, nrd1_data, B_data);
//nrd1_data are modified

    register #(32) pipem2(nrd2_data, newrd2_data, clk, /* enable */1'b1, stall | reset);
//the above are added

    // DO NOT comment out or rename this module
    // or the test bench will break
    data_mem data_memory(load_data, nalu_out_data, nrd2_data, nMemRead, nMemWrite, clk, reset);
//nalu_out_data, nrd2_data, nMemRead, nMemWrite are modified
    mux2v #(32) wb_mux(wr_data, nalu_out_data, load_data, nMemToReg);
//nalu_out_data, nMemToReg are modified
    mux2v #(5) rd_mux(wr_regnum, rt, rd, RegDst);

endmodule // pipelined_machine
