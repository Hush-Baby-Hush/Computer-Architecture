/**
 * @file
 * Contains an implementation of the extractMessage function.
 */

#include <iostream> // might be useful for debugging
#include <assert.h>
#include "extractMessage.h"

using namespace std;

char *extractMessage(const char *message_in, int length) {
   // Length must be a multiple of 8
   assert((length % 8) == 0);

   // allocates an array for the output
   char *message_out = new char[length];
   for (int i=0; i<length; i++) {
   		message_out[i] = 0;    // Initialize all elements to zero.
	}

	// TODO: write your code here

   int block = length/8;
   int k = 0;  //the kth char
   int outer = 0;

   while (block>0)
   {
      int count = 0; //every 8 byte a block
      while( count<8 )
      {
         //deal with a char
            for (int i = 0; i < 8; i++)
            {
               char pre = message_in[outer*8+7-i];
               pre = pre << (7-count);
               pre = pre >> 7;
               if (pre == 0)
               {
                  if (i!=7)
                  {
                     message_out[k] = message_out[k]<<1;
                  }
               }
               else
               {
                  message_out[k] += 1;
                  if (i!=7)
                  {
                     message_out[k] = message_out[k]<<1;
                  }
                  
               }
            }

         k++;      
         count++;   
      }

      outer++;
      block--;
   }



	return message_out;
}
