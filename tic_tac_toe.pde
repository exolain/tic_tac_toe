//Integrante: Natalia Marin Perez.

Cell[][] board;
int cols = 3;
int rows = 3;
import java.util.List;
int bestValue=0;
int player = 0; //0 = player1
int win = 0;  // 1 = player1   2 = player2;
int game = 0;  // 1 = game started
int full = 9;
boolean gameOver = false;
//int[] winningPatterns={
//         0b111000000, 0b000111000, 0b000000111, // rows
//         0b100100100, 0b010010010, 0b001001001, // cols
//         0b100010001, 0b001010100               // diagonals
//   };  
void setup() {
  size(400, 400);
  smooth(); 
  board = new Cell[cols][rows];
  for (int i = 0; i< cols; i++) {
    for ( int j = 0; j < rows; j++) {
      board[i][j] = new Cell(width/3*i, height/3*j, width/3, height/3);
    }
  }
}


public List<int []> GetEmptyCells()
 {
          List <int []> moves = new ArrayList<int []>();
          int[] move = new int[2];
            for (int i = 0; i< cols; i++) {
                for ( int j = 0; j < rows; j++) {
                   if (board[i][j].checkState() == 0)
                  {
                      move[0] = i;
                      move[1] = j;
                      moves.add(move);
                   }
               }
           }
           
           return moves;
 }


int[] minimax(int depth, int player, int alpha, int betha){ //alpha, betha?

int bestrow=-1;
int bestcol=-1;
int score;
   int result []= new int[3]; 
 if(depth == 0 && !gameOver){
       
       score=evaluate();
       return new int[] {score, bestrow, bestcol};
 }
 else{
   List<int[]> moves=GetEmptyCells(); // how to get the cells not played yet
   for(int[] move : moves)
   {
     
     if((board[move[0]][move[1]]).checkPlayer() == player){//maximizes player(computer)
          score = minimax(depth - 1, 1, alpha, betha )[0];
          alpha=score;
          bestrow=move[0];
          bestcol=move[1];
          //bestValue = max(bestValue,score);
          
     }
     else{
     if((board[move[0]][move[1]]).checkPlayer() == player){//minimizes player (user)
         score = minimax(depth - 1, 2, alpha, betha)[0];
           
          //bestValue = min(bestValue,score);
          betha=score;
           bestrow=move[0];
           bestcol=move[1];
     }
     }
   }
   
   result[0]= bestrow;
   result[1]= bestcol;
   if (player == 2){
       
       result[2]=alpha;
       
   }
   else{
   
      result[2]=betha;
   }
   
   return result;
 }
     
   
 
}

 
void draw() {
  background(0);
  // intro
  //if (game == 0) {
  //  fill(255);
  //  textSize(20);
  //  text("Press ENTER to Start", width/2-width/4, height/2);
  //}
 
  //game start!
  game=1;
  //if (game == 1) {
    checkGame();  // check if  player win
    for (int i = 0; i<cols; i++) {
      for (int j = 0; j<rows; j++) {
        board[i][j].display();
      }
    }
  }
//}

//mouse & key functions
void mousePressed() {
  if (game == 1) {
    if (win == 0 ) {
      for (int i = 0; i<cols; i++) {
        for (int j = 0; j<rows; j++) {
          if(board[i][j].checkPlayer() == 0)
               {
                 board[i][j].click(mouseX, mouseY);
               }
             //  board[i][j].setState(0);
             //  player=2;
             
               
        }
      }
    }
  }
}
 
//void keyPressed() {
//  if (game == 0) {
//    if ( key == ENTER) {
//      game =1; //let's play
//      full = 9;
//    }
//  }
//  else if (game == 1 && win == 0 && full == 0 ) {
//    if ( key == ENTER) {
//      game = 0; // start again
//      for (int i = 0; i<cols; i++) {
//        for (int j = 0; j<rows; j++) {
//          board[i][j].clean();
//          win = 0;
//          full = 9;
//        }
//      }
//    }
//  }
//  else if ( game == 1 && (win == 1 || win ==2)) {
//    if ( key == ENTER) {
//      game = 0; // start again
//      for (int i = 0; i<cols; i++) {
//        for (int j = 0; j<rows; j++) {
//          board[i][j].clean();
//          win = 0;
//          full = 9;
//        }
//      }
//    }
//  }
//}


  int evaluate() {
      int score = 0;
      // Evaluate score for each of the 8 lines (3 rows, 3 columns, 2 diagonals)
      score += evaluateLine(0, 0, 0, 1, 0, 2);  // row 0
      score += evaluateLine(1, 0, 1, 1, 1, 2);  // row 1
      score += evaluateLine(2, 0, 2, 1, 2, 2);  // row 2
      score += evaluateLine(0, 0, 1, 0, 2, 0);  // col 0
      score += evaluateLine(0, 1, 1, 1, 2, 1);  // col 1
      score += evaluateLine(0, 2, 1, 2, 2, 2);  // col 2
      score += evaluateLine(0, 0, 1, 1, 2, 2);  // diagonal
      score += evaluateLine(0, 2, 1, 1, 2, 0);  // alternate diagonal
      return score;
   }
 
   /** The heuristic evaluation function for the given line of 3 cells
       @Return +100, +10, +1 for 3-, 2-, 1-in-a-line for computer.
               -100, -10, -1 for 3-, 2-, 1-in-a-line for opponent.
               0 otherwise */
   private int evaluateLine(int row1, int col1, int row2, int col2, int row3, int col3) {
      int score = 0;
 
      // First cell
      if (board[row1][col1].checkPlayer() == 1) {
         score = 1;
      } else if (board[row1][col1].checkPlayer() == 0) {
         score = -1;
      }
 
      // Second cell
      if (board[row2][col2].checkPlayer() == 0) {
         if (score == 1) {   // cell1 is computer
            score = 10;
         } else if (score == -1) {  // cell1 is  player
            return 0;
         } else {  // cell1 is empty
            score = 1;
         }
      } else if (board[row2][col2].checkPlayer() == 0) {
         if (score == -1) { // cell1 is player
            score = -10;
         } else if (score == 1) { // cell1 is computer
            return 0;
         } else {  // cell1 is empty
            score = -1;
         }
      }
 
      // Third cell
      if (board[row3][col3].checkPlayer() == 1) {
         if (score > 0) {  // cell1 and/or cell2 is computer
            score *= 10;
         } else if (score < 0) {  // cell1 and/or cell2 is player
            return 0;
         } else {  // cell1 and cell2 are empty
            score = 1;
         }
      } else if (board[row3][col3].checkPlayer() == 0) {
         if (score < 0) {  // cell1 and/or cell2 is player
            score *= 10;
         } else if (score > 1) {  // cell1 and/or cell2 is computer
            return 0;
         } else {  // cell1 and cell2 are empty
            score = -1;
         }
      }
      return score;
   }


void checkGame() {
  int row = 0;
  //check vertical & horizontal
  for (int col = 0; col< cols; col++) {
    if (board[col][row].checkState() == 1 && board[col][row+1].checkState() == 1 && board[col][row+2].checkState() == 1) {
      //println("vertical 0 win!");
      win = 1;
      gameOver = true;
    }
    else if (board[row][col].checkState() == 1 && board[row+1][col].checkState() == 1 && board[row+2][col].checkState() == 1) {
      //println("Horizontal 0 win!");
      win = 1;
      gameOver = true;
    }
    else if (board[row][col].checkState() == 2 && board[row+1][col].checkState() == 2 && board[row+2][col].checkState() == 2) {
      //println("Horizontal X win!");
      win = 2;
      gameOver = true;
    }
    else if (board[col][row].checkState() == 2 && board[col][row+1].checkState() == 2 && board[col][row+2].checkState() == 2) {
      //println("vertical X win!");
      win = 2;
      gameOver = true;
    }
  }
 
  //check diagonals
  if (board[row][row].checkState() == 1 && board[row+1][row+1].checkState() == 1 && board[row+2][row+2].checkState() == 1) {
    //print(" diagonal 0 O win! ");
    win = 1;
    gameOver = true;
  }
  else if (board[row][row].checkState() == 2 && board[row+1][row+1].checkState() == 2 && board[row+2][row+2].checkState() == 2) {
    //println("diagonal 0 x win!");
    win = 2;
    gameOver = true;
  }
  else if (board[0][row+2].checkState() == 1 && board[1][row+1].checkState() == 1 && board[2][row].checkState() == 1) {
    //println("diagonal 1 O win!");
    win = 1;
    gameOver = true;
  }
  else if (board[0][row+2].checkState() == 2 && board[1][row+1].checkState() == 2 && board[2][row].checkState() == 2) {
    //println("diagonal 1 X win!");
    win = 2;
    gameOver = true;
  }
 
 
  //write text
  fill(255);
  textSize(20);
  for (int i = 0; i<cols; i++) {
    for (int j = 0; j<rows; j++) {
      if ( win == 1) {
        text("Player 1 \n WINS!", board[i][j].checkX()+40, board[i][j].checkY()+50);
      }
      else if ( win == 2) {
        text("Player 2 \n WINS!", board[i][j].checkX()+40, board[i][j].checkY()+50);
      }
    }
  }
 
 
  //if (win == 1 || win == 2) {
  //  fill(0, 255, 0);
  //  textSize(35);
  //  text("ENTER to Start Again", width/2-width/2+23, height/2-height/6-20);
  //}
 
  //if ( win == 0 && full == 0) {  // no win ;(
  //  fill(0, 255, 0);
  //  textSize(35);
  //    text("ENTER to Start Again", width/2-width/2+23, height/2-height/6-20);
  //}
}
 
 
 
 
 
//CELL CLASS
 
class Cell {
  int x;
  int y ;
  int w;
  int h;
  int state = 0;
 
  Cell(int tx, int ty, int tw, int th) {
    x = tx;
    y = ty;
    w = tw;
    h = th;
  } 
 
  void click(int tx, int ty) {
    int mx = tx;
    int my = ty;
    if (mx > x && mx < x+w && my > y && my < y+h) {
 
      if (player == 0 && state == 0) {
        state = 1;
        full -= 1;
        player = 1;
      }
      else if (player == 1 && state == 0) {
        state = 2;
        full -= 1;
        player = 0;
      }
    }
  }
   
  void clean(){
    state = 0; 
  }
   
  int checkState(){
    return state; 
  }

  void setState(int state){
     this.state=state;
  }
  int checkPlayer(){
    return player;
  }
   
  int checkX(){
    return x; 
  }
   
  int checkY(){
    return y; 
  }
 
  void display() {
    noFill();
    stroke(255);
    strokeWeight(3);
    rect(x, y, w, h);
    if (state == 1) {
      ellipseMode(CORNER);
      stroke(0, 0, 255);
      ellipse(x, y, w, h);
    }
    else if ( state == 2) {
      int alpha = Integer.MAX_VALUE;
      int betha=Integer.MIN_VALUE;
      int result []= minimax(8,1, alpha, betha);
      stroke(255, 0, 0);
      //line(x, y, x+w, y+h);
     // line(x+w, y, x, y+h);
     int xx= board[result[0]][result[1]].checkX();
     int yy= board[result[0]][result[1]].checkY();
     System.out.print(xx);
      line(xx, yy, xx+w, yy+h);
      line(xx+w, yy, xx, yy+h);
     
      //function evaluate computer
    }
  }
}
