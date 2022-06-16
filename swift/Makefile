NAME        = .build/debug/Sudoku

TEST = ./tests

TESTS = \
	$(TEST)/0.in \
	$(TEST)/1.in \
	$(TEST)/2.in \
	$(TEST)/3.in \
	$(TEST)/4.in \
	$(TEST)/0.out \
	$(TEST)/1.out \
	$(TEST)/2.out \
	$(TEST)/3.out \
	$(TEST)/4.out \

all:    $(NAME)

$(TEST)/%.in:
	mkdir -p $(TEST)
	./$(NAME) -testcase 0 -grid > $(TEST)/0.in
	./$(NAME) -testcase 1 -grid > $(TEST)/1.in
	./$(NAME) -testcase 2 -grid > $(TEST)/2.in
	./$(NAME) -testcase 3 -grid > $(TEST)/3.in
	./$(NAME) -testcase 4 -grid > $(TEST)/4.in

$(TEST)/%.out:
	mkdir -p $(TEST)
	./$(NAME) -testcase 0 -solve -grid > $(TEST)/0.out
	./$(NAME) -testcase 1 -solve -grid > $(TEST)/1.out
	./$(NAME) -testcase 2 -solve -grid > $(TEST)/2.out
	./$(NAME) -testcase 3 -solve -grid > $(TEST)/3.out
	./$(NAME) -testcase 4 -solve -grid > $(TEST)/4.out

tests: 	$(NAME) $(TESTS)

$(NAME):
	swift build

release:
	swift build -c release

clean:
	swift package clean
	rm -rf .build
	rm -rf tests

re: clean all

.PHONY: all clean fclean re debug test
