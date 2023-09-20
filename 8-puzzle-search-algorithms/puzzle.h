#include <array>
#include <iostream>
#include <string>
#include <unordered_map>

using namespace std;

enum heuristicFunction { misplacedTiles, manhattanDistance, none };

class Puzzle {
 private:
  string path;
  string strBoard;
  int pathLength;
  int hCost;
  int fCost;
  int depth;

  int goalBoard[3][3];

  int x0, y0;  // coordinates of the blank/0-tile

  int board[3][3];

  heuristicFunction heuristic;

 public:
  Puzzle(const Puzzle &p);
  Puzzle(string const elements, string const goal, heuristicFunction h = none);
  static unordered_map<int, array<int, 2>> goalPositions;

  void printBoard();

  void updateHCost();
  void updateDepth() { depth++; }

  bool goalMatch();
  string toString();

  bool canMoveLeft();
  bool canMoveRight();
  bool canMoveUp();
  bool canMoveDown();

  Puzzle *moveUp();
  Puzzle *moveRight();
  Puzzle *moveDown();
  Puzzle *moveLeft();

  const string getPath();

  void setDepth(int d);
  int getDepth();

  int getPathLength();
  int getFCost();
  int getHCost();
  int getGCost();
};
