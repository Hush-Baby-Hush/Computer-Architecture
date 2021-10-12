#include "cacheblock.h"

uint32_t Cache::Block::get_address() const {
  // TODO
  uint32_t index_n = _cache_config.get_num_index_bits();
  uint32_t offset_n = _cache_config.get_num_block_offset_bits();
  uint32_t address_n = get_tag();
  address_n = address_n << index_n;
  address_n += _index;
  
  return address_n << offset_n;
}
