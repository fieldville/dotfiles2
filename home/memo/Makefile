PAST_FILE := $(shell ls memo-*.md | tail -n 1)
TODAY_FILE := memo-$(shell date +%Y%m%d).md
TODAY := $(shell date +'# %Y/%m/%d(%a)')

create:
	[ "$(PAST_FILE)" != "$(TODAY_FILE)" ] && cp -f $(PAST_FILE) $(TODAY_FILE) || true
	sed -i "1s@.*@$(TODAY)@" $(TODAY_FILE) || true
	(git add $(shell ls memo-*.md | grep -v $(TODAY_FILE)) && git commit -am "$(shell date +%Y%m%d)") || true

today: create
	nvim $(TODAY_FILE)

archive-files:
	today_file=$(TODAY_FILE); \
	for file in $$(ls -1 memo-*.md | grep -v "$$today_file"); do \
	  YEAR=$$(echo $$file | cut -d '-' -f2 | cut -c1-4); \
	  MONTH=$$(echo $$file | cut -d '-' -f2 | cut -c5-6); \
	  mkdir -p archives/$$YEAR/$$MONTH; \
	  git mv $$file archives/$$YEAR/$$MONTH/; \
	done
