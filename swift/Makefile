NAME        = sudoku

TEST = tests/in.1

all:    $(NAME)

tests: $(NAME)
	./$(NAME) -testcase 0 -grid > tests/in.0
	./$(NAME) -testcase 1 -grid > tests/in.1
	./$(NAME) -testcase 2 -grid > tests/in.2
	./$(NAME) -testcase 3 -grid > tests/in.3
	./$(NAME) -testcase 4 -grid > tests/in.4
	./$(NAME) -testcase 0 -solve -grid > tests/out.0
	./$(NAME) -testcase 1 -solve -grid > tests/out.1
	./$(NAME) -testcase 2 -solve -grid > tests/out.2
	./$(NAME) -testcase 3 -solve -grid > tests/out.3
	./$(NAME) -testcase 4 -solve -grid > tests/out.4

$(NAME):
	swift build

release:
	swift build -c release

clean:
	swift package clean
	rm -rf .build

re: clean all

.PHONY: all clean fclean re debug test
