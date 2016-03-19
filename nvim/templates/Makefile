.PHONY: all compile compile_test test clean

all: compile

compile:
	@erlc -pa ebin/ -o ebin/ src/*.erl

compile_test: compile
	@erlc -pa ebin/ -o ebin/ test/*.erl

test: compile_test
	@erl -noshell -pa ebin \
		-eval 'eunit:test("ebin")' \
		-s init stop

clean:
	@rm -f ebin/*.beam erl_crash.dump
