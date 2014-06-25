Game Theory Analysis
====================

This repository is for testing and analyising the code written for Sage Mathematical Software which can be found at https://github.com/theref/sage-game-theory

Assuming that sage is in your path, you can run the script by ``sage /path/to/script.sage``.


Our aim is for it to generate a random Normal Form Game. Then solve that game using 3 different methods; lrs, LCP and enumeration. From this we will record:
 - Date
 - Time
 - Size of Game
 - Ring
 - Payoff Matrix for Player1 and Player2
 - Ouput from lrs, LCP and enumeration
 - Time taken by lrs, LCP and enumeration

These will then be written to a csv file.
Example output:

25/06/2014,09:49:06,"(4, 4)",Integer Ring,"[(-5, -17, 4, 6), (-18, -21, -7, -20), (16, -2, -6, -11), (21, 24, 1, 9)]","[(2, 19, 18, -9), (-21, 5, -10, -11), (16, 12, -6, -11), (16, 19, -11, 0)]",0.9216248989105225,1.5128719806671143,1.7181739807128906,"[[(0, 0, 0, 1), (0, 1, 0, 0)]]","[[(0.0, 0.0, 0.0, 1.0), (0.0, 1.0, 0.0, 0.0)]]","[[(0, 0, 0, 1), (0, 1, 0, 0)]]"


### Plan For Analysis

Use Sage to create 2 simple graphs. One for Rational Ring and one for Integer Ring. Along the x-axis will be the number of elementse in the matrices (``rows`` x ``cols``). Y-axis will show the time taken. Each method will have it's own colour. Lrs-red, LCP-blue, enumeration-green, for example.

Will produce a report of all games where the 3 methods did not produce the same number of Nash Equilibria.

Will produce a report of all games where the 3 methods did not produce Nash Equilibria that were equal. This will need a tolerance set to deal with the fact that Gambit returns floats not rationals.
