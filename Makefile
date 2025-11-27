# 完整的 Makefile
PREFIX = arm-none-eabi-
CC = $(PREFIX)gcc
AS = $(PREFIX)gcc
OBJCOPY = $(PREFIX)objcopy
SIZE = $(PREFIX)size

TARGET = stm32f103c8t6
MCU = cortex-m3

CFLAGS = -mcpu=$(MCU) -mthumb -mlittle-endian -Os -g
CFLAGS += -ffunction-sections -fdata-sections
CFLAGS += -DSTM32F10X_MD -DUSE_STDPERIPH_DRIVER
CFLAGS += -Wall -Wextra

LDFLAGS = -Tstartup/$(TARGET).ld -nostartfiles
LDFLAGS += -Wl,--gc-sections -specs=nano.specs -specs=nosys.specs

INCLUDES = -Iuser/inc -Iinc -Istartup -Idrivers/STM32F10x_StdPeriph_Driver/inc

ELF = build/$(TARGET).elf
BIN = build/$(TARGET).bin

all: $(BIN)

$(BIN): $(ELF)
	@echo "生成二进制文件..."
	$(OBJCOPY) -O binary $< $@

$(ELF): build/main.o build/stm32f10x_it.o build/Delay.o build/system.o build/startup.o build/gpio.o build/rcc.o
	@echo "链接目标文件..."
	@mkdir -p build
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^
	$(SIZE) $@

build/main.o: user/main.c
	@mkdir -p build
	$(CC) $(CFLAGS) $(INCLUDES) -c -o $@ $<

build/stm32f10x_it.o: src/stm32f10x_it.c
	@mkdir -p build
	$(CC) $(CFLAGS) $(INCLUDES) -c -o $@ $<

build/Delay.o: src/Delay.c
	@mkdir -p build
	$(CC) $(CFLAGS) $(INCLUDES) -c -o $@ $<

build/system.o: startup/system_stm32f10x.c
	@mkdir -p build
	$(CC) $(CFLAGS) $(INCLUDES) -c -o $@ $<

build/startup.o: startup/startup_stm32f10x.s
	@mkdir -p build
	$(AS) -mcpu=$(MCU) -mthumb -c -o $@ $<

build/gpio.o: drivers/STM32F10x_StdPeriph_Driver/src/stm32f10x_gpio.c
	@mkdir -p build
	$(CC) $(CFLAGS) $(INCLUDES) -c -o $@ $<

build/rcc.o: drivers/STM32F10x_StdPeriph_Driver/src/stm32f10x_rcc.c
	@mkdir -p build
	$(CC) $(CFLAGS) $(INCLUDES) -c -o $@ $<

clean:
	@echo "清理构建文件..."
	rm -rf build

flash: $(BIN)
	@echo "下载程序..."
	openocd -f interface/seekfree_dap.cfg -f target/stm32f1x.cfg \
	        -c "program $(BIN) verify reset exit 0x08000000"

.PHONY: all clean flash