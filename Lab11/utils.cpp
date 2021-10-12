#include "utils.h"

uint32_t extract_tag(uint32_t address, const CacheConfig& cache_config) {
  // TODO

  uint32_t tag_bit = cache_config.get_num_tag_bits();
  if (tag_bit >= 32) 
  {
    return address;
  }
  return address >> (32 - tag_bit);
}

uint32_t extract_index(uint32_t address, const CacheConfig& cache_config) {
  // TODO

  uint32_t idx_bit = cache_config.get_num_index_bits();
  uint32_t off_bit = cache_config.get_num_block_offset_bits();
  uint32_t result = (address >> off_bit) & ((1 << idx_bit) - 1);
  return result;
}

uint32_t extract_block_offset(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  
  uint32_t off_bit = cache_config.get_num_block_offset_bits();
  uint32_t result = address & ((1 << off_bit) - 1);
  return result;
}
