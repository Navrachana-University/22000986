%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int temp_count = 0;
int label_count = 1;
char* chosen_var = NULL;

typedef struct {
    char* label;
    char* code;
    char* condition;
} CaseBlock;

CaseBlock cases[100];
int case_index = 0;
char* nomatch_code = NULL;

void new_temp(char* temp) { sprintf(temp, "t%d", temp_count++); }
void new_label(char* label) { sprintf(label, "L%d", label_count++); }

int yylex();
void yyerror(const char *s) { fprintf(stderr, "Error: %s\n", s); }
%}

%union {
    char* str;
}

%token <str> IDENT NUMBER
%token CHOOSE OPTION BREAK NOMATCH
%token LBRACE RBRACE LPAREN RPAREN SEMICOLON ASSIGN LT PLUS COLON

%type <str> program stmts stmt case_blocks case_block expr

%%

program:
    stmts { printf("Three Address Code:\n%s", $1); }
;

stmts:
      /* empty */            
        { $$ = strdup(""); }
    | stmts stmt             
        {
          char *buf = malloc(strlen($1) + strlen($2) + 1);
          sprintf(buf, "%s%s", $1, $2);
          $$ = buf;
        }
;

stmt:
    CHOOSE LPAREN IDENT RPAREN
        {
            chosen_var = strdup($3); // set chosen_var before processing cases
        }
    LBRACE case_blocks RBRACE
        {
          char all_code[10000] = "";
          char decision[1000] = "";
          int i;

          for (i = 0; i < case_index; i++) {
              sprintf(all_code + strlen(all_code),
                  "  // Option %s\n  %s:\n%s    goto END\n\n",
                  cases[i].condition + strlen(chosen_var) + 4,
                  cases[i].label, cases[i].code);
              sprintf(decision + strlen(decision),
                  "    if (%s) goto %s\n", cases[i].condition, cases[i].label);
          }

          char nomatch_label[16]; new_label(nomatch_label);
          sprintf(all_code + strlen(all_code),
              "  // nomatch case\n  %s:\n%s    goto END\n\n",
              nomatch_label, nomatch_code ? nomatch_code : "");
          sprintf(decision + strlen(decision),
              "    goto %s\n", nomatch_label);

          sprintf(all_code + strlen(all_code),
              "  // Decision logic\n  START:\n%s\n  END:\n    fiza\n    return\n", decision);

          $$ = strdup(all_code);
          case_index = 0;
        }
  | expr SEMICOLON
        { $$ = $1; }
;

case_blocks:
    case_blocks case_block 
        {
          char *buf = malloc(strlen($1) + strlen($2) + 1);
          sprintf(buf, "%s%s", $1, $2);
          $$ = buf;
        }
  | case_block { $$ = $1; }
;

case_block:
    OPTION NUMBER COLON stmts BREAK SEMICOLON
        {
          char lbl[16]; new_label(lbl);
          char cond[32];
          sprintf(cond, "%s == %s", chosen_var, $2);
          cases[case_index].label = strdup(lbl);
          cases[case_index].code = strdup($4);
          cases[case_index].condition = strdup(cond);
          case_index++;
          $$ = strdup("");
        }
  | NOMATCH COLON stmts BREAK SEMICOLON
        {
          nomatch_code = strdup($3);
          $$ = strdup("");
        }
;

expr:
    expr PLUS expr
        {
          char tmp[16];
          new_temp(tmp);
          char *buf = malloc(strlen($1) + strlen($3) + 64);
          sprintf(buf, "    %s = %s + %s\n", tmp, $1, $3);
          $$ = strdup(buf);
        }
  | IDENT ASSIGN expr
        {
          char *buf = malloc(strlen($1) + strlen($3) + 16);
          sprintf(buf, "    %s = %s\n", $1, $3);
          $$ = buf;
        }
  | IDENT      { $$ = $1; }
  | NUMBER     { $$ = $1; }
;

%%

int main() {
    printf("Enter your code:\n");
    yyparse();
    return 0;
}
