# Lab1

How to Run:
  Use Processing
  
What it Does:
  Simulates Conway's Game of life with additional rules, the first generation is 
  determined randomly
  
  Also I used Skarner from League of Legends
  
Rules:
  Cells come alive if they have 3 living neighbors
  Cells die if they have more than 5 neighbors
  Cells damage themselves (lose health) if they have more than 3 neighbors
  Cells can live with less than 2 neighbors provided they have at least 4 health
  Cells may move in a random direction after every generation, they also lose 1 health
  
The biological significance of my addition is how overcrowding and absence, while not 
lethal, can influence an organism's health

The technical signifigance is related to the walking of each scorpion. The scorpions 
have collision detection and an additional rule was added to account for this (scorpions
can live alone provided they have enough health). I also added health into the equation,
and scorpions can lose health without dying. Instead of an integer array, I had to use
objects to make this happen. I also attempted to add in Predator/Prey relations but I
could not get that part to work unfortunately. The failed file will be uploaded as well.
