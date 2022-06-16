extension sudokuData {
    func scanSingleFlag() -> Bool {
        // Check to see if any nodes only have 1 flag left.  If so, set it
        for node in data {
            if (node.flagCount() == 1) && (node.mNumber == 0) {
                for value in 1...GS {
                    if node.getFlag(number:value) {
                        if verbose { print("Node (\(node.mRow),\(node.mCol)) can only be \(value): setting value") }
                        setNumber(number: value, row: node.mRow, col: node.mCol)
                        return true
                    }
                }
            }
        }
        return false
    }
}