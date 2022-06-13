extension sudokuData {
    func getNode(row: Int, col: Int) -> sudoku_node {
        return data[getIndex(row: row, col: col)]
    }
    func getIndex(row: Int, col: Int) -> Int {
        return col-1+GS*(row-1)
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
}