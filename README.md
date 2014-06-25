Game Theory Analysis
====================

This repository is for testing and analyising the code written for Sage Mathematical Software which can be found (here)[https://github.com/theref/sage-game-theory].

Assuming that sage is in your path, you can run the script by ``sage /path/to/script.sage``.


Our aim is for it to generate a random Normal Form Game. Then solve that game using 3 different methods; lrs, LCP and enumeration. From this we will record:
 - Date
 - Time
 - Size of Game
 - Payoff Matrix for Player1 and Player2
 - Ouput from lrs, LCP and enumeration
 - Time taken by lrs, LCP and enumeration

Example output:
'25/06/2014', '08:47:29', (5, 2), [(-2, 1, -1, -2, 0), (-1, 0, 2, -1, 0)], [(2, 0, 0, -1, -1), (0, -2, 2, 1/2, 0)], 1.0004150867462158, 1.5312190055847168, 0.39747095108032227, [[(0, 1), (0, 0, 1, 0, 0)]], [[(0.0, 1.0), (0.0, 0.0, 1.0, 0.0, 0.0)]], [[(0, 1), (0, 0, 1, 0, 0)]]