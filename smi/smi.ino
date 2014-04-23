
#include <stdio.h>                                                                   
#include <stdlib.h>                                                                  
#include <stdint.h> 


#define MDCIP 3 // wiringPi PIN for MDCIP                                            
#define MDIO 2 // wiringPi PIN for MDIO      

int smi_init(void)                                                                
{                                                                                    
    pinMode(MDCIP, OUTPUT);                                                          
    pinMode(MDIO, OUTPUT);                                                           
    return 0;
}                                                                                    
                                                                                     
                                                                                     
/*! Generates a rising edge pulse on IP175 MDC */                                    
void pulse_mdcip(void)                                                               
{                                                                                    
    digitalWrite(MDCIP, 0);                                                          
    delay(1);                                                                       
    digitalWrite(MDCIP, 1);                                                          
    delay(1);                                                                       
}                                                                                    


/*! Performs a smi write */                                                          
void write_smi(uint8_t phy, uint8_t reg, uint16_t data)                              
{                                                                                    
    uint8_t byte;                                                                    
    uint16_t word;                                                                   
                                                                                     
    void (*pulse_mdc)(void);                                                         
    pulse_mdc = pulse_mdcip;                                                         
                                                                                     
    /* MDIO pin is output */                                                         
    pinMode(MDIO, OUTPUT);                                                           
                                                                                     
    digitalWrite(MDIO, 1);                                                           
    for (byte = 0;byte < 32; byte++)                                                 
        pulse_mdc();                                                                 
                                                                                     
    /* Stat code */                                                                  
    digitalWrite(MDIO, 0);                                                           
    pulse_mdc();                                                                     
    digitalWrite(MDIO, 1);                                                           
    pulse_mdc();                                                                     
                                                                                     
    /* Write OP Code */                                                              
    digitalWrite(MDIO, 0);                                                           
    pulse_mdc();                                                                     
    digitalWrite(MDIO, 1);                                                           
    pulse_mdc();                                                                     
                                                                                     
    /* PHY address - 5 bits */                                                       
    for (byte=0x10;byte!=0;byte=byte>>1){                                            
        if (byte & phy)                                                              
            digitalWrite(MDIO, 1);                                                   
        else                                                                         
            digitalWrite(MDIO, 0);                                                   
        pulse_mdc();                                                                 
    }                                                                                
    /* REG address - 5 bits */                                                       
    for (byte=0x10;byte!=0;byte=byte>>1){                                            
        if (byte & reg)                                                              
            digitalWrite(MDIO, 1);                                                   
        else                                                                         
            digitalWrite(MDIO, 0);                                                   
                                                                                     
        pulse_mdc();                                                                 
    }                                                                                
    /* Turn around bits */                                                           
    digitalWrite(MDIO, 1);                                                           
    pulse_mdc();                                                                     
    digitalWrite(MDIO, 0);                                                           
    pulse_mdc();                                                                     
                                                                                     
    /* Data - 16 bits */                                                             
    for(word=0x8000;word!=0;word=word>>1){                                           
        if (word & data)                                                             
            digitalWrite(MDIO, 1);                                                   
        else                                                                         
            digitalWrite(MDIO, 0);                                                   
                                                                                     
        pulse_mdc();                                                                 
    }
                                                                                     
    /* This is needed for some reason... */                                          
    pulse_mdc();                                                                     
    /* Stay in 0 state */                                                            
//  MDCIP = 0;                                                                       
}

uint16_t read_smi(uint8_t phy, uint8_t reg)                                          
{                                                                                    
    uint8_t byte;                                                                    
    uint16_t word, data;                                                             
                                                                                     
    void (*pulse_mdc)(void);                                                         
                                                                                     
    pulse_mdc = pulse_mdcip;                                                         
                                                                                     
    /* MDIO pin is output */                                                         
    pinMode(MDIO, OUTPUT);                                                           
                                                                                     
    digitalWrite(MDIO, 1);                                                           
    for (byte = 0;byte < 32; byte++)                                                 
        pulse_mdc();                                                                 
                                                                                     
    /* Stat code */                                                                  
    digitalWrite(MDIO, 0);                                                           
    pulse_mdc();                                                                     
    digitalWrite(MDIO, 1);                                                           
    pulse_mdc();                                                                     
                                                                                     
    /* Read OP Code */                                                               
    digitalWrite(MDIO, 1);                                                           
    pulse_mdc();                                                                     
    digitalWrite(MDIO, 0);                                                           
    pulse_mdc();                                                                     
                                                                                     
    /* PHY address - 5 bits */                                                       
    for (byte=0x10;byte!=0;){                                                        
        if (byte & phy)                                                              
            digitalWrite(MDIO, 1);                                                   
        else                                                                         
            digitalWrite(MDIO, 0);                                                   
                                                                                     
        pulse_mdc();                                                                 
                                                                                     
        byte=byte>>1;                                                                
    }                                                                                
    /* REG address - 5 bits */                                                       
    for (byte=0x10;byte!=0;){                                                        
        if (byte & reg)                                                              
            digitalWrite(MDIO, 1);                                                   
        else                                                                         
            digitalWrite(MDIO, 0);                                                   
                                                                                     
        pulse_mdc();                                                                 
                                                                                     
        byte=byte>>1;                                                                
    }                                                                                
    /* Turn around bits */                                                           
    /* MDIO now is input */                                                          
    pinMode(MDIO, INPUT);                                                            
    pulse_mdc();                                                                     
    pulse_mdc();                                                                     
    /* Data - 16 bits */                                                             
    data = 0;                                                                        
    for(word=0x8000;word!=0;){                                                       
                                                                                     
        if (digitalRead(MDIO))                                                       
            data |= word;                                                            
                                                                                     
        pulse_mdc();
                                                                         
                                                                                     
        word=word>>1;                                                                
    }                                                                                
                                                                                     
    /* This is needed for some reason... */                                          
    pulse_mdc();                                                                     
    /* Stay in 0 state */                                                            
//  MDCIP = 0;                                                                       
                                                                                     
    return data;                                                                     
}

void setup()
{
  uint16_t reg_val = 0;
  // start serial port at 9600 bps:
  Serial.begin(9600);                                    
  smi_init();                                                                      
  reg_val = read_smi(20, 0x00);                                                  
  Serial.print("reg_val=[0x");
  Serial.print(reg_val, HEX);
  Serial.print("]\n"); 
}


void loop()
{
}

