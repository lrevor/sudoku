extension sudokuData {
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
        return false
    }
}