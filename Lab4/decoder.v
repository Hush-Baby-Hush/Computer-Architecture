// mips_decode: a decoder for MIPS arithmetic instructions
//
// rd_src      (output) - should the destination register be rd (0) or rt (1)
// writeenable (output) - should a new value be captured by the register file
// alu_src2    (output) - should the 2nd ALU source be a register (0), zero extended immediate or sign extended immediate
// alu_op      (output) - control signal to be sent to the ALU
// except      (output) - set to 1 when the opcode/funct combination is unrecognized
// opcode      (input)  - the opcode field from the instruction
// funct       (input)  - the function field from the instruction
//

module mips_decode(rd_src, writeenable, alu_src2, alu_op, except, opcode, funct);
    output       rd_src, writeenable, except;
    output [1:0] alu_src2;
    output [2:0] alu_op;
    input  [5:0] opcode, funct;

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

	assign rd_src =  (addi_ | addiu_ | andi_ | ori_ | xori_ );
	assign writeenable = (add_ |addu_|addiu_| addi_ | sub_ | and_ | andi_ | or_ | ori_ | xor_ | xori_ | nor_ );
	assign except= ~ writeenable;

	assign alu_src2[1] = (andi_ | ori_ | xori_ );
    assign alu_src2[0] = (addi_ | addiu_);
	
	assign alu_op[0] = (sub_ | or_ | ori_ | xor_ | xori_ );
	assign alu_op[1] = (sub_ | xor_ | xori_ | nor_ |add_ | addi_ |addiu_|addu_);
	assign alu_op[2] = (and_ | andi_ | or_ | ori_ | xor_ | xori_ | nor_ );

endmodule // mips_decode
