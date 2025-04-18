PAST_FILE := $(shell ls memo-*.md | tail -n 1)
TODAY := memo-$(shell date +%Y%m%d).md

create:
	cp -f $(PAST_FILE) $(TODAY)
	git add $(shell ls memo-*.md | grep -v $(TODAY))

today: create
	git commit -am "$(shell date +%Y%m%d)"
	nvim $(TODAY)

archive-files:
	TODAY=$(TODAY); \
	for file in $$(ls -1 memo-*.md | grep -v "$$TODAY"); do \
	  YEAR=$$(echo $$file | cut -d '-' -f2 | cut -c1-4); \
	  MONTH=$$(echo $$file | cut -d '-' -f2 | cut -c5-6); \
	  mkdir -p archives/$$YEAR/$$MONTH; \
	  git mv $$file archives/$$YEAR/$$MONTH/; \
	done
