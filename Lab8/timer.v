module timer(TimerInterrupt, cycle, TimerAddress,
             data, address, MemRead, MemWrite, clock, reset);
    output        TimerInterrupt;
    output [31:0] cycle;
    output        TimerAddress;
    input  [31:0] data, address;
    input         MemRead, MemWrite, clock, reset;

    // complete the timer circuit here
    wire [31:0] NUMBER_CYCLES  = 32'hffff001c;
    wire [31:0] TIME_INTERRUPT = 32'hffff006c;
    // wire RESET_REGISTER = 32'hffffffff;

    wire TimerWrite, TimerRead, acknowledge, reset_interrupt;
    wire [31:0] Q_interrupt_cycle, Q_cycle_counter, ALU_out;

    wire get_time = (address == NUMBER_CYCLES);
    wire store_time = (address == TIME_INTERRUPT);

    wire check_equal = (Q_cycle_counter == Q_interrupt_cycle);

    assign TimerRead = (MemRead & get_time);
    assign TimerAddress = (get_time || store_time);
    assign TimerWrite = (MemWrite & get_time);
    assign acknowledge = (store_time & MemWrite);

    alu32 alu(ALU_out, , , `ALU_ADD, Q_cycle_counter, 32'b1);
    register # (32,0) cycle_counter(Q_cycle_counter, ALU_out, clock, 1'b1, reset);
    register # (32, 32'hffffffff) interrupt_cycle(Q_interrupt_cycle, data, clock, TimerWrite, reset);


    assign reset_interrupt = (acknowledge | reset);
    dffe dff1(TimerInterrupt, 1'b1, clock, check_equal, reset_interrupt);

    tristate # (32) tr1(cycle, Q_cycle_counter, TimerRead);



    // HINT: make your interrupt cycle register reset to 32'hffffffff
    //       (using the reset_value parameter)
    //       to prevent an interrupt being raised the very first cycle
endmodule
