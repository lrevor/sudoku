    // Determines if a column has a value in only one block, if so, clear value from other columns in the same block
extension sudokuData {
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
}