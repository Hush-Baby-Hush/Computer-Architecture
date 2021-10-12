#include "cachesimulator.h"
using namespace std;

Cache::Block* CacheSimulator::find_block(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `_cache->get_blocks_in_set` to get all the blocks that could
   *    possibly have `address` cached.
   * 2. Loop through all these blocks to see if any one of them actually has
   *    `address` cached (i.e. the block is valid and the tags match).
   * 3. If you find the block, increment `_hits` and return a pointer to the
   *    block. Otherwise, return NULL.
   */

  const CacheConfig & cache_cfig = _cache->get_config();
  uint32_t index = extract_index(address, cache_cfig);

  vector<Cache::Block *> blocks = _cache->get_blocks_in_set(index);
  uint32_t temp = extract_tag(address, cache_cfig);
  for(int i = 0; i < blocks.size(); i++)
  {
    uint32_t block_tag = blocks[i]->get_tag();
    if(blocks[i]->is_valid() && block_tag == temp)
    {
      _hits++;
      return blocks[i];
    }
  }
  return NULL;
}

Cache::Block* CacheSimulator::bring_block_into_cache(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `_cache->get_blocks_in_set` to get all the blocks that could
   *    cache `address`.
   * 2. Loop through all these blocks to find an invalid `block`. If found,
   *    skip to step 4.
   * 3. Loop through all these blocks to find the least recently used `block`.
   *    If the block is dirty, write it back to memory.
   * 4. Update the `block`'s tag. Read data into it from memory. Mark it as
   *    valid. Mark it as clean. Return a pointer to the `block`.
   */
  
  const CacheConfig & cache_cfig = _cache->get_config();
  uint32_t index = extract_index(address, cache_cfig);

  vector<Cache::Block *> cache_blks = _cache->get_blocks_in_set(index);
  uint32_t temp = extract_tag(address, cache_cfig);
  Cache::Block * first_blk = cache_blks[0];
  int min_ = first_blk->get_last_used_time();

  for(int i = 0; i < cache_blks.size(); i++)
  {
    if(!cache_blks[i]->is_valid())
    {
      cache_blks[i]->set_tag(temp);
      cache_blks[i]->read_data_from_memory(_memory);
      cache_blks[i]->mark_as_valid();
      cache_blks[i]->mark_as_clean();
      return cache_blks[i];
    }

    if(cache_blks[i]->get_last_used_time() < min_)
    {
      first_blk = cache_blks[i];
      min_ = cache_blks[i]->get_last_used_time();
    }
  }

  if(first_blk->is_dirty())
  {
    first_blk->write_data_to_memory(_memory);
  }
  first_blk->set_tag(temp);
  first_blk->read_data_from_memory(_memory);
  first_blk->mark_as_valid();
  first_blk->mark_as_clean();
  return first_blk;
}

uint32_t CacheSimulator::read_access(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `find_block` to find the `block` caching `address`.
   * 2. If not found, use `bring_block_into_cache` cache `address` in `block`.
   * 3. Update the `last_used_time` for the `block`.
   * 4. Use `read_word_at_offset` to return the data at `address`.
   */
  _use_clock++;
  Cache::Block * temp = find_block(address);
  if(!temp)
  {
    temp = bring_block_into_cache(address);
  }
  temp->set_last_used_time(_use_clock.get_count());
  const CacheConfig & cache_cfig = _cache->get_config();
  uint32_t offset_ = extract_block_offset(address, cache_cfig);
  return temp->read_word_at_offset(offset_);
}

void CacheSimulator::write_access(uint32_t address, uint32_t word) const {
  /**
   * TODO
   *
   * 1. Use `find_block` to find the `block` caching `address`.
   * 2. If not found
   *    a. If the policy is write allocate, use `bring_block_into_cache`.
   *    a. Otherwise, directly write the `word` to `address` in the memory
   *       using `_memory->write_word` and return.
   * 3. Update the `last_used_time` for the `block`.
   * 4. Use `write_word_at_offset` to to write `word` to `address`.
   * 5. a. If the policy is write back, mark `block` as dirty.
   *    b. Otherwise, write `word` to `address` in memory.
   */
   _use_clock++;
   Cache::Block * temp = find_block(address);
   if(!temp)
   {
     if(_policy.is_write_allocate())
     {
       temp = bring_block_into_cache(address);
     } 
     
     else 
     {
       _memory->write_word(address, word); 
       return;
     }
   }
   
   temp->set_last_used_time(_use_clock.get_count());
   const CacheConfig & cache_cfig = _cache->get_config();
   uint32_t offset_ = extract_block_offset(address, cache_cfig);
   temp->write_word_at_offset(word, offset_);

   if(_policy.is_write_back())
   {
     temp->mark_as_dirty();
   } 
   else 
   {
     _memory->write_word(address, word);
   }
   return;
}
