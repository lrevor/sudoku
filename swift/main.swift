import Foundation 

let grid = sudokuData()

for argument in CommandLine.arguments {
    switch argument {
    case "-solve":
        solve()
 
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
        solveOne()

    default:
        if grid.verbose { print("Unexpected argument: \(argument)") }
    }
}

func solveOne() -> Bool {
    var found = false
    if grid.scanSingleFlag() {
        found = true
    } else if grid.scanSingle() {
        found = true
    } else if grid.scanDouble() {
        found = true
    } else if grid.scanSingleBlock() {
        found = true
    }
    return found
}

func solve() {
    var found = true
    while (found) {
        found = solveOne()
    }
}