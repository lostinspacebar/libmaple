# Standard things
sp              := $(sp).x
dirstack_$(sp)  := $(d)
d               := $(subst :,_,$(dir))
d               := $(subst $(backslash),_,$(d))
BUILDDIRS       += $(BUILD_PATH)/$(dir)

LIBMAPLE_INCLUDES := -I$(LIBMAPLE_PATH)\include -I$(LIBMAPLE_MODULE_SERIES)\include
LIBMAPLE_PRIVATE_INCLUDES := -I$(LIBMAPLE_PATH)

# Local flags
CFLAGS_$(d) = $(LIBMAPLE_PRIVATE_INCLUDES) $(LIBMAPLE_INCLUDES) -Wall -Werror

# Local rules and targets
cSRCS_$(d) := adc.c
cSRCS_$(d) += dac.c
cSRCS_$(d) += dma.c
cSRCS_$(d) += exti.c
cSRCS_$(d) += flash.c
cSRCS_$(d) += gpio.c
cSRCS_$(d) += iwdg.c
cSRCS_$(d) += nvic.c
cSRCS_$(d) += pwr.c
cSRCS_$(d) += rcc.c
cSRCS_$(d) += spi.c
cSRCS_$(d) += systick.c
cSRCS_$(d) += timer.c
cSRCS_$(d) += usart.c
cSRCS_$(d) += usart_private.c
cSRCS_$(d) += util.c
sSRCS_$(d) := exc.S
# I2C support must be ported to F2:
ifeq ($(MCU_SERIES),stm32f1)
cSRCS_$(d) += i2c.c
endif

cFILES_$(d) := $(cSRCS_$(d):%=$(dir)/%)
sFILES_$(d) := $(sSRCS_$(d):%=$(dir)/%)

OBJS_$(d) := $(cFILES_$(d):%.c=$(BUILD_PATH)/%.o) $(sFILES_$(d):%.S=$(BUILD_PATH)/%.o)
DEPS_$(d) := $(OBJS_$(d):%.o=%.d)

CFLAGS_$(d) := $(subst :,\:,$(CFLAGS_$(d)))

$(warning $(CFLAGS_$(d)))

$(OBJS_$(d)): TGT_CFLAGS := $(CFLAGS_$(d))
$(OBJS_$(d)): TGT_ASFLAGS :=

TGT_BIN += $(OBJS_$(d))

# Standard things
-include        $(DEPS_$(d))
d               := $(dirstack_$(sp))
sp              := $(basename $(sp))
