# Macros:
include config.mk

TXT_FILES=$(wildcard $(TXT_DIR)/*.txt)
DAT_FILES=$(patsubst $(TXT_DIR)/%.txt, %.dat, $(TXT_FILES))
PNG_FILES=$(patsubst $(TXT_DIR)/%.txt, %.png, $(TXT_FILES))

# Macros:
include config.mk

# Compile results file.
## results.txt : Generate Zipf summary table.
$(RESULTS_FILE) : $(ZIPF_SRC) $(DAT_FILES)
	$(LANGUAGE) $^ > $@

# Perform and archive the analysis.
## all        : Performs and archives the analysis.
.PHONY : all
all : $(ZIPF_ARCHIVE) 

$(ZIPF_ARCHIVE) : $(ZIPF_DIR)
	tar -czf $@ $<

$(ZIPF_DIR): Makefile config.mk $(RESULTS_FILE) \
             $(DAT_FILES) $(PNG_FILES) $(TXT_DIR) \
             $(COUNT_SRC) $(PLOT_SRC) $(ZIPF_SRC)
	mkdir -p $@
	cp -r $^ $@
	touch $@
 
# Count words.
## dats        : Count words in text files.
.PHONY : dats
dats : $(DAT_FILES)

%.dat : $(COUNT_SRC) $(TXT_DIR)/%.txt
	$(LANGUAGE) $^ $@

# Make plots.
.PHONY : plots 
plots : $(PNG_FILES)

%.png : $(PLOT_SRC) %.dat
	$(LANGUAGE) $^ $@

# Variables.
## variables   : print variables
.PHONY : variables
variables:
	@echo TXT_FILES: $(TXT_FILES)
	@echo DAT_FILES: $(DAT_FILES)
	@echo PNG_FILES: $(PNG_FILES)
	@echo RESULTS_FILE: $(RESULTS_FILE)
	@echo PNG_FILES: $(PNG_FILES)	
	@echo TXT_DIR: $(TXT_DIR)
	@echo ZIPF_DIR: $(ZIPF_DIR)
	@echo ZIPF_ARCHIVE: $(ZIPF_ARCHIVE)
# Clean.
## clean       : Remove auto-generated files.
.PHONY : clean
clean :
	rm -f $(DAT_FILES)
	rm -f $(RESULTS_FILE)
	rm -f $(PNG_FILES)
	rm -rf $(ZIPF_DIR)
	rm -f $(ZIPF_ARCHIVE)

# Help.
.PHONY : help
help : Makefile
	@sed -n 's/^##//p' $<
