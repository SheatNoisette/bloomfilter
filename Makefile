
VC = $(shell which v)
CC ?= gcc

all: tests fmt

tests:
	$(VC) -stats test .

fmt:
	$(VC) fmt . -w