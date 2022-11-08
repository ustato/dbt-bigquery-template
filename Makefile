.DEFAULT_GOAL := help

.PHONY: help
help: ## show the help menu
	@grep -E '^[a-zA-Z][a-zA-Z._-]*:.*?## .*$$' $(MAKEFILE_LIST) \
		| sed -e 's/.*Makefile://g' \
		| awk 'BEGIN {FS = ": ## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

POETRY := poetry run
CD_DBT := cd dbt && $(POETRY)

setup: ## setup a virtualenv and pre-commit
	poetry config virtualenvs.in-project true
	@echo "\n"
	poetry env use 3.10.0
	@echo "\n"
	poetry install
	@echo "\n"
	@$(POETRY) pre-commit install
	@echo "\n"
	@$(CD_DBT) dbt deps --project-dir . --profiles-dir .

health-dbt: ## check dbt connection
	@$(CD_DBT) dbt run --project-dir . --profiles-dir .

lint: ## Run linter and formatter
	$(call banner,        💅 Linting code 💅)
	# ./.venv/bin/pre-commit run --all-files
	poetry run mypy ./src
	@echo "\n"
	poetry run isort ./src
	@echo "\n"
	poetry run flake8 ./src
	@echo "\n"
	poetry run black ./src

gen-ddoc: ## Generate Dbt document as html file
	$(call banner,        💅 Generating Dbt document as html file 💅)
	@$(CD_DBT) dbt docs generate --project-dir . --profiles-dir . --target local
	@echo "\n"
	@$(POETRY) python util/generate_dbt_docs.py


define banner
    @echo "$(BLUE)░▄▄▄▄░$(RESET_COLOR)"
    @echo "$(BLUE)▀▀▄██►$(RESET_COLOR)"
    @echo "$(BLUE)▀▀███►$(RESET_COLOR)"
    @echo "$(BLUE)░▀███►░█►$(RESET_COLOR)  $(1)"
    @echo "$(BLUE)▒▄████▀▀$(RESET_COLOR)"
    @echo ""
endef


RESET_COLOR   = \033[m

BLUE       = \033[1;34m
YELLOW     = \033[1;33m
GREEN      = \033[1;32m
RED        = \033[1;31m
BLACK      = \033[1;30m
MAGENTA    = \033[1;35m
CYAN       = \033[1;36m
WHITE      = \033[1;37m

DBLUE      = \033[0;34m
DYELLOW    = \033[0;33m
DGREEN     = \033[0;32m
DRED       = \033[0;31m
DBLACK     = \033[0;30m
DMAGENTA   = \033[0;35m
DCYAN      = \033[0;36m
DWHITE     = \033[0;37m

BG_WHITE   = \033[47m
BG_RED     = \033[41m
BG_GREEN   = \033[42m
BG_YELLOW  = \033[43m
BG_BLUE    = \033[44m
BG_MAGENTA = \033[45m
BG_CYAN    = \033[46m

# Name some of the colors
COM_COLOR   = $(DBLUE)
OBJ_COLOR   = $(DCYAN)
OK_COLOR    = $(DGREEN)
ERROR_COLOR = $(DRED)
WARN_COLOR  = $(DYELLOW)
NO_COLOR    = $(RESET_COLOR)

OK_STRING    = "[OK]"
ERROR_STRING = "[ERROR]"
WARN_STRING  = "[WARNING]"
