import Foundation 
import SudokuData 

let grid = sudokuData()

var previousArgument = ""
var caseLoaded = false
for argument in CommandLine.arguments {
    switch argument {
    case "-solve":
        if caseLoaded {solve()}
 
    case "-debug":
        grid.debug()

    case "-verbose":
        grid.verbose = true

    case "-grid":
        grid.gridDump()

    case "-flags":
        grid.flagDump()

    case "-valid":
        grid.isValid()

    case "-solveone":
        if caseLoaded {solveOne()}

    case "-testcase":
        if grid.verbose { print("-testcase received") }

    default:
        if grid.verbose { print("Unexpected argument: \(argument)") }
        if (previousArgument == "-testcase") {
            grid.setData(testCase: Int(argument) ?? 1)
            caseLoaded = true
        }
    }
    previousArgument = argument
}

// Find a cell to sovle.  This will solve one and only one cell.  Intent is to step through solvers in order of complexity with simple first
func solveOne() -> Bool {
    var found = false
    if grid.scanSingleFlag() {
        found = true
    } else if grid.scanSingle() {
        found = true
    } else if grid.scanSingleBlock() {
        found = true
    } else if grid.scanDoubleBlock() {
        found = true
    } else if grid.scanBlockSingle() { //currently unimplemented
        found = true
    } else if grid.scanBlockDouble() { //currently unimplemented
        found = true
    }
    return found
}

// Solve Sudoku one cell at a time until it is solved or the solver cannot solve additional cells.
func solve() {
    var found = true
    while (found) {
        found = solveOne()
    }
}
