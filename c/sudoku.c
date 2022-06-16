//
//  sudoku.c
//  sudoku
//
//  Created by Louis Revor on 11/20/20.
//

#include <stdio.h>
#include "sudoku.h"

#define BS 3
#define GS (BS * BS)

bool autoMode;
sudoku_node_obj sudokuData[GS][GS];

int min(int a, int b) {
    if (a<b)
        return a;
    else
        return b;
}

void initialize(void) {
    int i, j, k;
/*
        int data[GS][GS] = {
            {9,6,0,0,4,0,0,0,0},
            {4,0,1,0,0,0,9,2,0},
            {8,0,0,0,0,0,0,0,1},
            {0,0,0,6,7,0,5,0,0},
            {5,0,0,0,0,1,0,0,4},
            {0,0,0,0,0,4,0,6,0},
            {0,2,0,0,0,7,8,0,0},
            {0,0,3,0,0,0,0,0,0},
            {1,0,4,0,9,0,0,0,3}
        };
*/
//
    int data[GS][GS] = {
        {0,0,0,0,3,0,8,1,0},
        {0,0,0,0,9,8,0,4,0},
        {0,6,0,0,0,1,0,3,7},
        {0,0,0,0,0,3,0,2,0},
        {3,0,0,0,0,9,0,0,0},
        {0,0,6,8,4,0,0,5,3},
        {9,0,0,0,8,0,2,0,1},
        {6,0,5,3,1,0,0,9,0},
        {7,0,1,9,0,4,3,0,5}
    };
//
/*
    int data[GS][GS] = {
        {1,0,0,5,0,0,8,3,0},
        {4,3,0,6,0,0,0,2,0},
        {0,0,0,0,0,7,0,0,0},
        {0,0,0,8,0,0,0,0,0},
        {0,2,0,0,0,3,9,5,6},
        {0,0,0,0,6,5,0,0,0},
        {7,0,0,0,0,8,5,0,0},
        {0,0,0,0,0,0,1,4,0},
        {3,0,4,7,1,0,0,8,0}
    };
*/
/* This is the easy one
    int data[GS][GS] = {
        {6,0,0,0,0,5,0,0,0},
        {0,3,0,0,0,0,8,0,7},
        {1,0,9,0,0,0,4,0,0},
        {0,7,0,0,0,1,0,0,3},
        {0,0,0,2,0,0,0,0,4},
        {0,0,1,0,0,3,0,9,6},
        {0,0,0,0,0,0,0,0,2},
        {4,6,0,9,0,0,5,0,0},
        {2,0,8,0,7,0,0,0,0}
    };
*/
    
    for (i=0; i<GS; i++) {
        for (j=0; j<GS; j++) {
            sudokuData[i][j].number = 0;
            for (k=0; k<GS; k++) {
                sudokuData[i][j].flag[k] = k+1;
            }
        }
    }
    for (i=0; i<GS; i++) {
        for (j=0; j<GS; j++) {
            if (data[i][j] !=0) setNumber(i+1,j+1,data[i][j]);
        }
    }

    basicCheck();
}

void gridDump(void) {
    int i, j;
    
    printf("-------------\n");
    for (i=0; i<GS; i++) {
        for (j=0; j<GS; j++) {
            if (j%BS == 0) printf("|");
            if (sudokuData[i][j].number) {
                printf("%d", sudokuData[i][j].number);
            } else {
                printf(" ");
            }
        }
        printf("|\n");
        if ((i%BS == 2) && (i!=8)) printf("|---|---|---|\n");
    }
    printf("-------------\n");
}

void flagDump(void) {
    int i, j, k;
    
    printf("-------------------------------------------\n");
    for (i=0; i<GS; i++) {
        printf("| ");
        for (j=0; j<GS; j++) {
            for (k=0; k<BS; k++) {
                if (sudokuData[i][j].flag[k]) {
                    printf("%d",sudokuData[i][j].flag[k]);
                } else {
                    printf(" ");
                }
            }
            printf(" ");
            if (j%BS == 2) printf("| ");
        }
        printf("\n| ");
        for (j=0; j<GS; j++) {
            for (k=0; k<BS; k++) {
                if (sudokuData[i][j].flag[BS+k]) {
                    printf("%d",sudokuData[i][j].flag[BS+k]);
                } else {
                    printf(" ");
                }
            }
            printf(" ");
            if (j%BS == 2) printf("| ");
        }
        printf("\n| ");
        for (j=0; j<GS; j++) {
            for (k=0; k<BS; k++) {
                if (sudokuData[i][j].flag[6+k]) {
                    printf("%d",sudokuData[i][j].flag[6+k]);
                } else {
                    printf(" ");
                }
            }
            printf(" ");
            if (j%BS == 2) printf("| ");
        }
        if (i%BS==2) {
            printf("\n-------------------------------------------\n");
        } else {
            printf("\n|             |             |             |\n");
        }
    }
}

//****************************************************************************************
//****************************************************************************************
//****************************************************************************************
//****************************************************************************************
//****************************************************************************************
//****************************************************************************************

bool solvedRowValue(int row, int value) {
    int col;
    for (col=0; col<GS; col++) {
        if (sudokuData[row][col].number == value) return true;
    }
    return false;
}
bool solvedColValue(int col, int value) {
    int row;
    for (row=0; row<GS; row++) {
        if (sudokuData[row][col].number == value) return true;
    }
    return false;
}
bool solvedBlockValue(int blockRow, int blockCol, int value) {
    int row, col;
    for (row=0; row<BS; row++) {
        for (col=0; col<BS; col++) {
            if (sudokuData[blockRow*BS+row][blockCol*BS+col].number == value) return true;
        }
    }
    return false;
}

// number of flags for a value in a row
int flagValueRowCount(int row, int value) {
    int k;
    int count=0;
    
    for (k=0; k<GS; k++) {
        if (sudokuData[row][k].flag[value-1]) count++;
    }
    return count;
}

// number of flags for a value in a row
int flagValueColCount(int col, int value) {
    int k;
    int count=0;
    
    for (k=0; k<GS; k++) {
        if (sudokuData[k][col].flag[value-1]) count++;
    }
    return count;
}

// number of solved cells in a row
int valueRowCount(int row) {
    int k;
    int count=0;
    
    for (k=0; k<GS; k++) {
        if (sudokuData[row][k].number) count++;
    }
    return count;
}

// number of solved cells in a column
int valueColCount(int col) {
    int k;
    int count=0;
    
    for (k=0; k<GS; k++) {
        if (sudokuData[k][col].number) count++;
    }
    return count;
}

//number of flags remaining for a given cell
int flagCellCount(int row, int col) {
    int k;
    int count=0;
    
    for (k=0; k<GS; k++) {
        if (sudokuData[row][col].flag[k]) count++;
    }
    return count;
}

// number of flags remaining in the grid
int flagCount(void) {
    int i,j;
    int count=0;
    for (i=0; i<GS; i++) {
        for (j=0; j<GS; j++) {
            count = count + flagCellCount(i,j);
        }
    }
    return count;
}

void dump(void) {
    gridDump();
    flagDump();
}

void setNumber(int row, int col, int value) {
    int i;
    
    printf("Setting: row %d, col %d, value %d\n", row, col, value);
    sudokuData[row-1][col-1].number = value;
    for (i=0; i<GS; i++) {
        if (i != (value-1) ) sudokuData[row-1][col-1].flag[i]=false;
    }
    if (!valid()) printf("GRID NO LONGER VALID!!!\n");
    basicCheck();
}

bool getNumber(void) {
    int row, col, value;
    
    printf("Row: ");
    if (!scanf("%d", &row)) return true;
    printf("\nCol: ");
    if (!scanf("%d", &col)) return true;
    printf("\nValue: ");
    if (!scanf("%d", &value)) return true;
    printf("\n");
    
    printf("row %d, col %d, value %d\n", row, col, value);
    
    setNumber(row, col, value);
    return false;
}

bool valid(void) {
    int row, col, blockRow, blockCol, value, count;
    bool valid=true;
    
    for (value=1; value <10; value ++) {
        for (row=0; row<GS; row++) {
            count=0;
            for (col=0; col<GS; col++) {
                if (sudokuData[row][col].number == value) count++;
            }
            if (count>1) valid=false;
        }
        for (col=0; col<GS; col++) {
            count=0;
            for (row=0; row<GS; row++) {
                if (sudokuData[row][col].number == value) count++;
            }
            if (count>1) valid=false;
        }
        for (blockRow=0; blockRow<BS; blockRow++) {
            for (blockCol=0; blockCol<BS; blockCol++) {
                count=0;
                for (row=0; row<BS; row++) {
                    for (col=0; col<BS; col++) {
                        if (sudokuData[blockRow*BS+row][blockCol*BS+col].number == value) count++;
                    }
                }
                if (count>1) valid=false;
            }
        }
    }
    return valid;
}

//****************************************************************************************
//****************************************************************************************
//****************************************************************************************
//****************************************************************************************
//****************************************************************************************
//****************************************************************************************
// If a value is determined, eliminate the flag from all other squares in same row, col, block
void basicCheck(void) {
    int i,j,k, row, col;
    
    for (i=0; i<GS; i++) {
        for (j=0; j<GS; j++) {
            if (sudokuData[i][j].number) {
                // Rows
                for (k=0; k<GS; k++) {
                    if (k!=i) sudokuData[k][j].flag[sudokuData[i][j].number-1] = false;
                }
                // cols
                for (k=0; k<GS; k++) {
                    if (k!=j) sudokuData[i][k].flag[sudokuData[i][j].number-1] = false;
                }
                // Same Block
                row = (i - (i%BS));
                col = (j - (j%BS));
                for (row=i-(i%BS); row<i-(i%BS)+BS; row++) {
                    for (col=j-(j%BS); col<j-(j%BS)+BS; col++) {
                        if ((row !=i) && (col!=j)) sudokuData[row][col].flag[sudokuData[i][j].number-1] = false;
                    }
                }
            }
        }
    }
}

//Determine if a square only has one value
bool scanSolution(void) {
    int i,j,k, value;
    bool found = false;

    for (i=0; i<GS; i++) {
        for (j=0; j<GS; j++) {
            if (!sudokuData[i][j].number && (flagCellCount(i,j) == 1)) {
                for (k=0; k<GS; k++) {
                    if (sudokuData[i][j].flag[k]) value = sudokuData[i][j].flag[k];
                }
                printf("[%d,%d]=%d - Only one possibility for square\n",i+1,j+1,value);
                if (autoMode) setNumber(i+1,j+1,value);
                found = true;
            }
        }
    }
    if (autoMode && found) scanSolution(); // If we found some and autoMode, recurse to find as many as possible.
    return found;
}

//Determine if a block has only one square with a value
bool scanSoloBlock(void) {
    int i,j,row,col,possibles,value, foundRow, foundCol;
    bool found = false;

    for (i=0; i<BS; i++) {
        for (j=0; j<BS; j++) {
            for (value=1; value<10; value++) {
                possibles=0;
                for (row=0; row<BS; row++) {
                    for (col=0; col<BS; col++) {
                        if (sudokuData[i*BS+row][j*BS+col].flag[value-1]) {
                            possibles++;
                            foundRow=i*BS+row;
                            foundCol=j*BS+col;
                        }
                    }
                }
                if ((possibles==1) && !solvedBlockValue(i,j,value)) {
                    printf("[%d,%d]=%d - Only square in block with value allowed\n",foundRow+1,foundCol+1,value);
                    if (autoMode) setNumber(foundRow+1,foundCol+1,value);
                    found = true;
                }
            }
        }
    }
    if (autoMode && found) scanSoloBlock(); // If we found some and autoMode, recurse to find as many as possible.
    return found;
}

//Determine if a value only appears in one row/col in a block and eliminate that value from the same row/col in the other blocks
//Determine if a block has the only flags for a value in a row/col and if so, eliminate the value from the other rows/cols in the block
int rowColCheck(void) {
    int blockRow,blockCol, row, col, value, rows, cols, foundRow, foundRow2, foundCol, foundCol2, countCells;
    int count = flagCount();
    for (value=1; value<10; value++) {
        for (blockRow=0; blockRow<BS; blockRow++) {
            for (blockCol=0; blockCol<BS; blockCol++) {
                if (!solvedBlockValue(blockRow, blockCol, value)) {
                    //Determine if a value only appears in one row (foundRow) in a block and eliminate that value from the same row in the other blocks
                    //Determine if a block has the only flags for a value in a row (foundRow2) and if so, eliminate the value from the other rows in the bloc
                    rows=0;
                    foundRow2=0;
                    for (row=0; row<BS; row++) {
                        countCells = min(1,sudokuData[blockRow*BS+row][blockCol*BS+0].flag[value-1]) +
                            min(1,sudokuData[blockRow*BS+row][blockCol*BS+1].flag[value-1]) +
                            min(1,sudokuData[blockRow*BS+row][blockCol*BS+2].flag[value-1]);
                        if (countCells) {
                            foundRow = blockRow*BS+row;
                            rows++;
                        }
                        if (flagValueRowCount(blockRow*BS+row,value) == countCells) {
                            foundRow2=row;
                        }
                    }
                    if (rows == 1) {
                        int mycount = flagCount();
                        for (col=0; col<GS; col++) {
                            if ((col/BS) != blockCol) sudokuData[foundRow][col].flag[value-1] = false;
                        }
                        if (mycount - flagCount()) printf("block [%d,%d] has value %d in only row %d, eliminating from other blocks\n", blockRow+1, blockCol+1, value, foundRow+1);
                    }
                    if (foundRow2) {
                        int mycount = flagCount();
                        for (row=0; row<BS; row++) {
                            if (row !=foundRow2) {
                                for (col=0; col<BS; col++) {
                                    sudokuData[blockRow*BS+row][blockCol*BS+col].flag[value-1]=0;
                                }
                            }
                        }
                        if (mycount - flagCount()) printf("block [%d,%d] is only block with with value %d in row %d, eliminating from other rows in block\n", blockRow+1, blockCol+1, value, blockRow*BS+foundRow2+1);
                    }
                    //Determine if a value only appears in one col in a block and eliminate that value from the same col in the other blocks
                    //Determine if a block has the only flags for a value in a col (foundCol2) and if so, eliminate the value from the other cols in the bloc
                    cols=0;
                    foundCol2=0;
                    for (col=0; col<BS; col++) {
                        countCells = min(1,sudokuData[blockRow*BS+0][blockCol*BS+col].flag[value-1]) +
                            min(1,sudokuData[blockRow*BS+1][blockCol*BS+col].flag[value-1]) +
                            min(1,sudokuData[blockRow*BS+2][blockCol*BS+col].flag[value-1]);
                        if (countCells) {
                            foundCol = blockCol*BS+col;
                            cols++;
                        }
                        if (flagValueColCount(blockCol*BS+col,value) == countCells) {
                            foundCol2=col;
                        }
                    }
                    if (cols == 1) {
                        int mycount = flagCount();
                        for (row=0; row<GS; row++) {
                            if ((row/BS) != blockRow) sudokuData[row][foundCol].flag[value-1] = false;
                        }
                        if (mycount - flagCount()) printf("block [%d,%d] has value %d in only col %d, eliminating from other blocks\n", blockRow+1, blockCol+1, value, foundCol+1);
                    }
                    if (foundCol2) {
                        int mycount = flagCount();
                        for (col=0; col<BS; col++) {
                            if (col !=foundCol2) {
                                for (row=0; row<BS; row++) {
                                    sudokuData[blockRow*BS+row][blockCol*BS+col].flag[value-1]=0;
                                }
                            }
                        }
                        if (mycount - flagCount()) printf("block [%d,%d] is only block with with value %d in col %d, eliminating from other cols in block\n", blockRow+1, blockCol+1, value, blockCol*BS+foundCol2+1);
                    }
                }
            }
        }
    }
    count = count - flagCount(); // Determine how many flags we eliminated
    if (autoMode && count) count = count + rowColCheck(); // If we eliminated flags and autoMode, recurse to find as many as possible.
    return count;
}

// For every pair of values, determine if there are exactly two cells that can have them.
int pairScan(void) { // HANDLES IF both values are onlyin two squares.
    int value1, value2, exactMatches, matches, row, col, blockRow, blockCol, i;
    int matchLoc[2][2];

    int count = flagCount();
    
    for (value1=1; value1<GS; value1++) {
        for (value2=value1+1; value2<10; value2++) {
            //check rows
            for (row=0; row<GS; row++) {
                matches=0;
                exactMatches=0;
                for (col=0; col<GS; col++) {
                    if ((sudokuData[row][col].flag[value1-1]) || (sudokuData[row][col].flag[value2-1])) matches++;
                    if ((sudokuData[row][col].flag[value1-1]) && (sudokuData[row][col].flag[value2-1])) {
                        if (exactMatches<2) {
                            matchLoc[exactMatches][0]=row;
                            matchLoc[exactMatches][1]=col;
                        }
                        exactMatches++;
                    }
                }
                if ((matches==2) && (exactMatches==2)) {
                    int mycount = flagCount();
                    //clear all the flags for the 2 exact matches
                    for (i=0; i<GS; i++) {
                        sudokuData[matchLoc[0][0]][matchLoc[0][1]].flag[i] = false;
                        sudokuData[matchLoc[1][0]][matchLoc[1][1]].flag[i] = false;
                    }
                    // now set the two value back for the 2 exact matches
                    sudokuData[matchLoc[0][0]][matchLoc[0][1]].flag[value1-1] = value1;
                    sudokuData[matchLoc[0][0]][matchLoc[0][1]].flag[value2-1] = value2;
                    sudokuData[matchLoc[1][0]][matchLoc[1][1]].flag[value1-1] = value1;
                    sudokuData[matchLoc[1][0]][matchLoc[1][1]].flag[value2-1] = value2;
                    if (mycount - flagCount()) printf("%d,%d match in exactly two cells [%d,%d] and [%d,%d] in same row, eliminating other flags\n", value1, value2, matchLoc[0][0]+1,matchLoc[0][1]+1,matchLoc[1][0]+1,matchLoc[1][1]+1);
                }
            }
            // check cols
            for (col=0; col<GS; col++) {
                matches=0;
                exactMatches=0;
                for (row=0; row<GS; row++) {
                    if ((sudokuData[row][col].flag[value1-1]) || (sudokuData[row][col].flag[value2-1])) matches++;
                    if ((sudokuData[row][col].flag[value1-1]) && (sudokuData[row][col].flag[value2-1])) {
                        if (exactMatches<2) {
                            matchLoc[exactMatches][0]=row;
                            matchLoc[exactMatches][1]=col;
                        }
                        exactMatches++;
                    }
                }
                if ((matches==2) && (exactMatches==2)) {
                    int mycount = flagCount();
                    //clear all the flags for the 2 exact matches
                    for (i=0; i<GS; i++) {
                        sudokuData[matchLoc[0][0]][matchLoc[0][1]].flag[i] = false;
                        sudokuData[matchLoc[1][0]][matchLoc[1][1]].flag[i] = false;
                    }
                    // now set the two value back for the 2 exact matches
                    sudokuData[matchLoc[0][0]][matchLoc[0][1]].flag[value1-1] = value1;
                    sudokuData[matchLoc[0][0]][matchLoc[0][1]].flag[value2-1] = value2;
                    sudokuData[matchLoc[1][0]][matchLoc[1][1]].flag[value1-1] = value1;
                    sudokuData[matchLoc[1][0]][matchLoc[1][1]].flag[value2-1] = value2;
                    if (mycount - flagCount()) printf("%d,%d match in exactly two cells [%d,%d] and [%d,%d] in same column, eliminating other flags\n", value1, value2, matchLoc[0][0]+1,matchLoc[0][1]+1,matchLoc[1][0]+1,matchLoc[1][1]+1);
                }
            }
            // check blocks
            for (blockRow=0; blockRow<BS; blockRow++) {
                for (blockCol=0; blockCol<BS; blockCol++) {
                    matches=0;
                    exactMatches=0;
                    for (row=0; row<BS; row++) {
                        for (col=0; col<BS; col++) {
                            if ((sudokuData[blockRow*BS+row][blockCol*BS+col].flag[value1-1]) || (sudokuData[blockRow*BS+row][blockCol*BS+col].flag[value2-1])) matches++;
                            if ((sudokuData[blockRow*BS+row][blockCol*BS+col].flag[value1-1]) && (sudokuData[blockRow*BS+row][blockCol*BS+col].flag[value2-1])) {
                                if (exactMatches<2) {
                                    matchLoc[exactMatches][0]=blockRow*BS+row;
                                    matchLoc[exactMatches][1]=blockCol*BS+col;
                                }
                                exactMatches++;
                            }
                        }
                    }
                    if ((matches==2) && (exactMatches==2)) {
                        int mycount = flagCount();
                        //clear all the flags for the 2 exact matches
                        for (i=0; i<GS; i++) {
                            sudokuData[matchLoc[0][0]][matchLoc[0][1]].flag[i] = false;
                            sudokuData[matchLoc[1][0]][matchLoc[1][1]].flag[i] = false;
                        }
                        // now set the two value back for the 2 exact matches
                        sudokuData[matchLoc[0][0]][matchLoc[0][1]].flag[value1-1] = value1;
                        sudokuData[matchLoc[0][0]][matchLoc[0][1]].flag[value2-1] = value2;
                        sudokuData[matchLoc[1][0]][matchLoc[1][1]].flag[value1-1] = value1;
                        sudokuData[matchLoc[1][0]][matchLoc[1][1]].flag[value2-1] = value2;
                        if (mycount - flagCount()) printf("%d,%d match in exactly two cells [%d,%d] and [%d,%d] in same block\n", value1, value2, matchLoc[0][0]+1,matchLoc[0][1]+1,matchLoc[1][0]+1,matchLoc[1][1]+1);
                    }
                }
            }
        }
    }
    count = count - flagCount(); // Determine how many flags we eliminated
    if (autoMode && count) count = count + pairScan(); // If we eliminated flags and autoMode, recurse to find as many as possible.
    return count;
}

// For every pair of values, determine if there are exactly two cells that can have them.
int pairScanUnique(void) { // HANDLES IF both values and only those 2 values are only in two squares.
    int value1, value2, exactMatches, row, col, blockRow, blockCol, i;
    int matchLoc[2][2];

    int count = flagCount();

    for (value1=1; value1<GS; value1++) {
        for (value2=value1+1; value2<10; value2++) {
            //check rows
            for (row=0; row<GS; row++) {
                exactMatches=0;
                for (col=0; col<GS; col++) {
                    if ((sudokuData[row][col].flag[value1-1]) && (sudokuData[row][col].flag[value2-1]) && (flagCellCount(row,col)==2)) {
                        if (exactMatches<2) {
                            matchLoc[exactMatches][0]=row;
                            matchLoc[exactMatches][1]=col;
                        }
                        exactMatches++;
                    }
                }
                if (exactMatches==2) {
                    int mycount = flagCount();
                    //clear all the flags for the 2 exact matches
                    for (i=0; i<GS; i++) {
                        sudokuData[matchLoc[0][0]][matchLoc[0][1]].flag[i] = false;
                        sudokuData[matchLoc[1][0]][matchLoc[1][1]].flag[i] = false;
                    }
                    // now set the two value back for the 2 exact matches
                    sudokuData[matchLoc[0][0]][matchLoc[0][1]].flag[value1-1] = value1;
                    sudokuData[matchLoc[0][0]][matchLoc[0][1]].flag[value2-1] = value2;
                    sudokuData[matchLoc[1][0]][matchLoc[1][1]].flag[value1-1] = value1;
                    sudokuData[matchLoc[1][0]][matchLoc[1][1]].flag[value2-1] = value2;
                    if (mycount - flagCount()) printf("%d,%d match exactly in two cells [%d,%d] and [%d,%d] in same row\n", value1, value2, matchLoc[0][0]+1,matchLoc[0][1]+1,matchLoc[1][0]+1,matchLoc[1][1]+1);
                }
            }
            // check cols
            for (col=0; col<GS; col++) {
                exactMatches=0;
                for (row=0; row<GS; row++) {
                    if ((sudokuData[row][col].flag[value1-1]) && (sudokuData[row][col].flag[value2-1]) && (flagCellCount(row,col)==2)) {
                        if (exactMatches<2) {
                            matchLoc[exactMatches][0]=row;
                            matchLoc[exactMatches][1]=col;
                        }
                        exactMatches++;
                    }
                }
                if (exactMatches==2) {
                    int mycount = flagCount();
                    //clear all the flags for the 2 exact matches
                    for (i=0; i<GS; i++) {
                        sudokuData[matchLoc[0][0]][matchLoc[0][1]].flag[i] = false;
                        sudokuData[matchLoc[1][0]][matchLoc[1][1]].flag[i] = false;
                    }
                    // now set the two value back for the 2 exact matches
                    sudokuData[matchLoc[0][0]][matchLoc[0][1]].flag[value1-1] = value1;
                    sudokuData[matchLoc[0][0]][matchLoc[0][1]].flag[value2-1] = value2;
                    sudokuData[matchLoc[1][0]][matchLoc[1][1]].flag[value1-1] = value1;
                    sudokuData[matchLoc[1][0]][matchLoc[1][1]].flag[value2-1] = value2;
                    if (mycount - flagCount()) printf("%d,%d match exactly in two cells [%d,%d] and [%d,%d] in same column\n", value1, value2, matchLoc[0][0]+1,matchLoc[0][1]+1,matchLoc[1][0]+1,matchLoc[1][1]+1);
                }
            }
            // check blocks
            for (blockRow=0; blockRow<BS; blockRow++) {
                for (blockCol=0; blockCol<BS; blockCol++) {
                    exactMatches=0;
                    for (row=0; row<BS; row++) {
                        for (col=0; col<BS; col++) {
                            if ((sudokuData[blockRow*BS+row][blockCol*BS+col].flag[value1-1]) && (sudokuData[blockRow*BS+row][blockCol*BS+col].flag[value2-1]) && (flagCellCount(blockRow*BS+row,blockCol*BS+col)==2)) {
                                if (exactMatches<2) {
                                    matchLoc[exactMatches][0]=blockRow*BS+row;
                                    matchLoc[exactMatches][1]=blockCol*BS+col;
                                }
                                exactMatches++;
                            }
                        }
                    }
                    if (exactMatches==2) {
                        int mycount = flagCount();
                        //clear all the flags for the 2 exact matches
                        for (i=0; i<GS; i++) {
                            sudokuData[matchLoc[0][0]][matchLoc[0][1]].flag[i] = false;
                            sudokuData[matchLoc[1][0]][matchLoc[1][1]].flag[i] = false;
                        }
                        // now set the two value back for the 2 exact matches
                        sudokuData[matchLoc[0][0]][matchLoc[0][1]].flag[value1-1] = value1;
                        sudokuData[matchLoc[0][0]][matchLoc[0][1]].flag[value2-1] = value2;
                        sudokuData[matchLoc[1][0]][matchLoc[1][1]].flag[value1-1] = value1;
                        sudokuData[matchLoc[1][0]][matchLoc[1][1]].flag[value2-1] = value2;
                        if (mycount - flagCount()) printf("%d,%d match exactly in two cells [%d,%d] and [%d,%d] in same block\n", value1, value2, matchLoc[0][0]+1,matchLoc[0][1]+1,matchLoc[1][0]+1,matchLoc[1][1]+1);
                    }
                }
            }
        }
    }
    count = count - flagCount(); // Determine how many flags we eliminated
    if (autoMode && count) count = count + pairScanUnique(); // If we eliminated flags and autoMode, recurse to find as many as possible.
    return count;
}

// Need to add separate routine for row is complete except square in single block, then exclude remain values from other cells in that block. for this valu&value&value tells you if a row in a block is complete.  Incomplete will yield 0 when anded.
int rowColSingleBlock() {
    int row, col, blockRow, blockCol, i,j,value;
    int count = flagCount();

    for (blockRow=0; blockRow<BS; blockRow++) {
        for (blockCol=0; blockCol<BS; blockCol++) {
            // Check rows
            for (row=0; row<BS; row++) {
                // If the empty values in this row are ONLY in this block
                if ((valueRowCount(blockRow*BS+row) + BS -
                     (min(1,sudokuData[blockRow*BS+row][blockCol*BS+0].number) +
                      min(1,sudokuData[blockRow*BS+row][blockCol*BS+1].number) +
                      min(1,sudokuData[blockRow*BS+row][blockCol*BS+2].number)
                      )
                     ) == GS) {
                    // Remove the remaining flags for each of the blocks from the rest of the square
                    for (value=1; value<10; value++) {
                        if ( sudokuData[blockRow*BS+row][blockCol*BS+0].flag[value-1] || sudokuData[blockRow*BS+row][blockCol*BS+1].flag[value-1] || sudokuData[blockRow*BS+row][blockCol*BS+2].flag[value-1] ) {
                            int mycount = flagCount();
                            for (i=0; i<BS; i++) {
                                for (j=0; j<BS; j++) {
                                    // clear all values NOT on the row we are working on
                                    if (i != row) {
                                        sudokuData[blockRow*BS+i][blockCol*BS+j].flag[value-1] = 0;
                                    }
                                }
                            }
                            if (mycount - flagCount()) printf("Block [%d,%d] has only values for row %d.  Clearing value %d from rest of block\n", blockRow, blockCol, blockRow*BS+row, value);
                        }
                    }
                }
            }
            // Check cols
            for (col=0; col<BS; col++) {
                // If the empty values in this row are ONLY in this block
                if ((valueColCount(blockCol*BS+col) + BS -
                     (min(1,sudokuData[blockRow*BS+0][blockCol*BS+col].number) +
                      min(1,sudokuData[blockRow*BS+1][blockCol*BS+col].number) +
                      min(1,sudokuData[blockRow*BS+2][blockCol*BS+col].number))) == GS) {
                    // Remove the remaining flags for each of the blocks from the rest of the square
                    for (value=1; value<10; value++) {
                        if ( sudokuData[blockRow*BS+0][blockCol*BS+col].flag[value-1] || sudokuData[blockRow*BS+1][blockCol*BS+col].flag[value-1] || sudokuData[blockRow*BS+2][blockCol*BS+col].flag[value-1] ) {
                            int mycount = flagCount();
                            for (i=0; i<BS; i++) {
                                for (j=0; j<BS; j++) {
                                    // clear all values NOT on the row we are working on
                                    if (j != col) {
                                        sudokuData[blockRow*BS+i][blockCol*BS+j].flag[value-1] = 0;
                                    }
                                }
                            }
                            if (mycount - flagCount()) printf("Block [%d,%d] has only values for col %d.  Clearing value %d from rest of block\n", blockRow, blockCol, blockCol*BS+col, value);
                        }
                    }
                }
            }
        }
    }
    
    count = count - flagCount(); // Determine how many flags we eliminated
    if (autoMode && count) count = count + rowColSingleBlock(); // If we eliminated flags and autoMode, recurse to find as many as possible.
    return count;
}

// If two blocks in the same row/col BOTH cant have a value in a row/col, then clearly the third has to have it in that row/col so clear it from the thirds other two rows/cols
