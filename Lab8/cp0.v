`define STATUS_REGISTER 5'd12
`define CAUSE_REGISTER  5'd13
`define EPC_REGISTER    5'd14

module cp0(rd_data, EPC, TakenInterrupt,
           wr_data, regnum, next_pc,
           MTC0, ERET, TimerInterrupt, clock, reset);
    output [31:0] rd_data;
    output [29:0] EPC;
    output        TakenInterrupt;

    input  [31:0] wr_data;
    input   [4:0] regnum;
    input  [29:0] next_pc;
    input         MTC0, ERET, TimerInterrupt, clock, reset;

    // your Verilog for coprocessor 0 goes here
    wire exception_level;
    wire [31:0] decode, user_status;
    wire [29:0] D_EPC;
    wire reset_Exception_level = (ERET | reset);
    decoder32 decode1(decode, regnum, MTC0);
    wire enable_EPC = (decode[14] | TakenInterrupt);
    wire [31:0] cause_register = {16'b0, TimerInterrupt, 15'b0};
    wire [31:0] status_register = {16'b0, user_status[15:8], 6'b0, exception_level, user_status[0]};

    register # (32, 0) User1(user_status, wr_data, clock, decode[12], reset);
    dffe Exception1(exception_level, 1'b1, clock, TakenInterrupt, reset_Exception_level);
    register # (30, 0) EPC1(EPC, D_EPC, clock, enable_EPC, reset);
    mux32v m2(rd_data, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, status_register, cause_register, {EPC, 2'b0}, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, regnum);


    mux2v # (30) d1(D_EPC, wr_data[31:2], next_pc, TakenInterrupt);

    // assign cause_register[15] = TimerInterrupt;

    assign TakenInterrupt = ((cause_register[15] & status_register[15]) & (~status_register[1] & status_register[0]));

    
endmodule
