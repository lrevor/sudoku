//
//  SudokuNode.swift
//  Sudoku Solver
//
//  Created by Louis Revor on 3/5/22.
//

import Foundation

let BS=3
let GS=BS*BS

func flagMask(number: Int) -> Int {
    return 1<<(number-1)
}

class sudoku_node {
    var mNumber = 0
    var mRow = 0
    var mCol = 0
    var mBlock = 0
    var mBlockRow = 0
    var mBlockCol = 0
    var mFirstRowForBlock = 0
    var mLastRowForBlock = 0
    var mFirstColForBlock = 0
    var mLastColForBlock = 0
    var mFlag = 0b111111111
    
    init(row: Int, col: Int) {
        mRow = row
        mCol = col
        mBlockRow = ((mRow-1) / BS)+1
        mBlockCol = ((mCol-1) / BS)+1
        mBlock = (mBlockRow-1)*BS + mBlockCol
        //mFirstRowForBlock = row - ((row-1)%BS)
        //mLastRowForBlock = mFirstRowForBlock + BS - 1
        //mFirstColForBlock = col - ((col-1)%BS)
        //mLastColForBlock = mFirstColForBlock + BS - 1
        mFlag = 0b111111111
    }
    func setNumber(number: Int) {
        // Set the number and clear the flags except the one we want
        mNumber = number
        //mFlag = 1<<(number-1)
        mFlag = flagMask(number: number)
    }
    func clearFlag(number: Int) {
        mFlag = mFlag & (0b111111111 ^ (flagMask(number: number)))
    }
    func setFlag(number: Int) {
        mFlag = mFlag | (flagMask(number: number))
    }
    func getFlag(number: Int) -> Bool {
        let flag = 1<<(number-1)
        if (flag & mFlag) > 0 {
            return true
        } else {
            return false
        }
    }
    func flagCount() -> Int {
        var count = 0
        for i in 1...9 {
            if getFlag(number: i) { count = count+1 }
        }
        return count
    }
    func getIndex() -> Int {
        return mCol-1+GS*(mRow-1)
    }
    func sameNode(row: Int, col: Int) -> Bool {
        if (mRow == row) && (mCol == col) {
            return true
        } else {
            return false
        }
    }
    func sameRow(row: Int) -> Bool {
        if mRow == row {
            return true
        } else {
            return false
        }
    }
    func sameCol(col: Int) -> Bool {
        if mCol == col {
            return true
        } else {
            return false
        }
    }
    func sameBlock(blockRow: Int, blockCol: Int) -> Bool {
        if (mBlockRow == blockRow) && (mBlockCol == blockCol) {
            return true
        } else {
            return false
        }
    }
    func sameNode(node: sudoku_node) -> Bool { //Add same row, col, node, Block, blockrow, blockCol functions where node is passed in as input
        if (mRow == node.mRow) && (mCol == node.mCol) {
            return true
        } else {
            return false
        }
    }
    func sameBlock(node: sudoku_node) -> Bool {
        if (mBlockRow == node.mBlockRow) && (mBlockCol == node.mBlockCol) {
            return true
        } else {
            return false
        }
    }
    func sameRow(node: sudoku_node) -> Bool {
        if mRow == node.mRow {
            return true
        } else {
            return false
        }
    }
    func sameCol(node: sudoku_node) -> Bool {
        if mCol == node.mCol {
            return true
        } else {
            return false
        }
    }
    func sameBlockRow(node: sudoku_node) -> Bool {
        if mBlockRow == node.mBlockRow {
            return true
        } else {
            return false
        }
    }
    func sameBlockCol(node: sudoku_node) -> Bool {
        if mBlockCol == node.mBlockCol {
            return true
        } else {
            return false
        }
    }
}
