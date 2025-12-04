TOP = spm_chip
TAG = spm
PROJECT_DIR = $(shell pwd)

LIBRELANE_DIR ?= $(PROJECT_DIR)/librelane
PDK_ROOT ?= $(PROJECT_DIR)/pdk


PDK = ihp-sg13g2

CONFIG_FILE = $(PROJECT_DIR)/config.json

# CFG_FILES:= \
# 	$(CONFIG_FILE) \
# 	$(PROJECT_DIR)/constraint.sdc \
# 	$(SCRIPTS_DIR)/pdn.tcl \
# 	$(SCRIPTS_DIR)/pad.tcl 

all: librelane sealring fillers drc lvs
.PHONY: all

######################### LIBRELANE #########################

librelane: final/gds/$(TOP).gds
.PHONY: librelane

final/gds/$(TOP).gds: $(CFG_FILES)
	# Run librelane to generate the layout
	nix-shell --pure $(LIBRELANE_DIR) --run "PDK_ROOT=$(PDK_ROOT) PDK=$(PDK) librelane --run-tag $(TAG) --overwrite --manual-pdk $(CONFIG_FILE)"

	# copy final results to top directory
	rm -rf $(PROJECT_DIR)/final
	cp -r $(PROJECT_DIR)/runs/$(TAG)/final $(PROJECT_DIR)


librelane-skip-synth:
	# Run librelane to generate the layout
	nix-shell --pure $(LIBRELANE_DIR) --run "PDK_ROOT=$(PDK_ROOT) PDK=$(PDK) librelane --manual-pdk --run-tag $(TAG)_no_synth --with-initial-state runs/$(TAG)/06-yosys-synthesis/state_out.json --from Checker.YosysUnmappedCells --overwrite $(CONFIG_FILE)"

	# copy final results to top directory
	rm -rf $(PROJECT_DIR)/final
	cp -r $(PROJECT_DIR)/runs/$(TAG)_no_synth