module bloomfilter

import bitfield
import crypto.sha256

/*
** Licensed under the MIT License
** (c) 2021 SheatNoisette
**
** See LICENSE for more details
*/

const (
	// Number of bits of the bloom filter by default
	sh_bloom_default_size = 256
)

struct BloomFilter {
pub mut:
	// Bit actual bloom filter
	data bitfield.BitField
	// Hash functions
	hash_fnc []fn (string) string
	// Size of the bloom filter
	size int
}

struct BloomExtArgs {
pub:
	size           int
	hash_functions []fn (string) string
}

// Create a new bloom filter
pub fn new() BloomFilter {
	return BloomFilter{
		data: bitfield.new(bloomfilter.sh_bloom_default_size)
		size: bloomfilter.sh_bloom_default_size
		hash_fnc: [sha256.hexhash]
	}
}

// Advanced bloom filter creation
pub fn new_ext(bargs BloomExtArgs) BloomFilter {
	return BloomFilter{
		data: bitfield.new(bargs.size)
		size: bargs.size
		hash_fnc: bargs.hash_functions
	}
}

// Is the Bloomtable empty ? (No data at all)
pub fn (mut fl BloomFilter) is_empty() bool {
	return bitfield.new(fl.size()) == fl.data
}

// Add a hash functions (string => string)
pub fn (mut fl BloomFilter) add_hash_functions(hashfncs ...fn (string) string) {
	for fnc in hashfncs {
		fl.hash_fnc << fnc
	}
}

// Clears the hash functions registered inside the filter
// THIS CLEARS THE FILTER DATA
pub fn (mut fl BloomFilter) reset_hash_functions() {
	fl.hash_fnc = []
	fl.clear()
}

// Get the size of the internal array
[inline]
pub fn (fl &BloomFilter) size() int {
	return fl.size
}

// Insert an element into the bloomfilter
pub fn (mut fl BloomFilter) add<T>(_value T) {
	str_value := any_to_str<T>(_value)
	hash := fl.get_hash_bitfield(str_value)
	fl.data = bitfield.bf_or(hash, fl.data)
}

// Check if a element is PROBABLY in the filter
// True: MIGHT be in the filter
// False: Is NOT in the filter
pub fn (mut fl BloomFilter) check<T>(_value T) bool {
	str_value := any_to_str<T>(_value)
	hash := fl.get_hash_bitfield(str_value)

	return bitfield.bf_and(hash, fl.data) == hash
}

// Clear the bloom filter
pub fn (mut fl BloomFilter) clear() {
	// Clear the data
	fl.data.clear_all()
}

// Change bloom filter size - WARNING: IT CLEARS THE BLOOM FILTER
// If the size is invalid, return false
pub fn (mut fl BloomFilter) resize(new_size int) bool {
	// Invalid value
	if new_size <= 0 {
		return false
	}

	// Reset content
	fl.clear()

	// Set new size
	fl.data.resize(new_size)

	// Update the size
	fl.size = new_size

	return true
}

// Convert a string into a binary representation
// Example "ab" => [0x01100001, 0x01100010]) => "0110000101100010"
fn string_to_binstring(input string) string {
	mut output_str := ''
	bytes_arr := input.bytes()

	for i in 0 .. bytes_arr.len {
		// Current carracter
		c := bytes_arr[bytes_arr.len - i - 1]

		for pos in 0 .. 8 {
			output_str = (int((c >> pos) & 0x1).str()) + output_str
		}
	}

	return output_str
}

// Convert a bitstring into a bitfield and force the size
fn string_to_bitfield(input string, size int) bitfield.BitField {
	// Invalid size (<= 0) return empty
	if size <= 0 {
		return bitfield.new(0)
	}

	// Convert to a binary string
	mut bitstring := string_to_binstring(input)

	// Already in the required size -> Exit
	if bitstring.len == size {
		return bitfield.from_str(bitstring)
	}

	// Too big ?
	if bitstring.len > size {
		return bitfield.from_str(bitstring[0..size])
	}

	// add "0" padding
	for _ in 0 .. (size - bitstring.len) {
		bitstring += '0'
	}

	return bitfield.from_str(bitstring)
}

// Hash a string and create a bitfield based on the hash functions defined
fn (mut fl BloomFilter) get_hash_bitfield(value string) bitfield.BitField {
	// Base bitfield
	mut base := bitfield.new(fl.size())

	// Hash it in succession
	for hfc in fl.hash_fnc {
		base = bitfield.bf_or(string_to_bitfield(hfc(value), fl.size()), base)
	}

	return base
}

// Convert any value to string
fn any_to_str<T>(_value T) string {
	return '$_value.str()'
}
