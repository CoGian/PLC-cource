/* This is an example of a simple LL grammar implementation */
%{
#include <stdio.h>
#include <string.h>

#define TK_NAME 300
#define TK_VAR  301
#define TK_NUM  302
#define TK_TO   303
#define TK_TO_REPORT   304
#define TK_END   305
#define TK_IF   306
#define TK_REPORT   307
#define TK_LEFT_BRACKET   308
#define TK_RIGHT_BRACKET   309
#define TK_EQUAL 310
/* Needed for syntax analyser*/
#define LEXEND 0

int line = 1;
%}

newline \n|\x0A|\x0D|\x0A
uppercase [A-Z]
smallcase [a-z]
letter [A-Za-z]
name {smallcase}+
var (\?){letter}+
digit [0-9]
num {digit}+
%%


{newline} { line++; }
"["  {return TK_LEFT_BRACKET;}
"]"  {return TK_RIGHT_BRACKET;}
"="   {return TK_EQUAL;}
"to"   {return TK_TO;}
"to-report" {return TK_TO_REPORT;}
"end"   {return TK_END;}
"report" {return TK_REPORT;}
"if" {return TK_IF;}
{name} {return TK_NAME;}
{var}  {return TK_VAR;}
{num}  {return TK_NUM;}
. { }
%%
// forward declarations
int token = 0;

void error_syntax(const char* message);
void match(int tk);
/* this will be the top level function of your parser (start symbol)*/
void PDefinitions(void);
void PDef(void); 
void ProcFunN(void);
void VarsInSqrBracks(void);
void Vars(void);
void Vars2(void);
void Body(void);
void varORnum(void);
void Call(void);
void argsORnth(void);
void Args(void) ; 
void Args2(void) ; 


void PDefinitions(void){
   if (token == TK_TO || token == TK_TO_REPORT){PDef(); PDefinitions();}
   else if (token != LEXEND) {error_syntax("PDefinitions Parse not Complete.") ;} 
}

void PDef(void){
   if (token == TK_TO ){match(TK_TO); ProcFunN(); Body(); match(TK_END); }
   else if(token == TK_TO_REPORT){
      match(TK_TO_REPORT); ProcFunN(); Body(); match(TK_END);
   }
   else if (token != LEXEND) {error_syntax("PDef Parse not Complete.") ;}; 
}

void ProcFunN(void){
   if (token == TK_NAME){match(TK_NAME); VarsInSqrBracks();}
   else if (token != TK_IF && token != TK_REPORT && token != TK_VAR && token != TK_NAME) error_syntax("ProcFunN Parse not Complete."); 
}

void VarsInSqrBracks(void){
   if (token == TK_LEFT_BRACKET){match(TK_LEFT_BRACKET); Vars(); match(TK_RIGHT_BRACKET);}
   else if (token != TK_IF && token != TK_REPORT && token != TK_VAR && token != TK_NAME) error_syntax("VarsInSqrBracks Parse not Complete."); 
}

void Vars(void){
   if (token == TK_VAR){match(TK_VAR); Vars2();}
   else if (token != TK_RIGHT_BRACKET) error_syntax("Vars Parse not Complete."); 
}

void Vars2(void){
   if (token == TK_VAR){match(TK_VAR); Vars2();}
   else if (token != TK_RIGHT_BRACKET) error_syntax("Vars2 Parse not Complete."); 
}

void Body(void){
   if (token == TK_IF){
      match(TK_IF); Call(); match(TK_LEFT_BRACKET); Body(); match(TK_RIGHT_BRACKET); 
   }
   else if (token == TK_REPORT){match(TK_REPORT); varORnum();}
   else if (token == TK_NAME){Call();}
   else if (token == TK_VAR){match(TK_VAR); match(TK_EQUAL); match(TK_NUM);}
   else if (token != TK_END && token != TK_RIGHT_BRACKET) error_syntax("Body Parse not Complete.");
}

void varORnum(void){
   if (token == TK_NUM){match(TK_NUM);}
   else if (token == TK_VAR) {match(TK_VAR);}
   else if (token != TK_END && token != TK_RIGHT_BRACKET) error_syntax("varORnum Parse not Complete.");
}

void Call(void){
   if (token == TK_NAME){match(TK_NAME);  argsORnth();}
   else if (token != TK_END && token != TK_RIGHT_BRACKET && token != TK_LEFT_BRACKET) error_syntax("Call Parse not Complete.");
}

void argsORnth(void){
   if (token == TK_VAR || token == TK_NUM){Args();}
   else if (token != TK_END && token != TK_RIGHT_BRACKET && token != TK_LEFT_BRACKET) error_syntax("argsORnth Parse not Complete.");
}

void Args(void){
   if (token == TK_VAR){match(TK_VAR);Args2();}
   else if(token == TK_NUM){match(TK_NUM);Args2();}
   else if (token != TK_END && token != TK_RIGHT_BRACKET && token != TK_LEFT_BRACKET) error_syntax("Args Parse not Complete.");
}

void Args2(void){
   if (token == TK_VAR){match(TK_VAR);Args2();}
   else if(token == TK_NUM){match(TK_NUM);Args2();}
   else if (token != TK_END && token != TK_RIGHT_BRACKET && token != TK_LEFT_BRACKET) error_syntax("Args2 Parse not Complete.");
}
/* Error Reporting */
/* This is a error reporting function that might prove to be handy 
for your debugging. You can call it from different rules error_syntax("<your message here>")
for example error_syntax("PDef") so you can see were your parser has failed.
*/
void error_syntax(const char * message){
   printf("Parsing Rule %s. Syntax Error reading %s at line %d of input. \n",message, yytext, line);
   exit(-1);
}

/* Match next token */
void match(int tk){
   if (token == tk) token = yylex();
   else  error_syntax("Match Failed");
}

int main(int argc, char **argv ){
   ++argv, --argc;  /* skip over program name */
   if ( argc > 0 )
       yyin = fopen( argv[0], "r" );
   else
      yyin = stdin;

   token = yylex();
   PDefinitions();
   if (token == LEXEND) printf("\n Success! \n \n");
   else error_syntax("Parse not Complete.");
   return 0;
}
