%{
/* se necesita esto para la llamada a atof() más abajo */
#include <math.h>
#include "sintactico.tab.h"	/*incluye un archivo generado por bison para permitir la comunicacion de los tokens
							  entre flex y bison*/

%}
/*Declaracion de expresiones regulares a utilizar*/
DIGITO   [0-9]
ID       [A-z][A-z0-9]* 

/*Declaracion de tokens mediante expresiones regulares*/
%%

{DIGITO}+   {yylval.numero=atof(yytext); return(CONST);}

"(" 		{return(PARA);}
")" 		{return(PARC);}
"editar"  	{return(EDITAR); printf( "Se enconetro la palabra clave being: %s con un largo de %i\n", yytext ,(int)(yyleng) );}
"termino" 	{return (TERMINA);}
"color"		{return (COLOR);}
"pos"		{return (POS);}
"davalor"	{return (DAVALOR);}
"der"		{return (DER);}
"arr"		{return (ARR);}
"aba" 		{return (ABA);}
"izq" 		{return (IZQ);}
"rojo"		{return(ROJO);}
"verde"		{return (VERDE);}
"azul"		{return (AZUL);}
"amarillo"	{return (AMARILLO);}
"blanco"  	{return (BLANCO);}
"," 		{return(COMA);}
"=" 		{ yylval.texto=yytext;return(IGUAL);}

{ID}        {yylval.texto=yytext;return(IDENTIFICADOR);}
"{"[^}\n]*"}"     /* se come una linea de comentarios */

[ \t\n]+          /* se come los espacios en blanco */

