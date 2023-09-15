
GSD5_DIR=../gsd5
GSD5_OUTPUT_DIR=../gsd5-output
GSD5_EMPTY_FILE=index.html
GSD5X_EMPTY_FILE=externalcore.html

TIDDLYWIKI_DIR=../TiddlyWiki5

BUILD_DIR=./build

.PHONY: build
build:
	@mkdir -p $(BUILD_DIR)
	cd $(TIDDLYWIKI_DIR) && git log -n1
	cd $(GSD5_DIR) && git log -n1 && bin/build.sh
	cp $(GSD5_OUTPUT_DIR)/$(GSD5_EMPTY_FILE) $(BUILD_DIR)/
	cp $(GSD5_OUTPUT_DIR)/$(GSD5X_EMPTY_FILE) $(BUILD_DIR)/

# Use the script in the tiddlyhost examples directory for uploading
# Example usage:
#   TH_LOGIN=simon.baird@gmail.com TH_PASS_FILE=~/.thostpass make upload
TH_DIR=../tiddlyhost
UPLOADER=$(TH_DIR)/examples/thost-uploader
BACKUPS_DIR=./backups
upload:
	@mkdir -p $(BACKUPS_DIR)
	@env DOWNLOAD_DIR=$(BACKUPS_DIR) $(UPLOADER) gsd5-empty $(BUILD_DIR)/$(GSD5_EMPTY_FILE) $(TH_LOGIN) $$(cat $(TH_PASS_FILE))
	@env DOWNLOAD_DIR=$(BACKUPS_DIR) $(UPLOADER) gsd5x-empty $(BUILD_DIR)/$(GSD5X_EMPTY_FILE) $(TH_LOGIN) $$(cat $(TH_PASS_FILE))

update: build upload

clean:
	@rm -rf $(BUILD_DIR)/* $(BACKUPS_DIR)/*
