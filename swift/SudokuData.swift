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
    
    init() {
        for row in 1...GS {
            for col in 1...GS {
                let node = sudoku_node(row: row, col: col)
                data.insert(node, at: node.getIndex())
            }
        }
        for node in data {
            setNumber(number: testdata[1][node.getIndex()], row: node.mRow, col: node.mCol)
        }
    }
    func getNode(row: Int, col: Int) -> sudoku_node {
        return data[getIndex(row: row, col: col)]
    }
    func getIndex(row: Int, col: Int) -> Int {
        return col-1+GS*(row-1)
    }
    func setNumber(number: Int, row: Int, col: Int) {
        for node in data {
            if node.sameNode(row: row, col: col) {
                // If this is the node, set the number
                if number != 0 { node.setNumber(number: number) }
            } else {
                // Clear the flag if same row, col or block
                if node.sameRow(row: row) { node.clearFlag(number: number) }
                if node.sameCol(col: col) { node.clearFlag(number: number) }
                if node.sameBlock(blockRow: getNode(row: row, col: col).mBlockRow, blockCol: getNode(row: row, col: col).mBlockCol) {
                    node.clearFlag(number: number)
                }
            }
        }
    }
    func getRowFlagMatchCount(row: Int, flag: Int) -> Int {
        var count = 0
        for node in data {
            if (node.mRow == row) && ((node.mFlag & flag) == flag) {
                count = count + 1
            }
        }
        return count
    }
    func getColFlagMatchCount(col: Int, flag: Int) -> Int {
        var count = 0
        for node in data {
            if (node.mCol == col) && ((node.mFlag & flag) == flag) {
                count = count + 1
            }
        }
        return count
    }
    func getRowFlagUniqueBlockMatch(row: Int, number: Int) -> Int {
        var count = 0
        var match = 0
        let flag = flagMask(number: number)
        for node in data {
            if (node.mRow == row) && ((node.mFlag & flag) == flag) && (node.mNumber == 0) {
                if node.mBlock != match {
                    count = count + 1
                    match = node.mBlock
                }
            }
        }
        if count == 1 {
            return match
        } else {
            return 0
        }
    }
    func getColFlagUniqueBlockMatch(col: Int, number: Int) -> Int {
        var count = 0
        var match = 0
        let flag = flagMask(number: number)
        for node in data {
            if (node.mCol == col) && ((node.mFlag & flag) == flag) && (node.mNumber == 0) {
                if node.mBlock != match {
                    count = count + 1
                    match = node.mBlock
                }
            }
        }
        if count == 1 {
            return match
        } else {
            return 0
        }
    }
    func getBlockFlagMatchCount(block: Int, flag: Int) -> Int {
        var count = 0
        for node in data {
            if (node.mBlock == block) && ((node.mFlag & flag) == flag) {
                count = count + 1
            }
        }
        return count
    }
    func setRowFlagMatch(row: Int, flag: Int) -> Int {
        var clearedFlags = 0
        for node in data {
            if (node.mRow == row) && ((node.mFlag & flag)>0) {
                clearedFlags = clearedFlags | (node.mFlag - flag)
                node.mFlag = flag
            }
        }
        return clearedFlags
    }
    func setColFlagMatch(col: Int, flag: Int) -> Int {
        var clearedFlags = 0
        for node in data {
            if (node.mCol == col) && ((node.mFlag & flag)>0) {
                clearedFlags = clearedFlags | (node.mFlag - flag)
                node.mFlag = flag
            }
        }
        return clearedFlags
    }
    func clearRowBlockFlagMatch(row: Int, block: Int, number: Int) -> Bool {
        var found = false
        let flag = flagMask(number: number)
        for node in data {
            if (node.mRow == row) && (node.mBlock == block) && ((node.mFlag & flag)>0) {
                node.mFlag = node.mFlag - flag
                found = true
            }
        }
        return found
    }
    func clearColBlockFlagMatch(col: Int, block: Int, number: Int) -> Bool {
        var found = false
        let flag = flagMask(number: number)
        for node in data {
            if (node.mCol == col) && (node.mBlock == block) && ((node.mFlag & flag)>0) {
                node.mFlag = node.mFlag - flag
                found = true
            }
        }
        return found
    }
    func setBlockFlagMatch(block: Int, flag: Int) -> Int {
        var clearedFlags = 0
        for node in data {
            if (node.mBlock == block) && ((node.mFlag & flag)>0) {
                clearedFlags = clearedFlags | (node.mFlag - flag)
                node.mFlag = flag
            }
        }
        return clearedFlags
    }

//****************************************************************************************
//***************************************************************************************
//*********** Solvers ***********
//****************************************************************************************
//****************************************************************************************

    // TODO: Determine if a block has a value in only one row/col, if so clear from other blocks in row/col
    // TODO: Determine if a value appears in 2 columns/rows in 2 aligned blocks, if so, clear it from the 3rd block for those rows/cols
    
}
