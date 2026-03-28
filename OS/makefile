ASM=nasm

SRC_DIR=src
BUILD_DIR=build

$(BUILD_DIR)/os.img: $(BUILD_DIR)/boot.bin $(BUILD_DIR)/kernel.bin
	dd if=$(BUILD_DIR)/boot.bin of=$(BUILD_DIR)/os.img conv=notrunc
	dd if=$(BUILD_DIR)/kernel.bin of=$(BUILD_DIR)/os.img bs=512 seek=1 conv=notrunc
	truncate -s 1440k $(BUILD_DIR)/os.img

$(BUILD_DIR)/boot.bin: $(SRC_DIR)/boot.asm 
	$(ASM) -f bin $(SRC_DIR)/boot.asm -o $(BUILD_DIR)/boot.bin
$(BUILD_DIR)/kernel.bin: $(SRC_DIR)/kernel.asm
	$(ASM) -f bin $(SRC_DIR)/kernel.asm -o $(BUILD_DIR)/kernel.bin