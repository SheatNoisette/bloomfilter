module bloomfilter

fn test_resize() {
	mut filter := new()

	assert filter.check('Apple') == false

	// This CLEARS the bloom filter
	filter.resize(512)

	assert filter.size() == 512

	filter.add('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA')

	assert filter.check('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA') == true
	assert filter.check('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA') == false
}

// Resize the filter then check is if has been cleared
fn test_resize_cleared() {
	mut filter := new()

	filter.add(42)

	assert filter.check(42)

	filter.resize(1024)

	assert filter.check(42) == false
}
