PROJECT_DIR:=$(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))

all:
	@$(PROJECT_DIR)/rebar3 compile

clean:
	@$(PROJECT_DIR)/rebar3 clean -a
	@find $(PROJECT_DIR)/. -name "erl_crash\.dump" | xargs rm -f
	@find $(PROJECT_DIR)/. -name "*\.so" | xargs rm -f

dialyze:
	@$(PROJECT_DIR)/rebar3 dialyzer

release:
	@$(PROJECT_DIR)/rebar3 as prod tar

run: all
	@erl -pa `$(PROJECT_DIR)/rebar3 path` \
	-name origami@127.0.0.1 \
	+K true \
	+P 5000000 \
	+Q 1000000 \
	-env ERL_FULLSWEEP_AFTER 10 \
	-config origami \
	-mnesia schema_location ram \
	-eval 'origami:start().'

tests:
	@$(PROJECT_DIR)/rebar3 as test compile
	ct_run -dir $(PROJECT_DIR)/test -logdir $(PROJECT_DIR)/test/results \
	-pa `$(PROJECT_DIR)/rebar3 as test path`
