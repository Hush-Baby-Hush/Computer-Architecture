#include "simplecache.h"
using namespace std;

int SimpleCache::find(int index, int tag, int block_offset) {
  // read handout for implementation details

  vector<SimpleCacheBlock> &temp = _cache.find(index)->second;

  for (int i = 0; i < temp.size(); i++) 
  {
    if (temp.at(i).valid() && temp.at(i).tag() == tag) 
    {
      int result = (int)temp.at(i).get_byte(block_offset);
      return result;
    }
  }
  return 0xdeadbeef;
}

void SimpleCache::insert(int index, int tag, char data[]) {
  // read handout for implementation details
  // keep in mind what happens when you assign (see "C++ Rule of Three")

  vector<SimpleCacheBlock> &temp = _cache.find(index)->second;

  for (int i = 0; i < temp.size(); i++) 
  {
    if (!temp.at(i).valid()) 
    {
      temp.at(i).replace(tag, data);
      return;
    }
  }

  temp.at(0).replace(tag, data);
  return;

}
