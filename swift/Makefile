NAME        = sudoku

LIST        =   main.swift    \
            SudokuData.swift \
			SudokuNode.swift \
			SudokuTestData.swift \
			SudokuData+debug.swift \
			SudokuData+getters.swift \
			SudokuData+setters.swift \
			SudokuData+scanSingle.swift \
			SudokuData+scanSingleFlag.swift \
			SudokuData+scanSingleBlock.swift \
			SudokuData+scanDouble.swift

all:    $(NAME)

$(NAME):    $(LIST)
	swiftc $(LIST) -o $(NAME)

clean:
	rm -f $(NAME)

re: clean all

.PHONY: all clean fclean re debug test
