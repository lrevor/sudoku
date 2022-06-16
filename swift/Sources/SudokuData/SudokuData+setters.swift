extension sudokuData {
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
}