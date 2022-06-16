import SudokuNode

extension sudokuData {
    public func scanSingle() -> Bool {
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
                    if verbose { print("Node (\(tRow),\(tCol)) is only node in row \(row) for solution \(value): setting value") }
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
                    if verbose { print("Node (\(tRow),\(tCol)) is only node in col \(col) for solution \(value): setting value") }
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
                    if verbose { print("Node (\(tRow),\(tCol)) is only node in block \(block) for solution \(value): setting value") }
                    setNumber(number: value, row: tRow, col: tCol)
                    return true
                }
            }
        }
        return false
    }
}
