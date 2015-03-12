/*
      mfpl.y

 	Specifications for the MFPL language, YACC input file.

      To create syntax analyzer:

        flex mfpl.l
        bison mfpl.y
        g++ mfpl.tab.c -o mfpl_parser
        mfpl_parser < inputFileName
 */

/*
 *	Declaration section.
 */
%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <iostream>
#include <string>
#include <stack>
#include "SymbolTable.h"
using namespace std;

#define ARITHMETIC_OP	1   // classification for operators
#define LOGICAL_OP   	2
#define RELATIONAL_OP	3

int lineNum = 1;

stack<SYMBOL_TABLE> scopeStack;    // stack of scope hashtables

bool isIntCompatible(const int theType);
bool isStrCompatible(const int theType);
bool isIntOrStrCompatible(const int theType);

void beginScope();
void endScope();
void cleanUp();
TYPE_INFO findEntryInAnyScope(const string theName);

void printRule(const char*, const char*);
int yyerror(const char* s) {
  printf("Line %d: %s\n", lineNum, s);
  cleanUp();
  exit(1);
}

extern "C" {
    int yyparse(void);
    int yylex(void);
    int yywrap() {return 1;}
}

%}

%union {
  char* text;
  int num;
  TYPE_INFO typeInfo;
};

/*
 *	Token declarations
*/
%token  T_LPAREN T_RPAREN 
%token  T_IF T_LETSTAR T_PRINT T_INPUT
%token  T_ADD  T_SUB  T_MULT  T_DIV
%token  T_LT T_GT T_LE T_GE T_EQ T_NE T_AND T_OR T_NOT	 
%token  T_INTCONST T_STRCONST T_T T_NIL T_IDENT T_UNKNOWN

%type	<text> T_IDENT T_STRCONST N_ARITH_OP N_LOG_OP N_REL_OP
%type <typeInfo> N_EXPR N_PARENTHESIZED_EXPR N_ARITHLOGIC_EXPR  
%type <typeInfo> N_CONST N_IF_EXPR N_PRINT_EXPR N_INPUT_EXPR 
%type <typeInfo> N_LET_EXPR N_EXPR_LIST N_BIN_OP

/*
 *	Starting point.
 */
%start  N_START

/*
 *	Translation rules.
 */
%%
N_START		: N_EXPR
			{
			printRule("START", "EXPR");
			printf("\n---- Completed parsing ----\n\n");
			printf("\nValue of the expression is: ");
      if($1.type == INT)
        printf("%d\n", $1.intValue);
      if($1.type == STR)
        printf("%s\n", $1.strValue);
      if($1.type == BOOL){
        if($1.boolValue == true)
          printf("t\n");
        else
          printf("nil\n");
      }
			return 0;
			}
			;
N_EXPR		: N_CONST
			{
			printRule("EXPR", "CONST");
      $$.intValue = $1.intValue;
      $$.strValue = $1.strValue;
      $$.boolValue = $1.boolValue;
			$$.type = $1.type; 
			}
                | T_IDENT
                {
			printRule("EXPR", "IDENT");
                	string ident = string($1);
                	TYPE_INFO exprTypeInfo = 
						findEntryInAnyScope(ident);
                	if (exprTypeInfo.type == UNDEFINED) {
                	  yyerror("Undefined identifier");
                	  return(0);
               	}
                	$$.type = exprTypeInfo.type; 
                  $$.intValue = exprTypeInfo.intValue;
                  $$.strValue = exprTypeInfo.strValue;
                  $$.boolValue = exprTypeInfo.boolValue;

			}
                | T_LPAREN N_PARENTHESIZED_EXPR T_RPAREN
                {
			printRule("EXPR", "( PARENTHESIZED_EXPR )");
			$$.type = $2.type; 
      $$.intValue = $2.intValue;
      $$.strValue = $2.strValue;
      $$.boolValue = $2.boolValue;
			}
			;
N_CONST		: T_INTCONST
			{
			printRule("CONST", "INTCONST");
                	$$.type = INT; 
                  $$.intValue = atoi(yylval.text);
                  $$.boolValue = true;
			}
                | T_STRCONST
			{
			printRule("CONST", "STRCONST");
                	$$.type = STR; 
                  $$.strValue = yylval.text;
                  $$.boolValue = true;
			}
                | T_T
                {
			printRule("CONST", "t");
                	$$.type = BOOL; 
                  $$.boolValue = true;
			}
                | T_NIL
                {
			printRule("CONST", "nil");
			$$.type = BOOL; 
      $$.boolValue = false;
			}
			;
N_PARENTHESIZED_EXPR	: N_ARITHLOGIC_EXPR 
				{
				printRule("PARENTHESIZED_EXPR",
                                "ARITHLOGIC_EXPR");
				$$.type = $1.type; 
        $$.intValue = $1.intValue;
        $$.strValue = $1.strValue;
        $$.boolValue = $1.boolValue;
				}
                      | N_IF_EXPR 
				{
				printRule("PARENTHESIZED_EXPR", "IF_EXPR");
				$$.type = $1.type; 
        $$.intValue = $1.intValue;
        $$.strValue = $1.strValue;
        $$.boolValue = $1.boolValue;
				}
                      | N_LET_EXPR 
				{
				printRule("PARENTHESIZED_EXPR", 
                                "LET_EXPR");
				$$.type = $1.type; 
        $$.intValue = $1.intValue;
        $$.strValue = $1.strValue;
        $$.boolValue = $1.boolValue;
				}
                      | N_PRINT_EXPR 
				{
				printRule("PARENTHESIZED_EXPR", 
					    "PRINT_EXPR");
				$$.type = $1.type; 
        $$.intValue = $1.intValue;
        $$.strValue = $1.strValue;
        $$.boolValue = $1.boolValue;
				}
                      | N_INPUT_EXPR 
				{
				printRule("PARENTHESIZED_EXPR",
					    "INPUT_EXPR");
				$$.type = $1.type; 
        $$.intValue = $1.intValue;
        $$.strValue = $1.strValue;
        $$.boolValue = $1.boolValue;
				}
                     | N_EXPR_LIST 
				{
				printRule("PARENTHESIZED_EXPR",
				          "EXPR_LIST");
				$$.type = $1.type; 
        $$.intValue = $1.intValue;
        $$.strValue = $1.strValue;
        $$.boolValue = $1.boolValue;
				}
				;
N_ARITHLOGIC_EXPR	: N_UN_OP N_EXPR
				{
				printRule("ARITHLOGIC_EXPR", 
				          "UN_OP EXPR");
                      $$.type = BOOL; 
                      $$.boolValue = !$2.boolValue;
				}
				| N_BIN_OP N_EXPR N_EXPR
				{
				printRule("ARITHLOGIC_EXPR", 
				          "BIN_OP EXPR EXPR");
                      $$.type = BOOL;
                      switch ($1.type)
                      {
                      case (ARITHMETIC_OP) :
                        $$.type = INT;
                        $$.boolValue = true;
                        if (!isIntCompatible($2.type)) {
                          yyerror("Arg 1 must be integer");
                          return(0);
                        }
                        if (!isIntCompatible($3.type)) {
                          yyerror("Arg 2 must be integer");
                          return(0);
                        }
                        if($1.strValue == "+")
                          $$.intValue = $2.intValue + $3.intValue;
                        if($1.strValue == "-"){
                          $$.intValue = $2.intValue - $3.intValue;
                        }
                        if($1.strValue == "*")
                          $$.intValue = $2.intValue * $3.intValue;
                        if($1.strValue == "/"){
                          if($3.intValue == 0){
                            yyerror("Attempted division by zero");
                            return(0);
                          }
                          else
                            $$.intValue = $2.intValue / $3.intValue;
                        }
                        break;

				                case (LOGICAL_OP) :
                          if($1.strValue == "or")
                            $$.boolValue = $2.boolValue || $3.boolValue;
                          if($1.strValue == "and")
                            $$.boolValue = $2.boolValue && $3.boolValue;
                        break;

                      case (RELATIONAL_OP) :
                        if (!isIntOrStrCompatible($2.type)) {
                          yyerror("Arg 1 must be integer or string");
                          return(0);
                        }
                        if (!isIntOrStrCompatible($3.type)) {
                          yyerror("Arg 2 must be integer or string");
                          return(0);
                        }
                        if (isIntCompatible($2.type) &&
                            !isIntCompatible($3.type)) {
                          yyerror("Arg 2 must be integer");
                          return(0);
                     	  }
                        else if (isStrCompatible($2.type) &&
                                 !isStrCompatible($3.type)) {
                               yyerror("Arg 2 must be string");
                               return(0);
                             }
                        if($1.strValue == ">")
                          $$.boolValue = $2.intValue > $3.intValue;
                        if($1.strValue == ">=")
                          $$.boolValue = $2.intValue >= $3.intValue;
                        if($1.strValue == "<")
                          $$.boolValue = $2.intValue < $3.intValue;
                        if($1.strValue == "<=")
                          $$.boolValue = $2.intValue <= $3.intValue;
                        if($1.strValue == "="){
                          if($2.type == INT && $3.type == INT)
                            $$.boolValue = $2.intValue == $3.intValue;
                          if($2.type == STR && $3.type == STR){
                            $$.boolValue = !strcmp($2.strValue, $3.strValue);
                          }
                        }
                        if($1.strValue == "/=")
                          $$.boolValue = $2.intValue != $3.intValue;
                        break; 
                      }  // end switch
				}
                     	;
N_IF_EXPR    	: T_IF N_EXPR N_EXPR N_EXPR
			{
			printRule("IF_EXPR", "if EXPR EXPR EXPR");
                if($2.boolValue == false){
                  $$.type = $4.type;
                  $$.intValue = $4.intValue;
                  $$.strValue = $4.strValue;
                  $$.boolValue = $4.boolValue;
                }
                else{
                  $$.type = $3.type;
                  $$.intValue = $3.intValue;
                  $$.strValue = $3.strValue;
                  $$.boolValue = $3.boolValue;
                }
			}
			;
N_LET_EXPR      : T_LETSTAR T_LPAREN N_ID_EXPR_LIST T_RPAREN 
                  N_EXPR
			{
			printRule("LET_EXPR", 
				    "let* ( ID_EXPR_LIST ) EXPR");
			endScope();
                $$.type = $5.type; 
                $$.intValue = $5.intValue;
                $$.strValue = $5.strValue;
                $$.boolValue = $5.boolValue;
			}
			;
N_ID_EXPR_LIST  : /* epsilon */
			{
			printRule("ID_EXPR_LIST", "epsilon");
			}
                | N_ID_EXPR_LIST T_LPAREN T_IDENT N_EXPR T_RPAREN 
			{
			printRule("ID_EXPR_LIST", 
                          "ID_EXPR_LIST ( IDENT EXPR )");
			string lexeme = string($3);
                 TYPE_INFO exprTypeInfo = $4;
                 printf("___Adding %s to symbol table\n", $3);
                 bool success = scopeStack.top().addEntry
                                (SYMBOL_TABLE_ENTRY(lexeme,
									 exprTypeInfo));
                 if (! success) {
                   yyerror("Multiply defined identifier");
                   return(0);
                 }
			}
			;
N_PRINT_EXPR    : T_PRINT N_EXPR
			{
			printRule("PRINT_EXPR", "print EXPR");
                $$.type = $2.type;
                $$.intValue = $2.intValue;
                $$.strValue = $2.strValue;
                $$.boolValue = $2.boolValue;
                if($2.type == STR)
                  printf("%s\n", $2.strValue);
                if($2.type == INT)
                  printf("%d\n", $2.intValue);
                if($2.type == BOOL)
                  printf("%d\n", $2.boolValue);
			}
			;
N_INPUT_EXPR    : T_INPUT
			{
			printRule("INPUT_EXPR", "input");
      string input;
      getline(cin, input);
      if(isdigit(input[0]) || input[0] == '+' || input[0] == '-'){
        $$.type = INT;
        $$.intValue = atoi(input.c_str());
        $$.boolValue = true;
      }
      else{
        $$.type = STR;
        $$.strValue = input.c_str();
        $$.boolValue = true;
      }
			}
			;
N_EXPR_LIST     : N_EXPR N_EXPR_LIST  
			{
			printRule("EXPR_LIST", "EXPR EXPR_LIST");
                $$.type = $2.type;
                $$.intValue = $2.intValue;
                $$.strValue = $2.strValue;
                $$.boolValue = $2.boolValue;
			}
                | N_EXPR
			{
			printRule("EXPR_LIST", "EXPR");
                $$.type = $1.type;
                $$.intValue = $1.intValue;
                $$.strValue = $1.strValue;
                $$.boolValue = $1.boolValue;
			}
			;
N_BIN_OP	     : N_ARITH_OP
			{
			printRule("BIN_OP", "ARITH_OP");
			$$.type = ARITHMETIC_OP;
      $$.strValue = $1;
			}
			|
			N_LOG_OP
			{
			printRule("BIN_OP", "LOG_OP");
			$$.type = LOGICAL_OP;
      $$.strValue = $1;
			}
			|
			N_REL_OP
			{
			printRule("BIN_OP", "REL_OP");
			$$.type = RELATIONAL_OP;
      $$.strValue = $1;
			}
			;
N_ARITH_OP	     : T_ADD
			{
			printRule("ARITH_OP", "+");
      $$ = "+";
			}
                | T_SUB
			{
			printRule("ARITH_OP", "-");
      $$ = "-";
			}
			| T_MULT
			{
			printRule("ARITH_OP", "*");
      $$ = "*";
			}
			| T_DIV
			{
			printRule("ARITH_OP", "/");
      $$ = "/";
			}
			;
N_REL_OP	     : T_LT
			{
			printRule("REL_OP", "<");
      $$ = "<";
			}	
			| T_GT
			{
			printRule("REL_OP", ">");
      $$ = ">";
			}	
			| T_LE
			{
			printRule("REL_OP", "<=");
      $$ = "<=";
			}	
			| T_GE
			{
			printRule("REL_OP", ">=");
      $$ = ">=";
			}	
			| T_EQ
			{
			printRule("REL_OP", "=");
      $$ = "=";
			}	
			| T_NE
			{
			printRule("REL_OP", "/=");
      $$ = "/=";
			}
			;	
N_LOG_OP	     : T_AND
			{
			printRule("LOG_OP", "and");
      $$ = "and";
			}	
			| T_OR
			{
			printRule("LOG_OP", "or");
      $$ = "or";
			}
			;
N_UN_OP	     : T_NOT
			{
			printRule("UN_OP", "not");
			}
			;
%%

#include "lex.yy.c"
extern FILE *yyin;

bool isIntCompatible(const int theType) {
  return((theType == INT) || (theType == INT_OR_STR) ||
         (theType == INT_OR_BOOL) || 
         (theType == INT_OR_STR_OR_BOOL));
}

bool isStrCompatible(const int theType) {
  return((theType == STR) || (theType == INT_OR_STR) ||
         (theType == STR_OR_BOOL) || 
         (theType == INT_OR_STR_OR_BOOL));
}

bool isIntOrStrCompatible(const int theType) {
  return(isStrCompatible(theType) || isIntCompatible(theType));
}

void printRule(const char* lhs, const char* rhs) {
  printf("%s -> %s\n", lhs, rhs);
  return;
}

void beginScope() {
  scopeStack.push(SYMBOL_TABLE());
  printf("\n___Entering new scope...\n\n");
}

void endScope() {
  scopeStack.pop();
  printf("\n___Exiting scope...\n\n");
}

TYPE_INFO findEntryInAnyScope(const string theName) {
  TYPE_INFO info = {UNDEFINED};
  if (scopeStack.empty( )) return(info);
  info = scopeStack.top().findEntry(theName);
  if (info.type != UNDEFINED)
    return(info);
  else { // check in "next higher" scope
	   SYMBOL_TABLE symbolTable = scopeStack.top( );
	   scopeStack.pop( );
	   info = findEntryInAnyScope(theName);
	   scopeStack.push(symbolTable); // restore the stack
	   return(info);
  }
}

void cleanUp() {
  if (scopeStack.empty()) 
    return;
  else {
        scopeStack.pop();
        cleanUp();
  }
}

int main(int argc, char** argv) {
  if (argc < 2) {
    printf("You must specify a file in the command line!\n");
    exit(1);
  }
  yyin = fopen(argv[1], "r");
  do {
    yyparse();
  } while (!feof(yyin));
  return 0;
}
