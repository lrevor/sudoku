import SudokuNode

//****************************************************************************************
//***************************************************************************************
//*********** Debug Functions ***********
//****************************************************************************************
//****************************************************************************************
extension sudokuData {
    public func debug() {
        gridDump()
        flagDump()
        isValid()
    }
    public func gridDump() {
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
    public func flagDump() {
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
    public func isValid() -> Bool {
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
