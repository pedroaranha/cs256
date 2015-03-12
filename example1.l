/* example1.l
	Example of a lex specification file

	To create the lexical analyzer: 
	flex example1.l
	g++ lex.yy.c -o lexer
	lexer < inputFileName
*/

%{
/*This is vitally important*/
/* Definitions of constants, vars, function prototypes, and #includes go here*/

#define T_IDENT    1
#define T_INTCONST 2
#define T_UNKNOWN  3
#define T_FOO      4

int numLines = 0;
void printTokenInfo(const char* tokenType, const char* lexeme);

%}

/*Regexes*/
WSPACE [ \t\r]+
NEWLINE \n
DIGIT [0-9]
LETTER [a-zA-Z]

IDENT ({LETTER}|_)({LETTER}|{DIGIT})*
INTCONST {DIGIT}+

%%

"foo"       {
               printTokenInfo("FOO", yytext);
               return T_FOO;
            }

{INTCONST}  {
               printTokenInfo("INTCONST", yytext);
               return T_INTCONST;
            }

{IDENT}     {
               printTokenInfo("IDENT", yytext);
               return T_IDENT;
            }

{NEWLINE}   {
               numLines+=1;
            }

{WSPACE}    {}
.           {
               printTokenInfo("UNKNOWN", yytext);
               return T_UNKNOWN;
            }

%%

void printTokenInfo(const char* tokenType, const char* lexeme)
{
  printf("TOKEN: %s  LEXEME: %s\n", tokenType, lexeme);
}

//You should specify a yywrap function.
//Having it return 1 means only 1 input file will be scanned
int yywrap() {return 1;}

int main()
{
  while (yylex());
  printf("Processed %d lines\n", numLines);
  return 0;
}
