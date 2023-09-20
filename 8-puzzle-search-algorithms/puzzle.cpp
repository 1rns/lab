#include "puzzle.h"

#include <assert.h>

#include <array>
#include <unordered_map>

using namespace std;

// A mapping of numbers and their x,y positions on the board.
unordered_map<int, array<int, 2>> Puzzle::goalPositions;

Puzzle::Puzzle(const Puzzle &p) : path(p.path) {
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      board[i][j] = p.board[i][j];
      goalBoard[i][j] = p.goalBoard[i][j];
    }
  }

  x0 = p.x0;
  y0 = p.y0;
  pathLength = p.pathLength;
  hCost = p.hCost;
  heuristic = p.heuristic;
  depth = p.depth;
}

// Inputs:  (initial state, goal state)
Puzzle::Puzzle(string const elements, string const goal, heuristicFunction h) {
  int n = 0;
  int goalVal;
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      board[i][j] = elements[n] - '0';
      goalVal = goal[n] - '0';
      goalBoard[i][j] = goalVal;
      goalPositions[goalVal] = {i, j};
      if (board[i][j] == 0) {
        x0 = j;
        y0 = i;
      }
      n++;
    }
  }

  path = "";
  path.reserve(100);
  pathLength = 0;
  depth = 0;
  heuristic = h;
}

void Puzzle::setDepth(int d) { depth = d; }
int Puzzle::getDepth() { return depth; }
int Puzzle::getFCost() { return getHCost() + getGCost(); }
int Puzzle::getHCost() { return hCost; }
int Puzzle::getGCost() { return pathLength; }

void Puzzle::updateHCost() {
  hCost = 0;

  switch (heuristic) {
    case none:
      break;
    case misplacedTiles:
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (board[i][j] != goalBoard[i][j] && board[i][j] != 0) {
            hCost++;
          }
        }
      }
      break;

    case manhattanDistance:
      array<int, 2> pos;
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (board[i][j] != goalBoard[i][j] && board[i][j] != 0) {
            pos = goalPositions[board[i][j]];
            hCost += abs(i - pos[0]) + abs(j - pos[1]);
          }
        }
      }
      break;
  };
}

// Converts board state into its string representation.
string Puzzle::toString() {
  if (!strBoard.empty()) return strBoard;

  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      strBoard += (board[i][j] + '0');
    }
  }

  return strBoard;
}

bool Puzzle::goalMatch() {
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (goalBoard[i][j] != board[i][j]) {
        return false;
      }
    }
  }
  return true;
}

const string Puzzle::getPath() { return path; }
int Puzzle::getPathLength() { return pathLength; }

bool Puzzle::canMoveUp() { return y0 > 0; }
bool Puzzle::canMoveDown() { return y0 < 2; }
bool Puzzle::canMoveLeft() { return x0 > 0; }
bool Puzzle::canMoveRight() { return x0 < 2; }

Puzzle *Puzzle::moveLeft() {
  Puzzle *p = new Puzzle(*this);

  if (x0 > 0) {
    p->board[y0][x0] = p->board[y0][x0 - 1];
    p->board[y0][x0 - 1] = 0;

    p->x0--;

    p->path = path + "L";
    p->pathLength = pathLength + 1;
    p->depth = depth + 1;
  }

  return p;
}

Puzzle *Puzzle::moveRight() {
  Puzzle *p = new Puzzle(*this);

  if (x0 < 2) {
    p->board[y0][x0] = p->board[y0][x0 + 1];
    p->board[y0][x0 + 1] = 0;

    p->x0++;

    p->path = path + "R";
    p->pathLength = pathLength + 1;
  }

  return p;
}

Puzzle *Puzzle::moveUp() {
  Puzzle *p = new Puzzle(*this);

  if (y0 > 0) {
    p->board[y0][x0] = p->board[y0 - 1][x0];
    p->board[y0 - 1][x0] = 0;

    p->y0--;

    p->path = path + "U";
    p->pathLength = pathLength + 1;
  }
  return p;
}

Puzzle *Puzzle::moveDown() {
  Puzzle *p = new Puzzle(*this);

  if (y0 < 2) {
    p->board[y0][x0] = p->board[y0 + 1][x0];
    p->board[y0 + 1][x0] = 0;

    p->y0++;

    p->path = path + "D";
    p->pathLength = pathLength + 1;
  }
  return p;
}

void Puzzle::printBoard() {
  cout << "board: " << endl;
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      cout << endl << "board[" << i << "][" << j << "] = " << board[i][j];
    }
  }
  cout << endl;
}