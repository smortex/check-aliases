%{
#include <stdarg.h>

#include "aliases_parser.h"

int lineno = 1;

int	 yyerror(char *, ...);

extern const char *aliases_filename;

static char *current_line;
static char *current_line_pos;

void                                                                                                                          
update_curent_line (void)                                                                                                     
{                                                                                                                             
    free (current_line);                                                                                                      
    current_line = strdup (yytext);                                                                                           
    current_line_pos = yytext;                                                                                                
}                                                                                                                             
                                                                                                                              
void                                                                                                                          
yyclean (void)                                                                                                                
{                                                                                                                             
    free (current_line);                                                                                                      
    current_line = NULL;                                                                                                      
}                                                                                                                             

%}

%option nounput
%option noinput

%x PARSE

%%

<INITIAL>.*                     update_curent_line(); BEGIN(PARSE); yyless(0);

<PARSE>[ \t]                    ;
<PARSE>#.*$                     ;

<PARSE>:include:                return INCLUDE;
<PARSE>:                        return ':';
<PARSE>,                        return ',';

<PARSE>\/[^\t ,\n]+             return FILENAME;
<PARSE>\"\|[^\"\n]+\"           return COMMAND;
<PARSE>\|[^ \t,\n]+             return COMMAND;
<PARSE>[a-zA-Z0-9_][^ \t,:\n]*  return IDENTIFIER;

<*>\n                           lineno++; BEGIN(INITIAL);

<*>.                            yyerror("Unexpected character: '%c'", yytext[0]);

%%

int
yyerror(char *msg, ...)
{
    char *s;

    va_list ap;
    va_start(ap, msg);
    vasprintf(&s, msg, ap);
    va_end(ap);

    printf("\033[1m%s:%d:%ld: \033[31;1merror:\033[0;1m %s\033[0m\n", aliases_filename, lineno, yytext - current_line_pos + 1, s);
    free(s);
    printf("%s\n", current_line);
    for (int i = 0; i < yytext - current_line_pos; i++)
        printf(" ");
    printf("\033[32;1m^");
    for (int i = 1; i < (int) yyleng; i++)
        printf("~");
    printf("\033[0m\n");
    return 0;
}

int
yywrap(void)
{
    return 1;
}
