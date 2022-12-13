module bloomfilter

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

fn test_add_same() {
	mut filter := new()

	filter.add('Apple')
	filter.add('Apple')

	assert filter.check('Apple') == true
}

fn test_add_empty_string() {
	mut filter := new()
	assert filter.check('') == false
	filter.add('')
	assert filter.check('')
}

fn test_add_non_ascii() {
	mut filter := new()
	filter.add('éàéàéà')
	assert filter.check('éàéàé') == false
	assert filter.check('éàéàéà') == true
}

fn test_add_emoji() {
	mut filter := new()
	filter.add('😊')
	assert filter.check('😊!') == false
	assert filter.check('😊') == true
}

fn test_loop() {
	mut filter := new()

	for i in 0 .. 10 {
		filter.add('${i}')
	}

	for i in 0 .. 10 {
		assert filter.check('${i}')
	}
}

fn test_loop_multiple_types() {
	mut filter := new()

	for i in 0 .. 10 {
		if i & 1 == 0 {
			filter.add('${i}')
		} else {
			filter.add(i)
		}
	}

	for i in 0 .. 10 {
		if i & 1 == 0 {
			assert filter.check('${i}')
		} else {
			assert filter.check(i)
		}
	}
}

fn test_add_longstring() {
	mut str := ''
	mut filter := new()

	for _ in 0 .. 1024 {
		str += 'No'
	}

	filter.add(str)

	assert filter.check(str)
}

fn test_add_hex() {
	mut filter := new()
	filter.add(0xff12)
	assert filter.check(0xff10) == false
	assert filter.check(0xff12) == true
}
