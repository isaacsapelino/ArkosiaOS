# Compilers
ASM = nasm
ASM_FLAGS = -f bin

# Directories
BUILD_DIR = build
BOOT_DIR = boot

# Collect file types
BOOT_ASM = $(wildcard $(BOOT_DIR)/*.asm)

ASM_FILES = $(BOOT_ASM)

# Map source to build source (preserve directory structure)
BOOT_OBJ = $(patsubst $(BOOT_DIR)/%.asm,$(BUILD_DIR)/%.bin,$(BOOT_ASM))

FLOPPY_IMG = arkosia.img

all: dirs floppy $(BOOT_OBJ)
	dd if=$(BOOT_OBJ) of=$(FLOPPY_IMG) bs=512 count=1 conv=notrunc


floppy:
	dd if=/dev/zero of=$(FLOPPY_IMG) bs=512 count=2880
	mkfs.fat -F 12 -n ARKOSIAOS $(FLOPPY_IMG)

dirs:
	mkdir -pv $(BUILD_DIR)

# Compile 
$(BUILD_DIR)/%.bin: $(BOOT_DIR)/%.asm
	$(ASM) $(ASM_FLAGS) $< -o $@

clean:
	rm -rf $(BUILD_DIR) $(FLOPPY_IMG)

qemu: all
	qemu-system-i386 -fda arkosia.img
