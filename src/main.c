#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;
extern int	 yyparse(void);

const char *aliases_filename = "/etc/aliases";

int
main(int argc, char *argv[])
{
    if (argc == 2)
	aliases_filename = argv[1];

    yyin = fopen(aliases_filename, "r");

    int res = yyparse();

    fclose(yyin);

    return res;
}
