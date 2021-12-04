
VC = $(shell which v)
CC ?= gcc

all: tests fmt

tests:
	$(VC) -stats test .

test: tests

fmt:
	$(VC) fmt . -w