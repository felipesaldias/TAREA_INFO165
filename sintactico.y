%{

/********************** 
 * Declaraciones en C *
 **********************/

 //Importacion de librerias
  #include <stdio.h>
  #include <stdlib.h>
  #include <math.h>
  #include "string.h"
  #include <graphics.h>
  

  extern int yylex(void);
  extern char *yytext;
  extern FILE *yyin;
 
 //Declaracion de metodos 
  void yyerror(char *s);
  void agregarID(int pos, char id[50], int num);
  void separar(char palabra[50]);
  int buscarID(char id[50]);


//Declaracion del nodo del buffer de identificadores
  struct id {
    char nombre[50];
    int valor;
};

//Declaracion de variables globales
  struct id buffer[1000];
  int pos=0;
  char string[50];
  char parte1[50];
  char parte2[50];





%}

/*************************
  Declaraciones de Bison *
 *************************/

/*Declaración tipo de dato a utilizar en las terminales y variables 
  de la gramatica, en este caso entero y string*/
%union
{
  int numero;
  char* texto;
}

/*Declaración de tokens*/
%token <numero> CONST
%token PARA
%token PARC
%token COMA
%token <texto>IGUAL
%token EDITAR
%token TERMINA
%token COLOR
%token POS
%token DAVALOR
%token DER
%token ARR
%token ABA
%token IZQ
%token <texto>ROJO
%token <texto>VERDE
%token <texto>AZUL
%token <texto>AMARILLO
%token <texto>BLANCO
%token <texto> IDENTIFICADOR



/*Declaracion de variables que tendrán valor asociado*/
%type <numero> dato
%type <numero> col
%type <numero> exp
%type <numero> colores




%%
/***********************
 * Reglas Gramaticales *
 ***********************/

/*Inicio de la gramatica*/
s :			EDITAR inst TERMINA	
			;

inst:		inst inst
			|inst_color
			|inst_pos
			|inst_asig
			|inst_asig2
			|inst_dir
			;

inst_color: COLOR PARA col PARC {setcolor($3);}
			;

inst_pos:	POS PARA exp COMA exp PARC {moveto(53*$3,53*$5);}
			;

inst_asig:	DAVALOR IDENTIFICADOR IGUAL dato {separar($2);agregarID(pos,parte1,atoi(parte2)); pos++;}
			;
inst_asig2:	DAVALOR IDENTIFICADOR IGUAL colores {separar($2);agregarID(pos,parte1,$4); pos++;}
			;			

inst_dir:	DER PARA exp PARC 	{lineto(53*$3+getx(),gety());}
			|ARR PARA exp PARC	{lineto(getx(),gety()-53*$3);}
			|ABA PARA exp PARC	{lineto(getx(),gety()+53*$3);}
			|IZQ PARA exp PARC	{lineto(getx()-53*$3,gety());}
			;

colores:	ROJO 		{$$=4;}
			|VERDE 		{$$=2;}
			|AZUL		{$$=1;}
			|AMARILLO	{$$=14;}
			|BLANCO		{$$=15;}
			;

dato:		CONST {$$=$1; }
			
			;

exp:		IDENTIFICADOR {char pala[50]; strcpy(pala,$1); int i=buscarID(pala);$$=i; }
			|CONST {$$=$1;}
			;

col:		colores
			|IDENTIFICADOR {$$=buscarID($1);}
			;
%%
/**********************
 * Codigo C Adicional *
 **********************/
void yyerror(char *s)
{
	printf("Error sintactico %s \n",s);
}


void agregarID(int pos, char id[50], int num){ //funcion para agregar un identificador y su respectivo valor en el arreglo buffer en la asignacion

	strcpy(buffer[pos].nombre, id);
    buffer[pos].valor=num;
}
int buscarID(char id[50]){  //esta funcion se encarga de retornar el valor que tiene almacenado un id en la tabla de buffer cuando es referenciado
							
	int p=0;
	while(strcmp(buffer[p].nombre, id) != 0){
		p++;
	}
	return buffer[p].valor;
}
void separar(char palabra[50]){/*separa la entrada del token IDENTIFICADOR en el error explicado en el informe, para así separarlos en dos strings, 
								los cuales seran utilizados en la tabla buffer*/

  	for(int k= 0; k<50;k++){
 		parte1[k]=0;
  		parte2[k]=0;
	}
  	int posi=0;
	while(palabra[posi] != '='){
   		posi++;
	}
	int j=0;
	for(int i =0;i<50;i++){
		if (i<posi) parte1[i]=palabra[i];
		else if (i==posi);
		else{
			parte2[j]=palabra[i];
    		j++;
    	}
  	}
}
int main(int argc,char **argv) //Programa Principal
{
	printf("Bienvenida al mejor traductor de lenguaje ETT de la UACH, Instrucciones:\n");
	printf("Para comenzar el programa introduzca: editar\n");
	printf("Los comandos reconocidos por el lenguaje ETT son: \n\n");
	printf("davalor id=dato: permite asignar a id el valor de dato el cual peude ser cualquier numero entero o color entre estos: AMARILLO, ROJO, AZUL, VERDE, BLANCO.\n\n");
	printf("pos(exp,exp): este comando sirve para establecer la posicion en la que queremos empezar a dibujar a continuacion en la ventana, siendo exp un numero o una variable la cual debe estar previamente definida.\n\n");
	printf("color(col): establece el color para las proximas lineas en col. col debe ser un color entre los mencionados anteriormente o una variable que se encuentre definida con un color previamente.\n\n");
	printf("porfavor considerar que la ventana sobre la cual puede dibujar tiene dimensiones de 12 cm de ancho por 9 de alto, y el programa no controla los limites del dibujo, por lo que su dibujo podria llegar a salir de la zona visible eventualmente! \n \n");
	printf("Una vez haya terminado de ingresar comandos la palabra para indicar al programa que termino es: termino \n\n");
	printf("Estas instrucciones que lee a continuacion es lo que genera graphics.h, por tanto no tomar como consideracion, disfrute! \n \n");

	int gd = DETECT,gm; 
	initgraph (& gd,& gm,NULL); //inicializacion de la ventana para dibujar

	yyparse(); //funcion propio de bison que ejecuta el analizador sintactico
	closegraph(); //cierra la ventana si el analisis sintactico termino de manera correcta
	printf("La ejecucion termino de manera correcta ");
	return 0;
}