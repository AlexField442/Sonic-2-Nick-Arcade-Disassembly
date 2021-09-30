@echo off
asm68k /o op+ /o os+ /o ow+ /o oz+ /o oaq+ /o osq+ /o omq+ /p /o ae- s2.asm, s2built.bin
rompad.exe s2built.bin 255 0
fixheadr.exe s2built.bin