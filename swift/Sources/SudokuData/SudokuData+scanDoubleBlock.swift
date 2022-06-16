import SudokuNode

    // For each row, column and block, check to see if a pair appears in only 2 nodes
    // if so, clear other flags from those nodes
extension sudokuData {
    public func scanDoubleBlock() -> Bool {
        var clearedFlags = 0
        for i in 1...GS-1 {
            for j in i+1...GS {
                let flag = (flagMask(number: i)) | (flagMask(number: j))
                for row in 1...GS {
                    if getRowFlagMatchCount(row: row, flag: flag) == 2 {
                        if (getRowFlagMatchCount(row: row, flag: flagMask(number: i)) == 2) && (getRowFlagMatchCount(row: row, flag: flagMask(number: j)) == 2) {
                            clearedFlags = setRowFlagMatch(row: row, flag: flag)
                            if clearedFlags > 0 {
                                if verbose { print("Values \(i) and \(j) appear in only 2 nodes in row \(row): clearing other flags") }
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
                                if verbose { print("Values \(i) and \(j) appear in only 2 nodes in column \(col): clearing other flags") }
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
                                if verbose { print("Values \(i) and \(j) appear in only 2 nodes in block \(block): clearing other flags") }
                                return true
                            }
                        }
                    }
                }
            }
        }
        return false
    }
}
