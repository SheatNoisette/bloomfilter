module bloomfilter

import crypto.sha256
import crypto.sha512

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

fn test_clear() {
	mut filter := new()

	assert filter.check('Ok') == false
	filter.add('Ok')
	assert filter.check('Ok') == true
	filter.clear()
	assert filter.check('Ok') == false
}

fn reset_hash_function() {
	mut filter := new()
	assert filter.check('Ok') == false
	filter.add('Ok')
	filter.reset_hash_functions()
	assert filter.check('Ok') == false
	filter.add('12')
	// Not recommended - High probability of colisions if multiple types are
	// used
	assert filter.check('12') == true
	assert filter.check('123') == false
	assert filter.check(12) == false
}
