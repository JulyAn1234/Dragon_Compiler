%option noyywrap

%{
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <vector>
#include <iostream>

//Token list
//Tabla de dos columnas, primera columna es Token, segunda columna es atributo
std::vector<std::vector<std::string>> TokenList(0, std::vector<std::string>(2));
//Tabla de simbolos
std::vector <std::string> TablaSimbolos;

void AddToken(std::string token, std::string matchedText, bool Indicador)
{
    std::vector<std::string> row1;
    if (Indicador)
        row1 = {token, matchedText};
    else
        row1 = {token, ""};

    TokenList.push_back(row1);
}

void AddID (std::string matchedText)
{
    std::vector<std::string> row1;
    bool b = false;
    int index = 0;
    for (int i = 0; i < TablaSimbolos.size(); i++) {
        if (TablaSimbolos[i] == matchedText) {
            // string already exists in the vector
            b = true;
            index = i;
            break;
        }
    }
    if (!b)
    {
        TablaSimbolos.push_back(matchedText);
        index = TablaSimbolos.size()-1;
    }
    //Creando atributo del token ID
    std::string indexString = "(" + std::to_string(index) + ")";
    //Fila correspondiente al token ID, con el atributo (indice)
    row1 = {"ID", indexString};
    TokenList.push_back(row1);
}

void printTokenList() 
{
  // Print TokenList table
    std::cout << "\n\n********************************TokenList********************************\n\n";
    std::cout << "Token: \tAtributo\n";
    for (int i = 0; i < TokenList.size(); i++) {
        for (int j = 0; j < TokenList[i].size(); j++) {
            if (j==0)
                std::cout <<i<<". "<< TokenList[i][j]<< ":\t";
            else
                std::cout << TokenList[i][j];
        }
        std::cout << std::endl;
    }
    std::cout << "\n\n";
}

void printTablaSimbolos() 
{
    std::cout << "***********************Tabla de Simbolos*****************************\n\n";
    for (int i = 0; i < TablaSimbolos.size(); i++) {
        std::cout << i<< ". "<< TablaSimbolos[i]<<"\n";
    }
    std::cout<<"\n\n";
}

int i = 1;
%}

%%
while {AddToken("WHILE", std::string(yytext), false);}
if  {AddToken("IF", std::string(yytext), false);}
int|float|double|char|string {AddToken("TYPE", std::string(yytext), true);}
true|false {AddToken("BOOL", std::string(yytext), true);}
end {AddToken("END", std::string(yytext), false);}
\+ {AddToken("SUM", std::string(yytext), false);}
- {AddToken("MINUS", std::string(yytext), false);}
\/ {AddToken("DIV", std::string(yytext), false);}
\* {AddToken("MULT", std::string(yytext), false);}
==|\>=|\<=|\>|\< AddToken("REL_OP", std::string(yytext), true);
= {AddToken("ASSIGN", std::string(yytext), false);}
; {AddToken("SEMI_COLON", std::string(yytext), false);}
\: {AddToken("COLON", std::string(yytext), false);}
\( {AddToken("LEFT_GROUP", std::string(yytext), false);}
\) {AddToken("RIGHT_GROUP", std::string(yytext), false);}
\".*\" {AddToken("STRING", std::string(yytext), false);}
[0-9]+(\.[0-9]+) {AddToken("FLOATING", std::string(yytext), true);}
[0-9]+ {AddToken("INTEGER", std::string(yytext), true);}
[a-zA-Z_][a-zA-Z0-9_]* {AddID(std::string(yytext));}
\n {}
. {}


%%

int main(int argc, char** argv) {
    FILE* file = fopen(argv[1], "r");
    if (!file) {
        perror("fopen");
        return 1;
    }

    yyin = file;
    yylex();

    fclose(file);

    printTokenList();
    printTablaSimbolos();
    return 0;
}