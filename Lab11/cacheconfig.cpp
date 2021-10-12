#include "cacheconfig.h"
#include "utils.h"

CacheConfig::CacheConfig(uint32_t size, uint32_t block_size, uint32_t associativity)
: _size(size), _block_size(block_size), _associativity(associativity) {
  /**
   * TODO
   * Compute and set `_num_block_offset_bits`, `_num_index_bits`, `_num_tag_bits`.
  */ 
  
  uint32_t blk_number = size / block_size;
  uint32_t set = blk_number / associativity;
  _num_index_bits = (uint32_t)log_2(set);
  _num_block_offset_bits = (uint32_t)log_2(block_size);
  _num_tag_bits = 32 - _num_block_offset_bits - _num_index_bits;

}
