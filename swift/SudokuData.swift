//
//  SudokuData.swift
//  Sudoku Solver
//
//  Created by Louis Revor on 3/2/22.
//

import Foundation
import AppKit

class sudokuData {
    var data = [sudoku_node]()
    var verbose = false
    
    init() {
        for row in 1...GS {
            for col in 1...GS {
                let node = sudoku_node(row: row, col: col)
                data.insert(node, at: node.getIndex())
            }
        }
    }
    func setData(testCase: Int) {
        if ((testCase >= 0) && (testCase < numTestData)) {
            for node in data {
                setNumber(number: testdata[testCase][node.getIndex()], row: node.mRow, col: node.mCol)
            }
        }
    }


//****************************************************************************************
//***************************************************************************************
//*********** Solvers ***********
//****************************************************************************************
//****************************************************************************************

    // TODO: Determine if a block has a value in only one row/col, if so clear from other blocks in row/col
    // TODO: Determine if a value appears in 2 columns/rows in 2 aligned blocks, if so, clear it from the 3rd block for those rows/cols
    
}
