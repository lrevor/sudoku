//
//  SudokuNode.swift
//  Sudoku Solver
//
//  Created by Louis Revor on 3/5/22.
//

import Foundation

public let BS=3
public let GS=BS*BS

public func flagMask(number: Int) -> Int {
    return 1<<(number-1)
}

public class sudoku_node {
    public var mNumber = 0
    public var mRow = 0
    public var mCol = 0
    public var mBlock = 0
    public var mBlockRow = 0
    public var mBlockCol = 0
    public var mFlag = 0b111111111
    
    public init(row: Int, col: Int) {
        mRow = row
        mCol = col
        mBlockRow = ((mRow-1) / BS)+1
        mBlockCol = ((mCol-1) / BS)+1
        mBlock = (mBlockRow-1)*BS + mBlockCol
        mFlag = 0b111111111
    }
    public func setNumber(number: Int) {
        // Set the number and clear the flags except the one we want
        mNumber = number
        //mFlag = 1<<(number-1)
        mFlag = flagMask(number: number)
    }
    public func clearFlag(number: Int) {
        mFlag = mFlag & (0b111111111 ^ (flagMask(number: number)))
    }
    public func setFlag(number: Int) {
        mFlag = mFlag | (flagMask(number: number))
    }
    public func getFlag(number: Int) -> Bool {
        let flag = 1<<(number-1)
        if (flag & mFlag) > 0 {
            return true
        } else {
            return false
        }
    }
    public func flagCount() -> Int {
        var count = 0
        for i in 1...9 {
            if getFlag(number: i) { count = count+1 }
        }
        return count
    }
    public func getIndex() -> Int {
        return mCol-1+GS*(mRow-1)
    }
    public func sameNode(row: Int, col: Int) -> Bool {
        if (mRow == row) && (mCol == col) {
            return true
        } else {
            return false
        }
    }
    public func sameRow(row: Int) -> Bool {
        if mRow == row {
            return true
        } else {
            return false
        }
    }
    public func sameCol(col: Int) -> Bool {
        if mCol == col {
            return true
        } else {
            return false
        }
    }
    public func sameBlock(blockRow: Int, blockCol: Int) -> Bool {
        if (mBlockRow == blockRow) && (mBlockCol == blockCol) {
            return true
        } else {
            return false
        }
    }
    public func sameNode(node: sudoku_node) -> Bool { //Add same row, col, node, Block, blockrow, blockCol functions where node is passed in as input
        if (mRow == node.mRow) && (mCol == node.mCol) {
            return true
        } else {
            return false
        }
    }
    public func sameBlock(node: sudoku_node) -> Bool {
        if (mBlockRow == node.mBlockRow) && (mBlockCol == node.mBlockCol) {
            return true
        } else {
            return false
        }
    }
    public func sameRow(node: sudoku_node) -> Bool {
        if mRow == node.mRow {
            return true
        } else {
            return false
        }
    }
    public func sameCol(node: sudoku_node) -> Bool {
        if mCol == node.mCol {
            return true
        } else {
            return false
        }
    }
    public func sameBlockRow(node: sudoku_node) -> Bool {
        if mBlockRow == node.mBlockRow {
            return true
        } else {
            return false
        }
    }
    public func sameBlockCol(node: sudoku_node) -> Bool {
        if mBlockCol == node.mBlockCol {
            return true
        } else {
            return false
        }
    }
}
