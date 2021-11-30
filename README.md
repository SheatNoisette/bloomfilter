# Bloom Filter

Bloom filter implementation made in V.

Useful for a quick lookup on a lot of data where accuracy isn't important
(See maps for that) without using much memory.

If the hash matches, it **MIGHT** be inserted before. If it doesn't, the data
was **NEVER** seen before (Minus errors due to hash collisions).

Wikipedia page: [here](https://en.wikipedia.org/wiki/Bloom_filter)

# Quickstart

Install the library using vpm:
```
v install sheatnoisette.bloomfilter
```

Usage quickstart:
```v
import crypto.sha256

import sheatnoisette.bloomfilter

// Create a new bloom filter
mut filter := bloomfilter.new()

// Add elements to it
filter.add('Apple')
filter.add('Banana')
// Same as filter.add('12')
filter.add(12)

// Check if a element MIGHT be in the filter
if filter.check('Apple') {
    println('Apple might be in the filter')
}

// Clear the filter
filter.clear()

// Change hash algorithms

// Remove algorithms
filter.reset_hash_functions()
// Add new hash functions (Order is important)
filter.add_hash_functions(sha256.hexhash, sha256.hexhash)

// Manual initialization
mut filter_2 := bloomfilter.new_ext(size: 512, hash_functions: [sha256.hexhash])
```

# License
This library is licenced under the MIT license, see ```LICENSE``` for more
details.