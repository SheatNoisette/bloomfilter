
VC = $(shell which v)
CC ?= gcc

all: tests fmt

doc:
	$(VC) doc bloomfilter.v -f md -o docs/

tests:
	$(VC) -stats test .

test: tests

fmt:
	$(VC) fmt . -w