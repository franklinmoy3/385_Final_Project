# 385_Final_Project
This is a 2-player, 2D top-down shooter where players go head to head in tank combat. This game features 2-player local multiplayer, collectable upgrades, a scoring system shown on the FPGA's hex displays, and random arenas.

## How to Run
Simply clone this repository (or download it), open `lab61.qpf` as a project in Quartus, compile it, and then program your DE-10 Lite FPGA. Because this game is controlled using the USB keyboard connected to the ECE 385 Shield, you will also need to open the Nios II Build Tools for Eclipse under the Tools menu in Quartus, import the project into Eclipse, build the BSP and the C files, and then run it under Run Configurations.

## Controls
- Player 1
  - Up: W key
  - Down: S key
  - Left: A key
  - Right: D key
  - Fire: Spacebar
- Player 2
  - Up: Up arrow key
  - Down: Down arrow key
  - Left: Left arrow key
  - Right: Right arrow key
  - Fire: Keypad enter

## Requirements
- Intel Quartus 18.1
- terASIC DE-10 Lite FPGA
- VGA monitor and cable