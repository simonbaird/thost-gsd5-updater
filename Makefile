
GSD5_DIR=../gsd5
GSD5_OUTPUT_DIR=../gsd5-output
GSD5_EMPTY_FILE=index.html
GSD5_EMPTY_PATH=$(GSD5_OUTPUT_DIR)/$(GSD5_EMPTY_FILE)

TIDDLYWIKI_DIR=../TiddlyWiki5

build:
	cd $(TIDDLYWIKI_DIR) && git log -n1
	cd $(GSD5_DIR) && git log -n1 && bin/build.sh
	cp $(GSD5_EMPTY_PATH) .

# Use the script in the tiddlyhost examples directory for uploading
# Example usage:
#   TH_LOGIN=simon.baird@gmail.com TH_PASS_FILE=~/.thostpass make upload
TH_DIR=../tiddlyhost
UPLOADER=$(TH_DIR)/examples/thost-uploader
BACKUPS_DIR=$(MPTW_DIR)/backups
upload:
	$(UPLOADER) gsd5-empty $(GSD5_EMPTY_FILE) $(TH_LOGIN) $$(cat $(TH_PASS_FILE))

update: build upload
