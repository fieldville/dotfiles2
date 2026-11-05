# 業務用 PC 向けの簡易版。Makefile(本体)と違い gitleaks や VSCode に依存せず、
# nvim で今日のメモを開くだけ。使い方: make -f Makefile.work today
#
PAST_FILE := $(shell ls memo-*.md | tail -n 1)
TODAY_FILE := memo-$(shell date +%Y%m%d).md
# GNU Make 4.2 以前(macOS 標準の 3.81 など)は $(shell) 内の `#` をコメント開始と解釈するので変数経由で渡す。
# 曜日(%a)はロケール依存なので LC_ALL=C で英語表記(Thu など)に固定する。
HASH := \#
TODAY := $(shell LC_ALL=C date +'$(HASH) %Y/%m/%d(%a)')

create:
	[ "$(PAST_FILE)" != "$(TODAY_FILE)" ] && cp -f $(PAST_FILE) $(TODAY_FILE) || true
	sed -i.bak "1s@.*@$(TODAY)@" $(TODAY_FILE) && rm -f $(TODAY_FILE).bak || true
	(git add $(shell ls memo-*.md | grep -v $(TODAY_FILE)) && git commit -am "$(shell date +%Y%m%d)") || true

today: create
	nvim $(TODAY_FILE)

# 先週以前（今週より前）の日付のファイルを archives/YYYY/MM/ に移動する
# 相対日付の指定(GNU: -d "-N days" / BSD: -v-Nd)は BusyBox date では使えないので epoch 秒で計算する。
# 今日の 12 時台に寄せてから日数分戻すので、夏時間の切り替えをまたいでも日付はずれない
# (1$$h - 100 は %H の先頭ゼロを外すため)。epoch → 日付は GNU/BusyBox が -d @N、BSD(macOS)が -r N。
LAST_WEEK_END := $(shell h=$$(date +%H); e=$$(( $$(date +%s) + (112 - 1$$h) * 3600 - $$(date +%u) * 86400 )); date -d "@$$e" +%Y%m%d 2>/dev/null || date -r "$$e" +%Y%m%d)

archive-files:
	for file in $$(ls -1 memo-*.md); do \
	  DATE=$$(echo $$file | cut -d '-' -f2 | cut -c1-8); \
	  [ "$$DATE" -le "$(LAST_WEEK_END)" ] || continue; \
	  YEAR=$$(echo $$DATE | cut -c1-4); \
	  MONTH=$$(echo $$DATE | cut -c5-6); \
	  mkdir -p archives/$$YEAR/$$MONTH; \
	  git mv $$file archives/$$YEAR/$$MONTH/; \
	done
