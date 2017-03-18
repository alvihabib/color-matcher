# color-matcher
A color-matching memory game with LCD timer, VGA display, and PS/2 keyboard implementation for the Altera Cyclone V FPGA


![Screenshot](https://raw.githubusercontent.com/alvihabib/color-matcher/master/image.png "Screenshot")

## Overview:
* A representation of a grid of cards on a table. The objective of the game is to use the keyboard to select cards to
flip and match the colours behind them, two at a time.
* Correctly choosing matching colors results in cards remaining
flipped.
* Wrongly choosing colors results in cards being flipped back to
white.
* Game ends when all the cards are flipped and matched.
* Keyboard keys used as input for each card in the max 4x3 grid.
* `KEY[3]` used as go, `KEY[0]` used as enable.
* VGA used to show cards, and `HEX0`, `HEX1` shows timer.

## To run:
#### Load project file into Quartus and program the board via USB. To control game:
##### Step 1: Start by choosing a level with SW[2:0]
- `SW[0]` = Level 1 (2x2)
- `SW[1]` = Level 2 (3x2)
- `SW[2]` = Level 3 (3x8)
##### Step 2: Use the PS2 keyboard as a grid (Starting with ‘q’ at top left)
- Press `KEY[3]` to input that key
- Repeat twice to flip 2 cards
##### Step 3: repeat Step 2 until all colors are revealed
You win!


Timer in `HEX0` and `HEX1` to display the time you took to complete the level
