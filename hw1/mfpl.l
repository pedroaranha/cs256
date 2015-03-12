/* mfpl.l
   Author: Pedro Aranha (based on Nathan Eloe's Example1.l)

	To create the lexical analyzer: 
	flex mfpl.l
	g++ lex.yy.c -o lexer
	lexer < inputFileName
*/

%{
/*This is vitally important*/
/* Definitions of constants, vars, function prototypes, and #includes go here*/

#define T_KEYWORD  1
#define T_IDENT    2
#define T_INTCONST 3
#define T_STRCONST 4
#define T_OPERATOR 5
#define T_PARENS   6
#define T_COMMENTS 7
#define T_UNKNOWN  8

int numLines = 0;
void printTokenInfo(const char* tokenType, const char* lexeme);

%}

/*Regexes*/
WSPACE [ \t\r]+
NEWLINE \n
DIGIT [0-9]
LETTER [a-zA-Z]
STRING (\".*\"|\'.*\')
COMMENT \;(.*)

/*Keywords*/
LETSTAR let\*
LAMBDA lambda
INPUT input
PRINT print
IF if
AND and
OR or
NOT not
T t
NIL nil

/*Parenthesis*/
LPAREN \(
RPAREN \)

/*Operators*/
ADD \+
MULT \*
DIV \/
SUB \-
LT \<
GT \>
LE <=
GE >=
EQ =
NE \/=


IDENT ({LETTER}|_)({LETTER}|{DIGIT}|_)*
INTCONST ({ADD}|{SUB})*({DIGIT})+
STRCONST {STRING}
COMMENTLINE {COMMENT}$

%%

{INTCONST}  {
               printTokenInfo("INTCONST", yytext);
               return T_INTCONST;
            }

{LETSTAR}   {
               printTokenInfo("LETSTAR", yytext);
               return T_KEYWORD;
            }

{LAMBDA}   {
               printTokenInfo("LAMBDA", yytext);
               return T_KEYWORD;
            }

{INPUT}   {
               printTokenInfo("INPUT", yytext);
               return T_KEYWORD;
            }

{PRINT}   {
               printTokenInfo("PRINT", yytext);
               return T_KEYWORD;
            }

{IF}   {
               printTokenInfo("IF", yytext);
               return T_KEYWORD;
            }

{AND}   {
               printTokenInfo("AND", yytext);
               return T_KEYWORD;
            }

{OR}   {
               printTokenInfo("OR", yytext);
               return T_KEYWORD;
            }

{NOT}   {
               printTokenInfo("NOT", yytext);
               return T_KEYWORD;
            }

{T}   {
               printTokenInfo("T", yytext);
               return T_KEYWORD;
            }

{NIL}   {
               printTokenInfo("NIL", yytext);
               return T_KEYWORD;
            }
            
{LPAREN}   {
               printTokenInfo("LPAREN", yytext);
               return T_PARENS;
            }
            
{RPAREN}   {
               printTokenInfo("RPAREN", yytext);
               return T_PARENS;
            }
            
{ADD}   {
               printTokenInfo("ADD", yytext);
               return T_OPERATOR;
            }
            
{MULT}   {
               printTokenInfo("MULT", yytext);
               return T_OPERATOR;
            }
            
{DIV}   {
               printTokenInfo("DIV", yytext);
               return T_OPERATOR;
            }
            
{SUB}   {
               printTokenInfo("SUB", yytext);
               return T_OPERATOR;
            }
            
{LT}   {
               printTokenInfo("LT", yytext);
               return T_OPERATOR;
            }
            
{GT}   {
               printTokenInfo("GT", yytext);
               return T_OPERATOR;
            }
            
{LE}   {
               printTokenInfo("LE", yytext);
               return T_OPERATOR;
            }
            
{GE}   {
               printTokenInfo("GE", yytext);
               return T_OPERATOR;
            }
            
{EQ}   {
               printTokenInfo("EQ", yytext);
               return T_OPERATOR;
            }
            
{NE}   {
               printTokenInfo("NE", yytext);
               return T_OPERATOR;
            }

{IDENT}     {
               printTokenInfo("IDENT", yytext);
               return T_IDENT;
            }

{STRCONST}  {
               printTokenInfo("STRCONST", yytext);
               return T_STRCONST;
            }

{NEWLINE}   {
               printf("\n");
               numLines+=1;
            }

{COMMENTLINE} {}
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
