module keypad(valid, number, a, b, c, d, e, f, g);
   output 	valid;
   output [3:0] number;
   input 	a, b, c, d, e, f, g;


   assign number[0] = ((a||c)&&(d||f)) || (b && e);
   assign number[1] = (a && f) || (b&&d) || (c && (d||e));
   assign number[2] = (a&&(e||f)) || (e&&(b||c));
   assign number[3] = f&&(b||c);
   assign valid = (a&&(d||e||f)) || (b&&(d||e||f||g)) || (c&&(d||e||f));


endmodule // keypad
