
module arraySortCheck_control(sorted, done, load_input, load_index, select_index, go, 
inversion_found, end_of_array, zero_length_array, clock, reset);
	output sorted, done, load_input, load_index, select_index;
	input go, inversion_found, end_of_array, zero_length_array;
	input clock, reset;

	wire garbage, start, res_1, res_2, index, link, review;

	wire garbage_next = (garbage & ~go & ~reset) | reset;
	wire start_next = (garbage & go & ~reset) | (res_1 & go & ~reset) | (res_2 & go & ~reset)| (start & go & (~reset));
	wire link_next = (start & ~go) & ~reset ;

	wire res_1_next = (review & end_of_array & ~reset) | (res_1 & ~go & ~reset)
	| (link & zero_length_array & ~reset);

	wire review_next = link & ~zero_length_array & ~reset | (index & ~reset);

	wire res_2_next = (review & ~end_of_array & inversion_found & ~reset) 
	| (res_2 & ~go & ~reset);

	wire index_next = review & ~inversion_found & ~reset & ~end_of_array;

	dffe ogarbage(garbage, garbage_next, clock, 1'b1, 1'b0);
	dffe ostart(start, start_next, clock, 1'b1, 1'b0);
	dffe olink(link, link_next, clock, 1'b1, 1'b0);
	dffe oreview(review, review_next, clock, 1'b1, 1'b0);
	dffe oindex(index, index_next, clock, 1'b1, 1'b0);
	dffe ores_1(res_1, res_1_next, clock, 1'b1, 1'b0);
	dffe ores_2(res_2, res_2_next, clock, 1'b1, 1'b0);

	assign load_input = start;
	assign load_index = start | index;
	assign select_index = index;

	assign done = res_1 | res_2;
	assign sorted = res_1;

endmodule //end arraySortCheck_control
