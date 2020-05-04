/* 
A simple syntax analyser for a AgentSpeak language:
Lexical Analysis File
File contains a simple Lexical Analyser
(Version that generates on C file in the end
*/

%{
#include <stdlib.h>
#include <string.h>

int line = 1;
%}
/* Regular Definitions: These are shorthands for expression and can be used in the 
    rule part below. ATTENTION: When using them in a rule  place the in curtly brackets "{" "}" ! */

digit [0-9]
letter [a-zA-Z]
uppercase [A-Z]
smallcase [a-z]

var {uppercase}({letter}|{digit}|_)*
atom {smallcase}({letter}|{digit}|_)*
num ({digit}+|{digit}+\.{digit}*)

/*New line definition that can handle both UNIX and DOS files. */
newline \n|\x0A|\x0D\x0A


%%
"<-" {return T_ASIGN;}
"true" {return T_TRUE;}
"not" {return T_NOT;}

"+" {return '+';} /* See comment (1) Below */
"-" {return '-';}
"," {return ',';}

"(" {return '(';}
")" {return ')';} 
"." {return '.';}
":" {return ':';}
"&" {return '&';}
"!" {return '!';}
"?" {return '?';}
";" {return ';';}


{num} {return T_NUMBER;}
{var}  {return T_VAR;}
{atom} {return T_ATOM;}
{newline}  {line++;} /* when finding a new line, just increase the line number used for error reporting*/
[ \t] { /* nothing to be done when space and a tab are found!*/ }
. {    /* A simple error message! */ 
	printf("Lexical Analysis: Unexpected String! :: %s. in line %d. \n",yytext,line); }
	
%%
/* Comment (1). The lexer returns the ASCII code of the character found!
Since the lexer reutrns tokens as integers in the case of a single character we do not 
need to specify a new token as in the case of keywords above. We simply return the ASCII code itself.
*/