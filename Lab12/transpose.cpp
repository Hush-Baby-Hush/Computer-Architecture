#include <algorithm>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "transpose.h"

// will be useful
// remember that you shouldn't go over SIZE
using std::min;

// modify this function to add tiling
void
transpose_tiled(int **src, int **dest) 
{
    for (int i = 0; i < SIZE; i += 32) 
    {
        for (int j = 0; j < SIZE; j += 32) 
        {
          for (int temp1 = i; temp1 < min(SIZE,i + 32); temp1++)
          {
            for (int temp2 = j; temp2 < min(SIZE,j + 32); temp2++)
            {
                dest[temp1][temp2] = src[temp2][temp1];
            }
          }
        }
    }
}
