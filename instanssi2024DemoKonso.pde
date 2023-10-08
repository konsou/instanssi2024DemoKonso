boolean[] grid;
final boolean ALIVE = true;
final boolean DEAD = false;
color RED = color(255, 0, 0);
color GREEN = color(0, 255, 0);
color BLUE = color(0, 0, 255);
color BLACK = color(0, 0, 0);
color ALIVE_COLOR = GREEN;
color DEAD_COLOR = BLACK;
int pixelSize;
//int gridSizeX = 10;
// int gridSizeY = 10;
int gridSizeX = 192;
int gridSizeY = 108;
int gridCellCount = gridSizeX * gridSizeY;


void setup() {
  //size(100, 100);
  size(1920, 1080);
  // Currently only supports "pixels" that have the same length and height
  pixelSize = width / gridSizeX;

  grid = initGrid(gridSizeX, gridSizeY);
  //println(grid);

  hint(ENABLE_STROKE_PURE);
  strokeWeight(pixelSize);
  strokeCap(ROUND);
  frameRate(60);
}

final int runtimeMs = 10000;
void draw() {

  if (millis() > runtimeMs){
    float avgFPS = float(frameCount) / float(millis()) * 1000.0;
    println("Frame Count: " + frameCount);
    println("millis():    " + millis());
    println("Ran for " + runtimeMs + " ms, avg FPS: " + avgFPS);
    exit();
  }
  background(BLACK);

  grid = processLife(grid);
  //println(grid);
  
  for (int i = 0; i < gridCellCount; i++) {
    int x = indexToX(i);
    int y = indexToY(i, x);
    //println("i: " + i + " x: " + x + " y: " + y);
    int topLeftX = x * pixelSize;
    int topLeftY = y * pixelSize;
    float cellCenterX = topLeftX + pixelSize / 2;
    float cellCenterY = topLeftY + pixelSize / 2;
    if (grid[i]) { 
      stroke(ALIVE_COLOR); 
      point(cellCenterX, cellCenterY);
      }
    }
  //exit();
}

boolean[] processLife(boolean[] grid){
  boolean[] newGrid = new boolean[gridCellCount];
  for (int i = 0; i < gridCellCount; i++) {
    int x = indexToX(i);
    int y = indexToY(i, x);
    //println("processLife: i: " + i + " x: " + x + " y: " + y + " state: " + grid[i]);
    int aliveN = aliveNeighbours(x, y, grid);
    boolean currentCell = grid[i];
    if (currentCell == DEAD && aliveN == 3){ newGrid[i] = ALIVE; }
    else if (currentCell == ALIVE && (aliveN == 2 || aliveN == 3)){ newGrid[i] = ALIVE; }
    else { newGrid[i] = DEAD; }
  }
  return newGrid;
}

int[] neighbourXOffsets = {
                           -1, 0, 1,
                           -1,    1,
                           -1, 0, 1,
                          };
int[] neighbourYOffsets = {
                           -1, -1, -1,
                            0,      0,
                            1,  1,  1,
                          };

int aliveNeighbours(int x, int y, boolean[] grid){
  int aliveNeighbours = 0;
  //println("aliveNeighbours: x: " + x + " y: " + y);
  for (int i = 0; i < 8; i++){
    int xOffset = neighbourXOffsets[i];
    int yOffset = neighbourYOffsets[i];
    int neighbourX = x + xOffset;
    int neighbourY = y + yOffset;
    //println(" neighbourX: " + neighbourX + " neighbourY: " + neighbourY);
    if (neighbourX < 0 || neighbourX >= gridSizeX){ continue; } // Values outside grid are considered dead
    if (neighbourY < 0 || neighbourY >= gridSizeY){ continue; } // Values outside grid are considered dead

    int neighbourIndex = xyToIndex(neighbourX, neighbourY);
    //println("neighbourIndex: " + neighbourIndex);
    boolean neighbour = grid[neighbourIndex];
    //println("neighbour state: " + neighbour);
    // try { neighbour = grid[neighbourIndex]; }
    // catch (ArrayIndexOutOfBoundsException e) { continue; }  // Values outside grid are considered dead
    if (neighbour != DEAD){ aliveNeighbours++; }
  }
  //println("Found " + aliveNeighbours + " neighbours");
  return aliveNeighbours;
}

boolean[] initGrid(int width, int height){
  grid = new boolean[width * height];

  for (int i = 0; i < gridCellCount; i++) {
    int randomNumber = int(random(2));
    if (randomNumber == 0) {
      grid[i] = DEAD;
    } else {
      grid[i] = ALIVE;
    }
  }
  return grid;
}

int xyToIndex(int x, int y){
  int retVal = x * gridSizeY + y;
  //println(x + ", " + y + ": " + retVal);
  return retVal;
}

int indexToX(int index){
  return int(index / gridSizeY);
}

int indexToY(int index, int x){
  return index - (x * gridSizeY);
}