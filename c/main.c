//
//  main.c
//  sudoku
//
//  Created by Louis Revor on 11/20/20.
//

#include <stdio.h>
#include "sudoku.h"

extern bool autoMode;

bool getOption(void) {
    int row, col, value, count;
    bool quit = false;
    char c[80];
    
    printf("[e]nter value, [f]lag print, [s]ingle option cell, [o]ne option in block, [r]ow/col check, [p]air check, [a]uto mode, sol[v]e, [q]uit\n");
    printf("Select Option: ");
    while (scanf("%s", c)) {
        switch (c[0]) {
            case 'e':
                printf("Row: ");
                if (!scanf("%d", &row)) return true;
                printf("Col: ");
                if (!scanf("%d", &col)) return true;
                printf("Value: ");
                if (!scanf("%d", &value)) return true;
                setNumber(row, col, value);
                break;
            case 'g':
                gridDump();
                break;
            case 'f':
                flagDump();
                break;
            case 's': //Determine if a square only has one value
                scanSolution();
                break;
            case 'o': //Determine if a block has only one square with a value
                scanSoloBlock();
                break;
            case 'r': //Determine if a value only appears in one row/one col in a block and eliminate that value from the other blocks in the same row/col
                rowColCheck();
                rowColSingleBlock();
                break;
            case 'p': // For every pair of values, determine if there are exactly two cells that can have them.
                pairScanUnique();
                pairScan();
                break;
            case 'a': //quit
                autoMode = true;
                break;
            case 'v': //quit
                autoMode = true;
                quit = false;
                if (!autoMode) printf("Turning on Auto Mode!\n");
                while (!quit) {
                    count = flagCount();
                    scanSolution();
                    scanSoloBlock();
                    rowColCheck();
                    rowColSingleBlock();
                    pairScanUnique();
                    pairScan();
                    if (!(count - flagCount())) {
                        quit=true;
                        printf("I've done all I can do!\n");
                        flagDump();
                    }
                }
                break;
            case 'q': //quit
                return false;
                break;
            case '\n':
                continue;
        }
        gridDump();
        if (!valid()) printf("GRID NO LONGER VALID!!!\n");
        if (autoMode) printf("Auto Mode Enabled!\n");
        printf("[e]nter value, [f]lag print, [s]ingle option cell, [o]ne option in block, [r]ow/col check, [p]air check, [a]uto mode, sol[v]e, [q]uit\n");
        printf("Select Option: ");
    }

    return false;
}

int main(int argc, const char * argv[]) {
    // insert code here...
    autoMode = false;
    printf("Hello, Soduko!\n");
    initialize();
    gridDump();
    getOption();
    return 0;
}
