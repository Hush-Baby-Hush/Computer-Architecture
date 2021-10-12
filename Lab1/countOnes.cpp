/**
 * @file
 * Contains an implementation of the countOnes function.
 */

unsigned countOnes(unsigned input) {
	// TODO: write your code here

	unsigned result = input;

	//1
	unsigned right = result & 0x55555555;
	unsigned left = result & 0xAAAAAAAA;	
	
	left = left >> 1;
	result = right + left;
		
	//2
	right = result & 0x33333333;
	left = result & 0xCCCCCCCC;

	left = left >>  2;
	result = right + left;
		
	//4
	right = result & 0x0F0F0F0F;
	left = result & 0xF0F0F0F0;
	left = left >>  4;
	result = right + left;
		
	//8
	right = result & 0x00FF00FF;
	left = result & 0xFF00FF00;

	left = left >>  8;
	result = right + left;
		
	//16
	right = result & 0x0000FFFF;
	left = result & 0xFFFF0000;

	left = left >>  16;
	result = right + left;
		
	return result;

}
