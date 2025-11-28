PREFIX = arm-none-eabi-
CC = $(PREFIX)gcc
AS = $(PREFIX)gcc
OBJCOPY = $(PREFIX)objcopy
SIZE = $(PREFIX)size

TARGET = stm32f103c8t6
MCU = cortex-m3

CFLAGS = -mcpu=cortex-m3 -mthumb -mlittle-endian -Os -g \
         -ffunction-sections -fdata-sections \
         -DSTM32F10X_MD -DUSE_STDPERIPH_DRIVER \
         -Wall -Wextra \
         -Icommon -Idevice -Idrivers -ICMSIS

LDFLAGS = -Tstartup/$(TARGET).ld -nostartfiles
LDFLAGS += -Wl,--gc-sections -specs=nano.specs -specs=nosys.specs

# 精确指定需要编译的源文件，排除有问题的文件
STARTUP_SRCS = $(filter-out startup/core_cm3.c, $(wildcard startup/*.c))  # 排除 core_cm3.c
DRIVER_SRCS = $(wildcard drivers/*.c)
DEVICE_SRCS = $(wildcard device/*.c)
USER_SRCS = $(wildcard user/*.c)

ASM_SRCS = $(wildcard startup/*.s)
# 合并所有源文件
C_SOURCES =$(STARTUP_SRCS) $(DRIVER_SRCS) $(DEVICE_SRCS) $(USER_SRCS)
ASM_SOURCES = $(ASM_SRCS)

# 生成目标文件列表（保持文件名）
OBJS = $(addprefix build/,$(notdir $(C_SOURCES:.c=.o) $(ASM_SOURCES:.s=.o)))

INCLUDES = -Iuser -Idevice -Istartup -Idrivers -Icommon	

ELF = build/$(TARGET).elf
BIN = build/$(TARGET).bin

all: $(BIN)

$(BIN): $(ELF)
	@echo "生成二进制文件..."
	$(OBJCOPY) -O binary $< $@

$(ELF): $(OBJS)
	@echo "链接目标文件..."
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^
	$(SIZE) $@

# 编译规则 - 每个目录单独处理
build/%.o: user/%.c
	@mkdir -p build
	$(CC) $(CFLAGS) $(INCLUDES) -c -o $@ $<

build/%.o: device/%.c
	@mkdir -p build
	$(CC) $(CFLAGS) $(INCLUDES) -c -o $@ $<

build/%.o: startup/%.c
	@mkdir -p build
	$(CC) $(CFLAGS) $(INCLUDES) -c -o $@ $<

build/%.o: drivers/%.c
	@mkdir -p build
	$(CC) $(CFLAGS) $(INCLUDES) -c -o $@ $<

build/%.o: startup/%.s
	@mkdir -p build
	$(AS) -mcpu=$(MCU) -mthumb -c -o $@ $<

clean:
	@echo "清理构建文件..."
	rm -rf build

flash: $(BIN)
	@echo "下载程序..."
	openocd -f interface/seekfree_dap.cfg -f target/stm32f1x.cfg \
	        -c "program $(BIN) verify reset exit 0x08000000"

.PHONY: all clean flash