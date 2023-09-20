

#include "algorithm.h"

#include <unordered_map>
#include <vector>

using namespace std;

// General best-first search algorithm. Default evaluation function is:
//   f(n) = g(n) + 0 = cumulative_path_cost
string best_first_explist(string const initialState, string const goalState,
                          int &pathLength, int &numOfStateExpansions,
                          int &maxQLength, float &actualRunningTime,
                          heuristicFunction h = none) {
  actualRunningTime = 0.0;
  clock_t startTime = clock();

  Puzzle *current = new Puzzle(initialState, goalState, h);
  vector<Puzzle *> Q = {current};
  unordered_map<string, bool> expanded = {};
  auto cmp = [](Puzzle *a, Puzzle *b) { return a->getFCost() > b->getFCost(); };

  while (Q.size()) {
    std::pop_heap(Q.begin(), Q.end(), cmp);
    current = Q.back();
    Q.pop_back();

    if (current->goalMatch()) break;
    expanded[current->toString()] = true;
    numOfStateExpansions++;

    if (current->canMoveUp()) {
      Puzzle *u = current->moveUp();
      if (!expanded[u->toString()]) {
        u->updateHCost();
        Q.push_back(u);
        push_heap(Q.begin(), Q.end(), cmp);
      }
    }
    if (current->canMoveRight()) {
      Puzzle *r = current->moveRight();
      if (!expanded[r->toString()]) {
        r->updateHCost();
        Q.push_back(r);
        push_heap(Q.begin(), Q.end(), cmp);
      }
    }
    if (current->canMoveDown()) {
      Puzzle *d = current->moveDown();
      if (!expanded[d->toString()]) {
        d->updateHCost();
        Q.push_back(d);
        push_heap(Q.begin(), Q.end(), cmp);
      }
    }
    if (current->canMoveLeft()) {
      Puzzle *l = current->moveLeft();
      if (!expanded[l->toString()]) {
        l->updateHCost();
        Q.push_back(l);
        push_heap(Q.begin(), Q.end(), cmp);
      };
    }

    maxQLength = max((int)Q.size(), maxQLength);
  }

  actualRunningTime = ((float)(clock() - startTime) / CLOCKS_PER_SEC);
  return current->getPath();
}

string uc_explist(string const initialState, string const goalState,
                  int &pathLength, int &numOfStateExpansions, int &maxQLength,
                  float &actualRunningTime, int &numOfDeletionsFromMiddleOfHeap,
                  int &numOfLocalLoopsAvoided,
                  int &numOfAttemptedNodeReExpansions) {
  string path =
      best_first_explist(initialState, goalState, pathLength,
                         numOfStateExpansions, maxQLength, actualRunningTime);

  pathLength = path.size();
  return path;
}

string aStar_ExpandedList(string const initialState, string const goalState,
                          int &pathLength, int &numOfStateExpansions,
                          int &maxQLength, float &actualRunningTime,
                          int &numOfDeletionsFromMiddleOfHeap,
                          int &numOfLocalLoopsAvoided,
                          int &numOfAttemptedNodeReExpansions,
                          heuristicFunction heuristic) {
  string path = best_first_explist(initialState, goalState, pathLength,
                                   numOfStateExpansions, maxQLength,
                                   actualRunningTime, heuristic);
  pathLength = path.size();
  return path;
}
