# Useful tools
CC       := arm-none-eabi-gcc
CXX      := arm-none-eabi-g++
LD       := arm-none-eabi-ld -v
AR       := arm-none-eabi-ar
AS       := arm-none-eabi-gcc
OBJCOPY  := arm-none-eabi-objcopy
DISAS    := arm-none-eabi-objdump
OBJDUMP  := arm-none-eabi-objdump
SIZE     := arm-none-eabi-size
DFU      := dfu-util

# Suppress annoying output unless V is set
ifdef V
   SILENT_CC       = @echo '  [CC]       ' $(@:$(BUILD_PATH)/%.o=%.c) $(COMMAND_SEPARATOR)
   SILENT_AS       = @echo '  [AS]       ' $(@:$(BUILD_PATH)/%.o=%.S) $(COMMAND_SEPARATOR)
   SILENT_CXX      = @echo '  [CXX]      ' $(@:$(BUILD_PATH)/%.o=%.cpp) $(COMMAND_SEPARATOR)
   SILENT_LD       = @echo '  [LD]       ' $(@F) $(COMMAND_SEPARATOR)
   SILENT_AR       = @echo '  [AR]       '
   SILENT_OBJCOPY  = @echo '  [OBJCOPY]  ' $(@F) $(COMMAND_SEPARATOR)
   SILENT_DISAS    = @echo '  [DISAS]    ' $(@:$(BUILD_PATH)/%.bin=%).disas $(COMMAND_SEPARATOR)
   SILENT_OBJDUMP  = @echo '  [OBJDUMP]  ' $(OBJDUMP) $(COMMAND_SEPARATOR)
endif

# Extra build configuration

BUILDDIRS :=
TGT_BIN   :=

CFLAGS   = $(GLOBAL_CFLAGS) $(TGT_CFLAGS)
CXXFLAGS = $(GLOBAL_CXXFLAGS) $(TGT_CXXFLAGS)
ASFLAGS  = $(GLOBAL_ASFLAGS) $(TGT_ASFLAGS)

# Hacks to determine extra libraries we need to link against based on
# the toolchain. The default specifies no extra libraries, but it can
# be overridden.
LD_TOOLCHAIN_PATH := $(LDDIR)/toolchains/generic
ifneq ($(findstring ARM/embedded,$(shell $(CC) --version)),)
# GCC ARM Embedded, https://launchpad.net/gcc-arm-embedded/
LD_TOOLCHAIN_PATH := $(LDDIR)/toolchains/gcc-arm-embedded
endif
# Add toolchain directory to LD search path
TOOLCHAIN_LDFLAGS := -L $(LD_TOOLCHAIN_PATH)

# General directory independent build rules, generate dependency information
$(BUILD_PATH)/%.o: %.c
	$(SILENT_CC) $(CC) $(CFLAGS) -MMD -MP -MF $(@:%.o=%.d) -MT $@ -o $@ -c $<

$(BUILD_PATH)/%.o: %.cpp
	$(SILENT_CXX) $(CXX) $(CFLAGS) $(CXXFLAGS) -MMD -MP -MF $(@:%.o=%.d) -MT $@ -o $@ -c $<

$(BUILD_PATH)/%.o: %.S
	$(SILENT_AS) $(AS) $(ASFLAGS) -MMD -MP -MF $(@:%.o=%.d) -MT $@ -o $@ -c $<
