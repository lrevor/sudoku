//
//  sudoku.h
//  sudoku
//
//  Created by Louis Revor on 11/20/20.
//

#ifndef sudoku_h
#define sudoku_h

typedef int bool;
#define true 1
#define false 0

typedef struct sudoku_node {
    int number;
    bool flag[9];
} sudoku_node_obj, sudoku_node_ptr;

void initialize(void);
void gridDump(void);
void flagDump(void);
int flagCount(void);
void dump(void);
bool valid(void);
void setNumber(int row, int col, int value);
bool getNumber(void);
void basicCheck(void); // If a value is determined, eliminate the flag from all other squares in same row, col, block
bool scanSolution(void); //Determine if a square only has one value
bool scanSoloBlock(void); //Determine if a block has only one square with a value
int rowColCheck(void); //Determine if a value only appears in one row/one col in a block and eliminate that value from the other blocks in the same row/col
int rowColSingleBlock(void); //
int pairScan(void); // For every pair of values, determine if there are exactly two cells that can have them.
int pairScanUnique(void); // HANDLES IF both values and only those 2 values are only in two squares.
#endif /* sudoku_h */
