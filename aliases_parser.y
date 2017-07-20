%{
extern int yylex (void);
extern int yyerror (char *, ...);
%}

%token COMMAND
%token FILENAME
%token IDENTIFIER
%token INCLUDE

%%

aliases: aliases alias
       |
       ;

alias: IDENTIFIER ':' recipients
     ;

recipients: recipients ',' recipient
          | recipient
          ;

recipient: COMMAND
         | FILENAME
         | IDENTIFIER
         | INCLUDE FILENAME
         ;

%%
