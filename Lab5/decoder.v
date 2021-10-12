// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op       (output) - control signal to be sent to the ALU
// writeenable  (output) - should a new value be captured by the register file
// rd_src       (output) - should the destination register be rd (0) or rt (1)
// alu_src2     (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except       (output) - set to 1 when we don't recognize an opdcode & funct combination
// control_type (output) - 00 = fallthrough, 01 = branch_target, 10 = jump_target, 11 = jump_register 
// mem_read     (output) - the register value written is coming from the memory
// word_we      (output) - we're writing a word's worth of data
// byte_we      (output) - we're only writing a byte's worth of data
// byte_load    (output) - we're doing a byte load
// slt          (output) - the instruction is an slt
// lui          (output) - the instruction is a lui
// addm         (output) - the instruction is an addm
// opcode        (input) - the opcode field from the instruction
// funct         (input) - the function field from the instruction
// zero          (input) - from the ALU
//

module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, control_type,
                   mem_read, word_we, byte_we, byte_load, slt, lui, addm,
                   opcode, funct, zero);
    output [2:0] alu_op;
    output [1:0] alu_src2;
    output       writeenable, rd_src, except;
    output [1:0] control_type;
    output       mem_read, word_we, byte_we, byte_load, slt, lui, addm;
    input  [5:0] opcode, funct;
    input        zero;

//copy from lab4

    wire add_ = (opcode == `OP_OTHER0) & (funct == `OP0_ADD);    
	wire addi_ = (opcode == `OP_ADDI);       
	wire addu_ = (opcode == `OP_OTHER0) & (funct == `OP0_ADDU);
	wire addiu_ = (opcode == `OP_ADDIU);

	wire sub_ = (opcode == `OP_OTHER0) & (funct == `OP0_SUB);   

	wire and_ = (opcode == `OP_OTHER0) & (funct == `OP0_AND);   
	wire andi_ = (opcode == `OP_ANDI);    

	wire or_ = (opcode == `OP_OTHER0) & (funct == `OP0_OR);  
	wire ori_ = (opcode == `OP_ORI);     

	wire nor_ = (opcode == `OP_OTHER0) & (funct == `OP0_NOR); 

	wire xor_ = (opcode == `OP_OTHER0) & (funct == `OP0_XOR);  
	wire xori_ = (opcode == `OP_XORI);	


//new assignment

    wire bne_ = (opcode == `OP_BNE);
    wire beq_ = (opcode == `OP_BEQ);
    wire j_ = (opcode == `OP_J);
    wire jr_ = (funct == `OP0_JR) & (opcode == `OP_OTHER0);
    wire lui_ = (opcode == `OP_LUI);
    wire slt_ = (opcode == `OP_OTHER0) & (funct == `OP0_SLT);
    wire lw_ = (opcode == `OP_LW);
    wire lbu_ = (opcode == `OP_LBU);
    wire sw_ = (opcode == `OP_SW);
    wire sb_ = (opcode == `OP_SB);
    wire addm_ = (funct == `OP0_ADDM) & (opcode == `OP_OTHER0);



    assign rd_src = (addi_ | addiu_ | andi_ | ori_ | xori_ 
    | lw_ | lbu_ | lui_);

	assign writeenable = (add_ |addu_|addiu_| addi_ | sub_ | and_ | andi_ | or_ | ori_ | xor_ | xori_ | nor_ 
    | lui_ | slt_ | lw_ | lbu_ | addm_ );

    assign except = ~(add_ | addu_| addiu_| addi_ | sub_ | and_ | andi_ | or_ | ori_ | xor_ | xori_ | nor_ 
    | bne_ | beq_ | j_ | jr_ | lui_ | slt_ | lw_ | lbu_ | sw_ | sb_ | addm_);	
    
    assign alu_op[0] = (sub_ | or_ | ori_ | xor_ | xori_ 
    | bne_ | beq_ | slt_ );

	assign alu_op[1] = (sub_ | xor_ | xori_ | nor_ | add_ | addi_ 
    | bne_ | beq_ | slt_ | lw_ | lbu_ | sw_ | sb_ | addm_ );

	assign alu_op[2] = (and_ | andi_ | or_ | ori_ | xor_ | xori_ | nor_ );


	assign alu_src2[1] = (andi_ | ori_ | xori_ );
    assign alu_src2[0] = (addi_ | addiu_ | lbu_ | lw_ | sw_ | sb_);


    assign control_type[0] = ((zero & beq_ ) | (~zero & bne_) | jr_ );
    assign control_type[1] = (j_ | jr_);

    assign mem_read = (lbu_ | lw_ | addm_);

    assign word_we = sw_;
    assign byte_we = sb_;
    assign byte_load = lbu_;
    assign lui = lui_;
    assign slt = slt_;
    assign addm = addm_;



endmodule // mips_decode
