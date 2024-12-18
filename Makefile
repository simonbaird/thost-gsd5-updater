
GSD5_DIR=../gsd5-core
GSD5_OUTPUT_DIR=../gsd5-output
GSD5_EMPTY_FILE=index.html
GSD5X_EMPTY_FILE=externalcore.html

TIDDLYWIKI_DIR=../TiddlyWiki5

BUILD_DIR=./build

TW_VERSION ?= 5.3.6

COREJS_URL=https://raw.githubusercontent.com/simonbaird/tiddlyhost/main/rails/public/tiddlywikicore-$(TW_VERSION).js

.PHONY: build-dir
build-dir:
	@mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/tiddlywikicore-$(TW_VERSION).js: build-dir
	curl -sL $(COREJS_URL) -o $@

corejs: $(BUILD_DIR)/tiddlywikicore-$(TW_VERSION).js

.PHONY: build
build: build-dir corejs
	cd $(TIDDLYWIKI_DIR) && git checkout v$(TW_VERSION) && git log --oneline -n1
	cd $(GSD5_DIR) && git log --oneline -n1 && bin/build.sh
	cp $(GSD5_OUTPUT_DIR)/$(GSD5_EMPTY_FILE) $(BUILD_DIR)/
	cp $(GSD5_OUTPUT_DIR)/$(GSD5X_EMPTY_FILE) $(BUILD_DIR)/

# Use the script in the tiddlyhost examples directory for uploading
TH_DIR=../tiddlyhost-com
UPLOADER=$(TH_DIR)/examples/thost-uploader
BACKUPS_DIR=./backups
upload:
	@mkdir -p $(BACKUPS_DIR)
	@env DOWNLOAD_DIR=$(BACKUPS_DIR) $(UPLOADER) gsd5-empty $(BUILD_DIR)/$(GSD5_EMPTY_FILE) $(TH_LOGIN) $$(cat $(TH_PASS_FILE))
	@env DOWNLOAD_DIR=$(BACKUPS_DIR) $(UPLOADER) gsd5x-empty $(BUILD_DIR)/$(GSD5X_EMPTY_FILE) $(TH_LOGIN) $$(cat $(TH_PASS_FILE))

# Example usage:
#   TW_VERSION=5.3.3 TH_LOGIN=simon.baird@gmail.com TH_PASS_FILE=../.thostpass make update
update: build upload

clean:
	@rm -rf $(BUILD_DIR)/* $(BACKUPS_DIR)/*
