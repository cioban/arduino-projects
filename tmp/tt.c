#include <stdio.h>
#include <string.h>
#include <stdlib.h>

const char *byte_to_binary(int x)
{
    static char b[9];
    b[0] = '\0';
    int z;

    for (z = 256; z > 0; z >>= 1) {
        strcat(b, ((x & z) == z) ? "1" : "0");
    }

    return b;
}

int main(void)
{
	unsigned char green			= 1;
	unsigned char red			= 2;
	unsigned char operator		= 0;
	unsigned char leds_value	= 1;
	unsigned char leds_value_aux= 0;

	unsigned char aux			= 1;
	unsigned char aux2			= 2;
	int i=0;
   /* {
        // binary string to int

        char *tmp;
        char *b = "0101";

        printf("%d\n", strtol(b, &tmp, 2));
    }

    {
        // byte to binary string

        printf("%s\n", byte_to_binary(5));
    }*/

	while(leds_value <= 255) {
		printf("%s [%03d] [0x%02X]\n", byte_to_binary(leds_value), leds_value, leds_value);

		leds_value_aux = leds_value;
		if (leds_value >= 85) {
			//red = red << 0x02;
			//leds_value |= red;
			leds_value_aux = leds_value | 2;
		}
		else if (leds_value > 85) {
			leds_value_aux = leds_value | 2;
		}
		leds_value |=  leds_value_aux << 0x02;



		i++;
		if (i >= 20) {
			break;
		}

	}






	printf("==== Funciona ===\n");
	for(i=0; i<4; i++){
		printf("%s [%03d] [0x%02X]\n", byte_to_binary(aux), aux, aux);
		if (aux < 255) {
			aux |= aux << 0x02;
		}
	}

	for(i=0; i<4; i++){
		aux |= aux2;
		printf("%s [%03d] [0x%02X]\n", byte_to_binary(aux), aux, aux);
		//aux2 |= aux2 << 0x01;
		if (aux2 < 255) {
			aux2 = aux2 << 0x02;
		}
	}
    return 0;
}
