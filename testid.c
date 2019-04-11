#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct id {
    char nombre[50];
    int valor;
};
void agregarID(int pos, char id[50], int num);
int buscarID(char id[50]);

struct id buffer[1000];

int main(int argc, char *argv[])
{
    
   
   	agregarID(1,"Felipe",6);

    for (int i=0;i<10;i++){
    	printf("El nombre de la posicion %i del buffer es:%s y su valor es : %i \n",i , buffer[i].nombre, buffer[i].valor );
    }

   printf("El valor de felipe es: %i \n",buscarID("Felipe") );
   

    
}
void agregarID(int pos, char id[50], int num){

	strcpy(buffer[pos].nombre, id);
    buffer[pos].valor=num;
}
int buscarID(char id[50]){

	int p=0;
	while(strcmp(buffer[p].nombre, id) != 0){
		p++;
	}
	return buffer[p].valor;
}