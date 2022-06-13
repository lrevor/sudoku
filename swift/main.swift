import Foundation 

let grid = sudokuData()

for argument in CommandLine.arguments {
    switch argument {
    case "-solve":
        grid.debug()
        solve()
        grid.debug()
 
    case "-debug":
        grid.debug()

    case "-solveone":
        solveOne()

    default:
        print("Unexpected argument: \(argument)")
    }
}

func solveOne() -> Bool {
    var found = false
    if grid.scanSingle() {
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