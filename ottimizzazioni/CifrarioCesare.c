#include <stdio.h>

int main() {
    char frase[31] = "ARCHITETTURA DEGLI ELABORATORI";
    char frase_cifrata[31] = "";
    int chiave = 13;
    int i;

    printf("%s", frase);

    for (i = 0; i < 31; i++) {
        if (frase[i] < '[' && frase[i] > '@') {
            if (frase[i] < '[' - chiave)
                frase_cifrata[i] = frase[i] + chiave;
            else
            {
                frase_cifrata[i] = 'A' + chiave - ('Z' - frase[i]) - 1;
                
            }
        }
        else
            frase_cifrata[i] = frase[i];
    }

    printf("\n%s", frase_cifrata);
    
    return(0);
}