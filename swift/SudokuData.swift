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
        debug()
        solve()
    }
    func solve() {
        var found = true
        while (found) {
            found = false
            if scanSingle() {
                found = true
            } else if scanDouble() {
                found = true
            } else if scanSingleBlock() {
                found = true
            }
        }
        debug()
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
    
    // Determines if a column has a value in only one block, if so, clear value from other columns in the same block
    func scanSingleBlock() -> Bool {
        var found = false
        for number in 1...GS {
            for row in 1...GS {
                let block = getRowFlagUniqueBlockMatch(row: row, number: number)
                if block != 0 {
                    let startRow = 1 + BS*((block-1)/BS)
                    let endRow = startRow + BS - 1
                    for clearRow in startRow...endRow {
                        if row != clearRow {
                            if clearRowBlockFlagMatch(row: clearRow, block: block, number: number) {
                                found = true
                                print("Row \(row) has value \(number) in only block \(block): was able to clear values from nearby rows")
                           }
                        }
                    }
                }
            }
            for col in 1...GS {
                let block = getColFlagUniqueBlockMatch(col: col, number: number)
                if block != 0 {
                    let startCol = 1 + BS*((block-1)%3)
                    let endCol = startCol + BS - 1
                    for clearCol in startCol...endCol {
                        if col != clearCol {
                            if clearColBlockFlagMatch(col: clearCol, block: block, number: number) {
                                found = true
                                print("Column \(col) has value \(number) in only block \(block): was able to clear values from nearby columns")
                            }
                        }
                    }
                }
            }
        }
        return found
    }
    func scanSingle() -> Bool {
        // Check to see if any nodes only have 1 flag left.  If so, set it
        for node in data {
            if (node.flagCount() == 1) && (node.mNumber == 0) {
                for value in 1...GS {
                    if node.getFlag(number:value) {
                        print("Node (\(node.mRow),\(node.mCol)) can only be \(value): setting value")
                        setNumber(number: value, row: node.mRow, col: node.mCol)
                        return true
                    }
                }
            }
        }
        // for each row, column, and block, check to see if any values only appear once
        // If so, set it
        for value in 1...GS {
            for row in 1...GS {
                var numPossible = 0
                var tRow = 0
                var tCol = 0
                for node in data {
                    if node.mRow == row {
                        if node.getFlag(number: value) && (node.mNumber != value) {
                            numPossible = numPossible + 1
                            tRow = node.mRow
                            tCol = node.mCol
                        }
                    }
                }
                if numPossible == 1 {
                    print("Node (\(tRow),\(tCol)) is only node in row \(row) for solution \(value): setting value")
                    setNumber(number: value, row: tRow, col: tCol)
                    return true
                }
            }
            for col in 1...GS {
                var numPossible = 0
                var tRow = 0
                var tCol = 0
                for node in data {
                    if node.mCol == col {
                        if node.getFlag(number: value) && (node.mNumber != value) {
                            numPossible = numPossible + 1
                            tRow = node.mRow
                            tCol = node.mCol
                        }
                    }
                }
                if numPossible == 1 {
                    print("Node (\(tRow),\(tCol)) is only node in col \(col) for solution \(value): setting value")
                    setNumber(number: value, row: tRow, col: tCol)
                    return true
                }
            }
            for block in 1...GS {
                var numPossible = 0
                var tRow = 0
                var tCol = 0
                for node in data {
                    if node.mBlock == block {
                        if node.getFlag(number: value) && (node.mNumber != value) {
                            numPossible = numPossible + 1
                            tRow = node.mRow
                            tCol = node.mCol
                        }
                    }
                }
                if numPossible == 1 {
                    print("Node (\(tRow),\(tCol)) is only node in block \(block) for solution \(value): setting value")
                    setNumber(number: value, row: tRow, col: tCol)
                    return true
                }
            }
        }
        print("Did not find any singles")
        return false
    }
    // For each row, column and block, check to see if a pair appears in only 2 nodes
    // if so, clear other flags from those nodes
    func scanDouble() -> Bool {
        var clearedFlags = 0
        for i in 1...GS-1 {
            for j in i+1...GS {
                let flag = (flagMask(number: i)) | (flagMask(number: j))
                for row in 1...GS {
                    if getRowFlagMatchCount(row: row, flag: flag) == 2 {
                        if (getRowFlagMatchCount(row: row, flag: flagMask(number: i)) == 2) && (getRowFlagMatchCount(row: row, flag: flagMask(number: j)) == 2) {
                            clearedFlags = setRowFlagMatch(row: row, flag: flag)
                            if clearedFlags > 0 {
                                print("Values \(i) and \(j) appear in only 2 nodes in row \(row): clearing other flags")
                                return true
                            }
                        }
                    }
                }
                for col in 1...GS {
                    if getColFlagMatchCount(col: col, flag: flag) == 2 {
                        if (getColFlagMatchCount(col: col, flag: flagMask(number: i)) == 2) && (getColFlagMatchCount(col: col, flag: flagMask(number: j)) == 2) {
                            clearedFlags = setColFlagMatch(col: col, flag: flag)
                            if clearedFlags > 0 {
                                print("Values \(i) and \(j) appear in only 2 nodes in column \(col): clearing other flags")
                                return true
                            }
                       }
                    }
                }
                for block in 1...GS {
                    if getBlockFlagMatchCount(block: block, flag: flag) == 2 {
                        if (getBlockFlagMatchCount(block: block, flag: flagMask(number: i)) == 2) && (getBlockFlagMatchCount(block: block, flag: flagMask(number: j)) == 2) {
                            clearedFlags = setBlockFlagMatch(block: block, flag: flag)
                            if clearedFlags > 0 {
                                print("Values \(i) and \(j) appear in only 2 nodes in block \(block): clearing other flags")
                                return true
                            }
                        }
                    }
                }
            }
        }
        return false
    }
    
//****************************************************************************************
//***************************************************************************************
//*********** Debug Functions ***********
//****************************************************************************************
//****************************************************************************************

    func debug() {
        gridDump()
        flagDump()
        isValid()
    }
    func gridDump() {
        print("-------------")
        for row in 1...GS {
            for col in 1...GS {
                if (col%BS == 1) { print("|", terminator: "") }
                if (getNode(row: row, col: col).mNumber != 0) {
                    print(getNode(row: row, col: col).mNumber, terminator: "")
                } else {
                    print(" ", terminator: "");
                }
            }
            print("|")
            if ((row%BS == 0) && (row != 9)) { print("|---|---|---|") }
        }
        print("-------------")
    }
    func flagDump() {
        print("-------------------------------------------")
        for row in 1...GS {
            print("| ", terminator: "")
            for loop in 0...BS-1 {
                for col in 1...GS {
                    for flag in (loop*BS+1)...(loop+1)*BS {
                        if (getNode(row: row, col: col).getFlag(number: flag)) {
                            print(flag, terminator: "")
                        } else {
                            print(" ", terminator: "")
                        }
                    }
                    print(" ", terminator: "")
                    if (col%BS == 0) { print("| ", terminator: "") }
                }
                if loop != 2 {
                    print("")
                    print("| ", terminator: "")
                }
            }
            if (row%BS == 0) {
                print("")
                print("-------------------------------------------")
            } else {
                print("")
                print("|             |             |             |")
            }
        }
    }
    func isValid() -> Bool {
        var isValid = true
        for value in 1...GS {
            for row in 1...GS {
                var numSolutions = 0
                var numPossible = 0
                for node in data {
                    if (node.mRow == row) {
                        if (node.mNumber == value) { numSolutions = numSolutions + 1 }
                        if node.getFlag(number: value) { numPossible = numPossible + 1 }
                    }
                }
                if numSolutions > 1 { print("Row \(row) has too many solutions for \(value)") ; isValid = false }
                if numPossible == 0 { print("Row \(row) has no solutions for \(value)") ; isValid = false }
            }
            for col in 1...GS {
                var numSolutions = 0
                var numPossible = 0
                for node in data {
                    if (node.mCol == col) {
                        if (node.mNumber == value) { numSolutions = numSolutions + 1 }
                        if node.getFlag(number: value) { numPossible = numPossible + 1 }
                    }
                }
                if numSolutions > 1 { print("Col \(col) has too many solutions for \(value)") ; isValid = false }
                if numPossible == 0 { print("Col \(col) has no solutions for \(value)") ; isValid = false }
            }
            for block in 1...GS {
                var numSolutions = 0
                var numPossible = 0
                for node in data {
                    if (node.mBlock == block) {
                        if (node.mNumber == value) { numSolutions = numSolutions + 1 }
                        if node.getFlag(number: value) { numPossible = numPossible + 1 }
                    }
                }
                if numSolutions > 1 { print("Block \(block) has too many solutions for \(value)") ; isValid = false }
                if numPossible == 0 { print("Block \(block) has no solutions for \(value)") ; isValid = false }
            }
        }
        if isValid { print("Block has no current contridictions") }
        return isValid
    }
}
