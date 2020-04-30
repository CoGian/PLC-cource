/*
A simple syntax analyser for a AgentSpeak language:

Syntax Analysis File
*/

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int yylex();
int yyerror (const char * msg);
/* Just for being able to show the line number were the error occurs.*/
// NOT NEEDED any more::: extern int line;
%}
/* Output informative error messages (bison Option) */
%error-verbose

/* Token declarations */


%token '('
%token ')'
%token '.'
%token ':'
%token '&'
%token '!'
%token '?'
%token ';'

%token T_ATOM
%token T_VAR 
%token T_NUMBER 

%token T_ASIGN "<-"
%token T_TRUE "true"
%token T_NOT "not"

%token '+'
%token '-'
%token ','




%%

agent: beliefs plans 
    ;

beliefs: beliefs belief 
        | /* empty  */ 
        ;

belief: predicate '.'
        ;

predicate: T_ATOM '(' terms ')'
        ;

plans: plans plan 
        | /* empty  */ 
        ;

plan: triggering_event ':' context T_ASIGN body '.'
        | error '.' {yyerrok;}/* error recovery */  
        ;

triggering_event: '+' predicate 
        | '-' predicate
        | '+' goal 
        | '-' goal
        ;

context: "true" 
        | cliterals
        ;

cliterals: literal 
        | literal '&' cliterals
        ;

literal: predicate 
        | "not" '(' predicate ')'
        ;

goal: '!' predicate 
    | '?' predicate
    ;

body: "true" 
    | actions
    ;

actions: action 
        | action ';' actions
        ;

action: predicate 
        | goal 
        | belief_update
        ;

belief_update: '+' predicate 
            | '-' predicate
            ;

terms: term 
    | term ',' terms
    ;

term: T_VAR 
    | T_ATOM 
    | T_NUMBER 
    | T_ATOM '(' terms ')'
    ;


%%
/* Line that includes the lexical analyser */
#include "agentSpeak.lex.c"

/* The usual yyerror, + line number indication. The variable line is defined in the lexical analyser.*/
int yyerror (const char * msg)
{
   fprintf(stderr, "Error(line %d): %s \n", line,msg);
}

/*
NOT NEEDED ANY MORE extern FILE *yyin, *yyout;

*/


/* Main */
int main (int argc, char ** argv)
{ ++argv, --argc; /* skip over program name */
	if ( argc > 0 )
		yyin = fopen( argv[0], "r" );
	else
		yyin = stdin;


    int res = yyparse();
  
    
    if (yynerrs == 0)
        printf("Syntax OK! \n");
    else
        printf("There were %d errors in code. Failure! \n",yynerrs);

}