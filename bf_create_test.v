module bloomfilter

import crypto.sha256
import crypto.sha512

fn test_create_bloom() {
	filter := new()
	assert filter.size() == sh_bloom_default_size
}

fn test_create_ext() {
	mut filter := new_ext(size: 512, hash_functions: [sha512.hexhash])
	filter.add('ok')
	assert filter.check('ok')
	assert filter.size() == 512
}

fn test_init_ext_mismatch_size() {
	mut filter := new_ext(size: 512, hash_functions: [sha256.hexhash])
	filter.add('ok')
	assert filter.check('ok') == true
}
