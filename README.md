Sega Technical Institute used ProASM for the Amiga to compile the game. A quirk is that ProASM upon runtime, if a branch to a subroutine was out of reach, it would instead generate a long-range jump instruction. These 'JmpTo' blocks help indicate how the game's source files were structured; for example, we know that Obj0A (bubbles), Obj38 (shield and invincibility), S1Obj4A (the unused warp effect), and Obj08 (water splashes) were stored in the same file.

This branch attempts to recreate the source code structure to the best of our knowledge.
