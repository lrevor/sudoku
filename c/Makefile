NAME        = sudoku

SOURCES        =   \
		main.c \
		sudoku.c \

HEADERS        =   \
		sudoku.h \

all:    $(NAME)

$(NAME):    $(SOURCES) $(HEADERS)
	cc $(SOURCES) -o $(NAME)

clean:
	rm -f $(NAME)

re: clean all

.PHONY: all clean fclean re debug test
