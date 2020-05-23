%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "sglib.h"
/* Just for being able to show the line number were the error occurs.*/
extern FILE *yyout;
extern int yylineno;
int the_errors = 0;
extern int yylex();
int yyerror(const char *);

/* The file that contains all the functions */
#include "jvmSimp.h"

#define TYPEDESCRIPTOR(TYPE) ((TYPE == type_integer) ? "I" : "F")

%}
/* Output informative error messages (bison Option) */
%error-verbose

/* Declaring the possible types of Symbols*/
%union{
   char *lexical;
   int intval;
   struct {
	    ParType type;
	    char * place;} se;
}

/* Token declarations and their respective types */

%token <lexical> T_num
%token <lexical> T_real
%token '('
%token ')'
%token '+'
%token '*'
%token <lexical> T_id
%token T_start "start"
%token T_end "end"
%token T_print "print"
%token T_type_integer "int"
%token T_type_float "float"

%token T_incr "++"

%type<se> expr
%type<se> unary_expression
%%

program: "start" T_id {create_preample($2); symbolTable=NULL; }
			stmts "end"
			{fprintf(yyout,"return \n.end method\n\n");}
	;

/* A simple (very) definition of a list of statements.*/
stmts:  '(' stmt ')' {/* nothing */}
     |  '(' stmt ')' stmts 	{/* nothing */}
     |  '(' error ')' stmts
	;

stmt:  asmt	{/* nothing */}
	| printcmd {/* nothing */}
	;

printcmd: "print"  expr   { 
			   	fprintf(yyout,"getstatic java/lang/System/out Ljava/io/PrintStream;\n");
			    fprintf(yyout,"swap\n");
				  fprintf(yyout,"invokevirtual java/io/PrintStream/println(%s)V\n", TYPEDESCRIPTOR($2.type) ) ;
				}
		   	;

asmt: T_id expr
    { 
      int garbage = addvar($1, $2.type) ;  /* function addvar returns unused info:  0 if var is already in Table otherwise 1  */
      typeDefinition(lookup_type($1), $2.type);
      fprintf(yyout,"%sstore %d\n",typePrefix($2.type),lookup_position($1));
    }
	  ;

unary_expression : '(' T_incr T_id ')'{
    if (!($$.type = lookup_type($3))) {ERR_VAR_MISSING($3,yylineno);}
    typeDefinition(type_integer,lookup_type($3)) ; /* check if T_id is integer */ 
    fprintf(yyout,"iinc %d 1\n",lookup_position($3));
    fprintf(yyout,"iload %d\n",lookup_position($3));
    }
  | '(' T_id T_incr ')'{ 
     if (!($$.type = lookup_type($2))) {ERR_VAR_MISSING($2,yylineno);}
    typeDefinition(type_integer,lookup_type($2)) ; /* check if T_id is integer */ 
    fprintf(yyout,"iload %d\n",lookup_position($2));
    fprintf(yyout,"iinc %d 1\n",lookup_position($2));
    }
	;

expr:   T_num  {$$.type = type_integer; fprintf(yyout,"sipush %s\n",$1);}
	| T_real 	  {$$.type = type_real; fprintf(yyout,"ldc %s\n",$1);}
	| T_id 	 { 
      if (!($$.type = lookup_type($1))) {ERR_VAR_MISSING($1,yylineno);}
			fprintf(yyout,"%sload %d\n",typePrefix($$.type),lookup_position($1));
    }
  | '(' expr ')' { $$.type = $2.type ; }
  | expr expr '+' {
    $$.type = typeDefinition($1.type, $2.type);
	  fprintf(yyout,"%sadd \n",typePrefix($$.type));
    }
  | expr expr '*'{
    $$.type = typeDefinition($1.type, $2.type);
	  fprintf(yyout,"%smul \n",typePrefix($$.type));
  }
  | unary_expression {$$.type = $1.type;}
  | '(' T_type_integer expr ')' {
    if ( $3.type == type_integer ){WRN_VAL_TYPE("int",yylineno);}
    else if($3.type != type_real){yyerror("Type missmatch.");}
      
    $3.type = type_integer ; 
    $$.type = $3.type ;
    fprintf(yyout,"%s2i\n",typePrefix($3.type));
  }
  


  

%%

/* The usual yyerror */
int yyerror (const char * msg)
{
  fprintf(stderr, "ERROR: %s. on line %d.\n", msg,yylineno);
  the_errors++;
}

/* Other error Functions*/
/* The lexer... */
#include "jvmSimpLex.c"

/* Main */
int main(int argc, char **argv ){

   ++argv, --argc;  /* skip over program name */
   if ( argc > 0 )
       yyin = fopen( argv[0], "r" );
   else
       yyin = stdin;
   if ( argc > 1)
       yyout = fopen( argv[1], "w");
   else
	     yyout = stdout;

   int result = yyparse();
   printf("Errors found %d.\n",the_errors);
   fclose(yyout);
   if (the_errors != 0 && yyout != stdout) {
     remove(argv[1]);
      printf("No Code Generated.\n");}

  //print_symbol_table(); /* uncomment for debugging. */

  return result;
}
