# Bloom Filter

Bloom filter implementation made in V.

![tests](https://github.com/SheatNoisette/bloomfilter/actions/workflows/makefile.yml/badge.svg)

Useful for a quick lookup on a lot of data where accuracy isn't important
(See maps for that) without using much memory.

If the hash matches, it **MIGHT** be inserted before (Because of hash collisions). If it doesn't, the data
was **NEVER** seen before.

More info about bloom filters [here](https://en.wikipedia.org/wiki/Bloom_filter)

Important note:
---

**The version of this module will remain in 0.x.x unless the language API's are finalized or
implemented.**

**This module will be archived if a native bloom filter is implemented in vlib.**

# Quickstart

Install the library from git:
```
v install --git https://github.com/SheatNoisette/bloomfilter.git
```

Usage quickstart:
```v
import crypto.sha256

import bloomfilter

// ------------------------------------
// Sample usage

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

// Clear the filter - Remove every elements
filter.clear()

// ------------------------------------
// Change hash algorithms

// Remove algorithms
filter.reset_hash_functions()
// Add new hash functions (Order is important)
filter.add_hash_functions(sha256.hexhash, sha256.hexhash)

// Manual initialization
mut filter_2 := bloomfilter.new_ext(size: 512, hash_functions: [sha256.hexhash])
```

# License
This library is licensed under the MIT license, see ```LICENSE``` for more
details.
