NAME        = sudoku

LIST        =   main.swift    \
            SudokuData.swift \
			SudokuNode.swift \
			SudokuTestData.swift

all:    $(NAME)

$(NAME):    $(LIST)
	swiftc $(LIST) -o $(NAME)

clean:
	rm -f $(NAME)

re: clean all

.PHONY: all clean fclean re debug test
