//Zak Zapatka

int width = 900;
int height = 600;
int cellSize = 10;
int rows = height/cellSize;
int cols = width/cellSize;
int numGenerations;
int RELEASE_THE_HOUNDS = 2;
int MAX_HEALTH = 5;
Scorpion[][] grid = new Scorpion[cols][rows]; //original grid

void setup(){
  size(width, height);
  colorMode(HSB, 100);
  frameRate(15);
  populate(); 
  numGenerations = 1;
}

void draw(){
  //navigates 2d array
  for(int x=0; x<cols; x++){
    for(int y=0; y<rows; y++){
      grid[x][y].walk();
      grid[x][y].display();
      if(grid[x][y].isRabid()){
        if(grid[x][y].getNeighbors().size() > 0){
          for(int i=0; i<grid[x][y].getNeighbors().size(); i++){
            grid[x][y].getNeighbors().get(i).death();
            grid[x][y].kill();
          }
          grid[x][y].setTempVitality(grid[x][y].getVitality()+1);
        }
      } else {
        //cells can live on their own if they have at least 3 health
        if((grid[x][y].getVitality() > 0) && (grid[x][y].getNeighbors().size() < 2)){
          grid[x][y].setTempVitality(0);
        }
        //kills cells with than 3 neighbors
        if((grid[x][y].getVitality() > 0) && (grid[x][y].getNeighbors().size() > 4)){
          grid[x][y].setTempVitality(0);
        }
        //gives birth to cells with 3 neighbors
        if((grid[x][y].getVitality() <= 0) && (grid[x][y].getNeighbors().size() == 3)){
          grid[x][y].setTempVitality(MAX_HEALTH);
        }
      }
    }
  }
  //sets changes to be the current grid
  for(int x=0; x<cols; x++){
    for(int y=0; y<rows; y++){
      grid[x][y].update();
    }
  }
  numGenerations++;
  if(numGenerations == RELEASE_THE_HOUNDS){
    for(int i=1; i<3; i++){
      grid[(int)random(cols)][(int)random(rows)].makeRabid();
    }
  }
}

//randomly populates the grid with scorpions
void populate(){
  //navigates 2d array
  for(int x=0; x<cols; x++){
    for(int y=0; y<rows; y++){
      //instantiate cells of both grids
      grid[x][y] = new Scorpion(x,y,cellSize);
      //randomly determines which cells start out alive
      if(int(random(4))==1){
        grid[x][y].birth();
      } else {
        grid[x][y].death();
      }
      grid[x][y].display();
    }
  }
}

class Scorpion{
  int x;
  int y;
  int vitality;
  int tempVitality;
  boolean rabid;
  int kills;
  PImage img;
  
  Scorpion(int xPos, int yPos, int cellSize){
    x = xPos;
    y = yPos;
    rabid = false;
    vitality = MAX_HEALTH;
    img = loadImage("skarnerIcon.jpg");
    img.resize(cellSize, cellSize);
  }
  
  //display Skarner if alive, a rectangle if dead
  void display(){
    if(vitality > 0){
      if(rabid){
        tint(33, 0, 0);
      } else {
        noTint();
      }
      image(img, x*cellSize, y*cellSize);
    } else {
      rect(x*cellSize,y*cellSize,(x+1)*cellSize,(y+1)*cellSize);
    }
  }
  
  //returns the ArrayList of neighbors
  ArrayList<Scorpion> getNeighbors(){
    ArrayList<Scorpion> neighbors = new ArrayList<Scorpion>();
    
    for(int deltaX=-1; deltaX<=1; deltaX++){
      for(int deltaY=-1; deltaY<=1; deltaY++){
        //check to make sure a cell exists on the grid, if it does, see if the scorpion is alive
        if(((x+deltaX)>=0 && (x+deltaX)<cols) && ((y+deltaY)>=0 && (y+deltaY)<rows) && (grid[x+deltaX][y+deltaY].getVitality()>0)){
          //skip self
          if(!((deltaX==0) && (deltaY==0))){
            neighbors.add(grid[x+deltaX][y+deltaY]);
          }
        }
      }
    }
    return neighbors;
  }
  
  int getVitality(){
    return vitality;
  }
  
  void setXY(int newX, int newY){
    x = newX;
    y = newY;
  }
  
  void setTempVitality(int v){
    tempVitality = v;
  }
  
  void update(){
    vitality = tempVitality;
  }
  
  void death(){
    vitality = 0;
  }
  
  void birth(){
    vitality = MAX_HEALTH;
  }
  
  boolean isRabid(){
    return rabid;
  }
  
  void makeRabid(){
    rabid = true;
    vitality = MAX_HEALTH*3;
  }
  
  void kill(){
    kills++;
  }
  
  int getKills(){
    return kills;
  }
  
  void split(int x, int y){
    if(kills % 50 == 49){
      grid[x][y].makeRabid();
    }
  }
  
  //random walking functionality to be added  
  void walk(){
    int direction = int(random(9));
    if(direction == 0){
      if((y-1 >= 0) && (grid[x][y-1].getVitality() == 0)){
        grid[x][y-1].setTempVitality(this.getVitality()-1);
        grid[x][y].death();
        split(x,y);
        grid[x][y-1].setXY(x, y-1);
      } 
    } else if(direction == 1){
      if((y-1 >= 0) && (x+1 < cols) && (grid[x+1][y-1].getVitality() == 0)){
        grid[x+1][y-1].setTempVitality(this.getVitality()-1);
        grid[x][y].death();
        split(x,y);
        grid[x+1][y-1].setXY(x+1, y-1);
      } 
    } else if(direction == 2){
      if((x+1 < cols) && (grid[x+1][y].getVitality() == 0)){
        grid[x+1][y].setTempVitality(this.getVitality()-1);
        grid[x][y].death();
        split(x,y);
        grid[x+1][y].setXY(x+1, y);
      } 
    } else if(direction == 3){
      if((y+1 < rows) && (x+1 < cols) && (grid[x+1][y+1].getVitality() == 0)){
        grid[x+1][y+1].setTempVitality(this.getVitality()-1);
        grid[x][y].death();
        split(x,y);
        grid[x+1][y+1].setXY(x+1, y+1);
      } 
    } else if(direction == 4){
      if((y+1 < rows) && (grid[x][y+1].getVitality() == 0)){
        grid[x][y+1].setTempVitality(this.getVitality()-1);
        grid[x][y].death();
        split(x,y);
        grid[x][y+1].setXY(x, y+1);
      } 
    } else if(direction == 5){
      if((y+1 < rows) && (x-1 >= 0) && (grid[x-1][y+1].getVitality() == 0)){
        grid[x-1][y+1].setTempVitality(this.getVitality()-1);
        grid[x][y].death();
        split(x,y);
        grid[x-1][y+1].setXY(x-1, y+1);
      } 
    } else if(direction == 6){
      if((x-1 >= 0) && (grid[x-1][y].getVitality() == 0)){
        grid[x-1][y].setTempVitality(this.getVitality()-1);
        grid[x][y].death();
        split(x,y);
        grid[x-1][y].setXY(x-1, y);
      } 
    } else if(direction == 7){
      if((y-1 >= 0) && (x-1 >= 0) && (grid[x-1][y-1].getVitality() == 0)){
        grid[x-1][y-1].setTempVitality(this.getVitality()-1);
        grid[x][y].death();
        split(x,y);
        grid[x-1][y-1].setXY(x-1, y-1);
      }
    }
  }
}
