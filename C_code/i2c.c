
#define DDRA *(unsigned int *)0x00020100
#define DDRB *(unsigned int *)0x00020200
#define PINA *(unsigned int *)0x00020104
#define PINB *(unsigned int *)0x00020204
#define PORTA *(unsigned int *)0x00020108
#define PORTB *(unsigned int *)0x00020208
#define FND *(unsigned int *)0x00020304


#include <stdint.h>

void delay(int t);

#define I2C_CONF *(uint32_t *)0x00020400
#define I2C_IDR *(uint32_t *)0x00020404
#define I2C_ODR *(uint32_t *)0x00020408
#define I2C_ADDR *(uint32_t *)0x00020412

int main() 
{
I2C_ODR = 0xAA;
I2C_ADDR = 0b10101011;
I2C_CONF = 0x0400;
//*(unsigned int *)0x00020000 = 0x0f;
DDRA = 0x00; // input mode
DDRB = 0x0f; // output mode

// int a, b, c;
// a = 10; b = 20; c = a + b;

    while (1)
    {

        *(unsigned int *)0x00020004 = 0x01; 
if (PINA & 0x01) PORTB = 0x01;
delay(1000);
*(unsigned int *)0x00020004 = 0x02;
if (PINA & 0x01) PORTB = 0x02;
delay(1000);
*(unsigned int *)0x00020004 = 0x04;
if (PINA & 0x01) PORTB = 0x04;
delay(1000);
*(unsigned int *)0x00020004 = 0x08;
if (PINA & 0x01) PORTB = 0x08;
delay(1000);
        // *(uint8_t *) 0x00020300 = 0; // digit 0
        // *(uint8_t *) 0x00020304 = 4; // font 4
        // delay(10);
        // *(uint8_t *) 0x00020300 = 1; // digit 1
        // *(uint8_t *) 0x00020304 = 3; // font 3
        // delay(10);
        // *(uint8_t *) 0x00020300 = 2; // digit 2
        // *(uint8_t *) 0x00020304 = 2; // font 2
        // delay(10);
        // *(uint8_t *) 0x00020300 = 3; // digit 3
        // *(uint8_t *) 0x00020304 = 1; // font 1
        // delay(10);
    }
}



void delay(int t)
{
    int temp = 0;

    for (int i = 0; i < t; i++)
    {
        for (int j = 0; j < 1000; j++)
        {
            temp = temp + 1;
        }
    }
}