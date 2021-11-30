module bloomfilter

import crypto.sha256
import crypto.sha512

fn test_create_bloom() {
	filter := new()
	assert filter.size() == 256
}

fn test_add_elements() {
	mut filter := new()
	filter.add('Apple')
	filter.add('True')
	filter.add('False')

	assert filter.check('Apple') == true
	assert filter.check('True') == true
	assert filter.check('False') == true
	assert filter.check('Toast') == false
}

fn test_add_nothing() {
	mut filter := new()

	assert filter.check('Apple') == false
	assert filter.check('True') == false
	assert filter.check('False') == false
	assert filter.check('Toast') == false
}

fn test_multiple_types() {
	mut filter := new()

	filter.add('Apple')
	filter.add(12)
	filter.add(`a`)

	assert filter.check('Apple') == true
	assert filter.check(12) == true
	assert filter.check(`a`) == true

	assert filter.check('43') == false
	assert filter.check('Appleeeeeeee') == false
}

fn test_resize() {
	mut filter := new()

	assert filter.check('Apple') == false

	// This CLEARS the bloom filter
	filter.resize(512)

	filter.add('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA')
	assert filter.check('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA') == true
	assert filter.check('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA') == false
}

fn test_clange_algorithms() {
	mut filter := new()

	// Remove old hash functions and clear the filter
	filter.reset_hash_functions()
	filter.add_hash_functions(sha256.hexhash, sha512.hexhash)

	assert filter.check('Apple') == false

	filter.add('Apple')

	assert filter.check('Apple') == true
}

fn test_is_empty() {
	mut filter := new()

	assert filter.is_empty() == true

	filter.add('Ok')

	assert filter.is_empty() == false
}

fn test_init_ext() {
	mut filter := new_ext(size: 512, hash_functions: [sha256.hexhash])
	filter.add('ok')
	assert filter.check('ok') == true
}
