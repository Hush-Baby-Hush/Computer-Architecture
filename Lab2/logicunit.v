// 00 -> AND, 01 -> OR, 10 -> NOR, 11 -> XOR
module logicunit(out, A, B, control);
    output      out;
    input       A, B;
    input [1:0] control;
    wire r1, r2, r3, r4;

    and o1(r1, A, B);
    or o2(r2, A, B);
    nor o3(r3, A, B);
    xor o4(r4, A, B);

    mux4 result(out, r1, r2, r3, r4, control);

endmodule // logicunit
