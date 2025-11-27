.syntax unified
.cpu cortex-m3
.fpu softvfp
.thumb

.global  g_pfnVectors
.global  Default_Handler

.word  _sidata
.word  _sdata
.word  _edata
.word  _sbss
.word  _ebss

.equ  BootRAM, 0xF1E0F85F

.section  .text.Reset_Handler
.weak  Reset_Handler
.type  Reset_Handler, %function
Reset_Handler:
  ldr   sp, =_estack

  movs  r1, #0
  b  LoopCopyDataInit

CopyDataInit:
  ldr  r3, =_sidata
  ldr  r3, [r3, r1]
  str  r3, [r0, r1]
  adds  r1, r1, #4

LoopCopyDataInit:
  ldr  r0, =_sdata
  ldr  r3, =_edata
  adds  r2, r0, r1
  cmp  r2, r3
  bcc  CopyDataInit
  ldr  r2, =_sbss
  b  LoopFillZerobss

FillZerobss:
  movs  r3, #0
  str  r3, [r2], #4

LoopFillZerobss:
  ldr  r3, = _ebss
  cmp  r2, r3
  bcc  FillZerobss

  bl  SystemInit
  bl  main
  bx  lr
.size  Reset_Handler, .-Reset_Handler

.section  .text.Default_Handler,"ax",%progbits
Default_Handler:
Infinite_Loop:
  b  Infinite_Loop
  .size  Default_Handler, .-Default_Handler

.macro  DEF_IRQ_Handler handler
.weak  \handler
.thumb_set \handler,Default_Handler
.endm

DEF_IRQ_Handler NMI_Handler
DEF_IRQ_Handler HardFault_Handler
DEF_IRQ_Handler MemManage_Handler
DEF_IRQ_Handler BusFault_Handler
DEF_IRQ_Handler UsageFault_Handler
DEF_IRQ_Handler SVC_Handler
DEF_IRQ_Handler DebugMon_Handler
DEF_IRQ_Handler PendSV_Handler
DEF_IRQ_Handler SysTick_Handler
DEF_IRQ_Handler WWDG_IRQHandler
DEF_IRQ_Handler PVD_IRQHandler
DEF_IRQ_Handler TAMPER_IRQHandler
DEF_IRQ_Handler RTC_IRQHandler
DEF_IRQ_Handler FLASH_IRQHandler
DEF_IRQ_Handler RCC_IRQHandler
DEF_IRQ_Handler EXTI0_IRQHandler
DEF_IRQ_Handler EXTI1_IRQHandler
DEF_IRQ_Handler EXTI2_IRQHandler
DEF_IRQ_Handler EXTI3_IRQHandler
DEF_IRQ_Handler EXTI4_IRQHandler
DEF_IRQ_Handler DMA1_Channel1_IRQHandler
DEF_IRQ_Handler DMA1_Channel2_IRQHandler
DEF_IRQ_Handler DMA1_Channel3_IRQHandler
DEF_IRQ_Handler DMA1_Channel4_IRQHandler
DEF_IRQ_Handler DMA1_Channel5_IRQHandler
DEF_IRQ_Handler DMA1_Channel6_IRQHandler
DEF_IRQ_Handler DMA1_Channel7_IRQHandler
DEF_IRQ_Handler ADC1_2_IRQHandler
DEF_IRQ_Handler USB_HP_CAN1_TX_IRQHandler
DEF_IRQ_Handler USB_LP_CAN1_RX0_IRQHandler
DEF_IRQ_Handler CAN1_RX1_IRQHandler
DEF_IRQ_Handler CAN1_SCE_IRQHandler
DEF_IRQ_Handler EXTI9_5_IRQHandler
DEF_IRQ_Handler TIM1_BRK_IRQHandler
DEF_IRQ_Handler TIM1_UP_IRQHandler
DEF_IRQ_Handler TIM1_TRG_COM_IRQHandler
DEF_IRQ_Handler TIM1_CC_IRQHandler
DEF_IRQ_Handler TIM2_IRQHandler
DEF_IRQ_Handler TIM3_IRQHandler
DEF_IRQ_Handler TIM4_IRQHandler
DEF_IRQ_Handler I2C1_EV_IRQHandler
DEF_IRQ_Handler I2C1_ER_IRQHandler
DEF_IRQ_Handler I2C2_EV_IRQHandler
DEF_IRQ_Handler I2C2_ER_IRQHandler
DEF_IRQ_Handler SPI1_IRQHandler
DEF_IRQ_Handler SPI2_IRQHandler
DEF_IRQ_Handler USART1_IRQHandler
DEF_IRQ_Handler USART2_IRQHandler
DEF_IRQ_Handler USART3_IRQHandler
DEF_IRQ_Handler EXTI15_10_IRQHandler
DEF_IRQ_Handler RTCAlarm_IRQHandler
DEF_IRQ_Handler USBWakeUp_IRQHandler
DEF_IRQ_Handler TIM5_IRQHandler
DEF_IRQ_Handler SPI3_IRQHandler
DEF_IRQ_Handler UART4_IRQHandler
DEF_IRQ_Handler UART5_IRQHandler
DEF_IRQ_Handler TIM6_IRQHandler
DEF_IRQ_Handler TIM7_IRQHandler
DEF_IRQ_Handler DMA2_Channel1_IRQHandler
DEF_IRQ_Handler DMA2_Channel2_IRQHandler
DEF_IRQ_Handler DMA2_Channel3_IRQHandler
DEF_IRQ_Handler DMA2_Channel4_IRQHandler
DEF_IRQ_Handler DMA2_Channel5_IRQHandler
DEF_IRQ_Handler ETH_IRQHandler
DEF_IRQ_Handler ETH_WKUP_IRQHandler
DEF_IRQ_Handler CAN2_TX_IRQHandler
DEF_IRQ_Handler CAN2_RX0_IRQHandler
DEF_IRQ_Handler CAN2_RX1_IRQHandler
DEF_IRQ_Handler CAN2_SCE_IRQHandler
DEF_IRQ_Handler OTG_FS_IRQHandler

.section  .isr_vector,"a",%progbits
.type  g_pfnVectors, %object
.size  g_pfnVectors, .-g_pfnVectors

g_pfnVectors:
  .word  _estack
  .word  Reset_Handler
  .word  NMI_Handler
  .word  HardFault_Handler
  .word  MemManage_Handler
  .word  BusFault_Handler
  .word  UsageFault_Handler
  .word  0
  .word  0
  .word  0
  .word  0
  .word  SVC_Handler
  .word  DebugMon_Handler
  .word  0
  .word  PendSV_Handler
  .word  SysTick_Handler
  .word  WWDG_IRQHandler
  .word  PVD_IRQHandler
  .word  TAMPER_IRQHandler
  .word  RTC_IRQHandler
  .word  FLASH_IRQHandler
  .word  RCC_IRQHandler
  .word  EXTI0_IRQHandler
  .word  EXTI1_IRQHandler
  .word  EXTI2_IRQHandler
  .word  EXTI3_IRQHandler
  .word  EXTI4_IRQHandler
  .word  DMA1_Channel1_IRQHandler
  .word  DMA1_Channel2_IRQHandler
  .word  DMA1_Channel3_IRQHandler
  .word  DMA1_Channel4_IRQHandler
  .word  DMA1_Channel5_IRQHandler
  .word  DMA1_Channel6_IRQHandler
  .word  DMA1_Channel7_IRQHandler
  .word  ADC1_2_IRQHandler
  .word  USB_HP_CAN1_TX_IRQHandler
  .word  USB_LP_CAN1_RX0_IRQHandler
  .word  CAN1_RX1_IRQHandler
  .word  CAN1_SCE_IRQHandler
  .word  EXTI9_5_IRQHandler
  .word  TIM1_BRK_IRQHandler
  .word  TIM1_UP_IRQHandler
  .word  TIM1_TRG_COM_IRQHandler
  .word  TIM1_CC_IRQHandler
  .word  TIM2_IRQHandler
  .word  TIM3_IRQHandler
  .word  TIM4_IRQHandler
  .word  I2C1_EV_IRQHandler
  .word  I2C1_ER_IRQHandler
  .word  I2C2_EV_IRQHandler
  .word  I2C2_ER_IRQHandler
  .word  SPI1_IRQHandler
  .word  SPI2_IRQHandler
  .word  USART1_IRQHandler
  .word  USART2_IRQHandler
  .word  USART3_IRQHandler
  .word  EXTI15_10_IRQHandler
  .word  RTCAlarm_IRQHandler
  .word  USBWakeUp_IRQHandler
  .word  TIM5_IRQHandler
  .word  SPI3_IRQHandler
  .word  UART4_IRQHandler
  .word  UART5_IRQHandler
  .word  TIM6_IRQHandler
  .word  TIM7_IRQHandler
  .word  DMA2_Channel1_IRQHandler
  .word  DMA2_Channel2_IRQHandler
  .word  DMA2_Channel3_IRQHandler
  .word  DMA2_Channel4_IRQHandler
  .word  DMA2_Channel5_IRQHandler
  .word  ETH_IRQHandler
  .word  ETH_WKUP_IRQHandler
  .word  CAN2_TX_IRQHandler
  .word  CAN2_RX0_IRQHandler
  .word  CAN2_RX1_IRQHandler
  .word  CAN2_SCE_IRQHandler
  .word  OTG_FS_IRQHandler
  .word  BootRAM
