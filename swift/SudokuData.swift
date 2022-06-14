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
    
    // Initializer.  create the nodes and populate them into the array based on where they are located on the grid
    init() {
        for row in 1...GS {
            for col in 1...GS {
                let node = sudoku_node(row: row, col: col)
                data.insert(node, at: node.getIndex())
            }
        }
    }
    // populate the grid based on a predefined test case
    func setData(testCase: Int) {
        if ((testCase >= 0) && (testCase < numTestData)) {
            for node in data {
                setNumber(number: testdata[testCase][node.getIndex()], row: node.mRow, col: node.mCol)
            }
        }
    }
}
