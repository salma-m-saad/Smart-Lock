#include <mega16.h>
#include <alcd.h>
#include <delay.h>
#include <string.h>

int Data[12] = { 111,203,126,129,128,325,130,426,132,179,134,134 };

char* names[]={"Prof","Ahmed","Amr","Adel","Omer","Admin"};

int id=0,x=0,c=0,i=0,pass=0,y=0,counter=0,oldPass,oldId,saveId;

//Functions
char keypad();

void Insert_data() ;

unsigned char EE_Read(unsigned int address);

void EE_Write(unsigned int add, unsigned char data);

void MyCode();
void alarm();
void readid();

void readpass();

void checkPass();

void confirmPass();

void confirmId();

void ChangeId();

void ChangePass();

void Admin();


void main(void)
{
   
	DDRC = 0b00000111;  //port c.0,1,2 as  output port c.3,4,5,6,7 as  input  
    
	PORTC = 0b11111000; //active pull up at port c.3,4,5,6,7 
    
    DDRD.4=1;           //port D.4 as output   
    
    PORTD.3=1;                            
    
    DDRB=0b00001111;    //port B.0,1,2,3 as output
    
    
    SREG.7 = 1;         
    
    GICR |= 0b10000000;     //active Intrrupt 1       
    
    MCUCR  |= 0b00001100;  // Rising Edge
	
	lcd_init(16);      
        
    Insert_data();         //insert  data to EEPROM
    
	while (1)
		{
        
		   MyCode();
            
		}
}


//code that will be repeated
void MyCode(){  

           lcd_clear();  //make lcd empty
           
           x= keypad();
           
           if(x==10){ 
           
                lcd_clear(); 
                
                lcd_printf("Enter your ID   "); 
                
                readid();   // Enter 3digits Id
                
                lcd_clear(); 
                 
                checkPass();  // Enter 3digits pass 
                
                lcd_clear();
                
                if(counter>=3){    // user enter wrong pass 3 times
           
                    lcd_printf("You Can't Enter");
                    
                    delay_ms(1500);    //wait 1500 ms
                    
                    MyCode(); // start from begin and enter new id
                } 
                
                lcd_printf("* Close         #Change Pass");   //if user want change his pass or just open the door
                
                x = keypad();      //enter * or #
                
                lcd_clear();
                
                if(x==11){    //user want change his pass
             
                    lcd_clear();
                    
                    lcd_printf("Enter New pass  "); 
                    
                    readpass();       //user enter his new pass 
                    
                    confirmPass();    //user confirm his new pass
            
                }
                lcd_clear();  
                
                for(i=0;i<12;i+=2) //search for name 
                
                    if( id == Data[i] ) {
                         lcd_printf("Welcom %s",names[i/2]); 
                         
                         PORTB.1=1;     // open door
                         
                         PORTB.2 = 1;   // turn on led 
                         
                         PORTB.3=1;     // turn on peep alarm 
                         
                         delay_ms(2000); 
                         
                         PORTB.1=0;     
                         
                         PORTB.0=1;   //close door
                         
                         delay_ms(2000); 
                         
                         PORTB.2 = 0;    //turn off led
                          
                         PORTB.3=0;     // turn off peep alarm
                         
                         PORTB.0=0;
                    }
           }
           
           

}

//peep alarm and turn on/off led
void alarm() {

         PORTB.2 = 1;   // turn on led 
                         
         PORTB.3=1;     // turn on peep alarm  
         
         delay_ms(1500);
         
         PORTB.2 = 0;    //turn off led
                          
         PORTB.3=0;     // turn off peep alarm
}


// user want change his pass
void ChangePass(){ 
      
       char m=oldPass;  //pass
          
        for(i=0;i<12;i+=2)if(id==Data[i]){Data[i+1]=oldPass;break;} //change old pass to new one in Data array
        
        //change old pass to new one in EEPROM
        
        EE_Write(id,m);  
        
        m=oldPass>>8; 
        
        EE_Write(id+1,m );
}


//confirm new pass
void confirmPass(){
         
         oldPass=pass;
         
         for(counter=0;counter<3;counter++){  
         
                lcd_clear();
                
                lcd_printf("Confirm new pass  "); 
                
                readpass();              //enter new pass again   
                
                if(pass==oldPass) break;  //new pass is confirmed  loop will stop
                
                lcd_clear();
                
                lcd_printf("Pass not Match  "); //new pass is not confirmed 
                
               alarm();
          
         }  
          lcd_clear();
            
            
          if(counter>=3){ //user can't confirm his new pass 3 times so pass did't change
             
             lcd_printf("Pass Can't change"); 
             
             alarm();
          }
          
          else {  
          
              ChangePass();   //change old pass to new one
              
              lcd_printf("Pass Changed");    //print at lcd that pass changed
              
              delay_ms(1500);    //wait 1500 ms
          }
           
}


//enter pass and check if is true or not
void checkPass(){

           counter=0; 
           
           while( counter < 3 ){
           
                lcd_clear();
                
                lcd_printf("Enter Your Pass ");
                
                readpass();    //reed 3 digits pass
                
                x=EE_Read(id);   //reed stored pass in EEPROM
                
                y=EE_Read(id+1)<<8;   //reed stored pass in EEPROM
                
                lcd_clear();     
                
                if(x+y==pass) {     //Enterd pass match pass that stored in EEPROM
             
                    break; 
                }  
                
                else {             //Enterd pass dosen't match pass that stored in EEPROM
                
                    lcd_printf("Wrong Pass!!");  
                    
                   alarm();
                }
                
                counter++;   
           }
}


//Enter 3 digit pass from keypad
void readpass(){
    
     pass=0,c=0;
     
     while(c<3){ 
     
        x = keypad();         //read one digit from keypad
     
        pass = pass * 10 + x ; //store 3digits as one int number pass
       
        lcd_printf("*");
     
        c++;  
     
     } 
      x = keypad();       //read one digit from keypad
}


//Enter 3 digit id from keypad
void readid(){
      
     id=0,c=0;
    
     while( c < 3 ){
     
        x = keypad();     //read one digit from keypad
        
        id = id * 10 + x ;    //store 3digits as one int number id
          
        lcd_printf("*");
        
        c++;
     }
      
      x = keypad();       //read one digit from keypad
      
}


//enter one digit from user
char keypad()
{
	while(1)
		{
            PORTC.0 = 0; PORTC.1 = 1; PORTC.2 = 1;  
            
            //Only C1 is activated  
            
            switch(PINC)
            {
                case 0b11110110:   //user press 1
                
                while (PINC.3 == 0);
                
                return 1;
                
                break;
                
                case 0b11101110:   //user press 4
                
                while (PINC.4 == 0);
                
                return 4;
                
                break;
                
                case 0b11011110:     //user press 7
                while (PINC.5 == 0);
                return 7;
                break;
                
                case 0b10111110:    //user press *
                while (PINC.6 == 0);
                return 10;
                break;
                
            }
            PORTC.0 = 1; PORTC.1 = 0; PORTC.2 = 1; 
            
            //Only C2 is activated
            switch(PINC)
            {
                case 0b11110101:   //user press 2
                while (PINC.3 == 0);
                return 2;
                break;
                
                case 0b11101101:    //user press 5
                while (PINC.4 == 0);
                return 5;
                break;
                
                case 0b11011101:    //user press 8
                while (PINC.5 == 0);
                return 8;
                break;
                
                case 0b10111101:    //user press 0
                while (PINC.6 == 0);
                return 0;
                break;
                
            } 
            
            PORTC.0 = 1; PORTC.1 = 1; PORTC.2 = 0;
            //Only C3 is activated
            switch(PINC)
            {
                case 0b11110011:   //user press 3
                while (PINC.3 == 0);
                return 3;
                break;
                
                case 0b11101011:    //user press 6
                while (PINC.4 == 0);
                return 6;
                break;
                
                case 0b11011011:     //user press 9
                while (PINC.5 == 0);
                return 9;
                break;
                
                case 0b10111011:    //user press #
                while (PINC.6 == 0);
                return 11;
                break;
                
            }  
        
		}
}


//store data in EEPROM
void Insert_data() {
     
    for (i=0; i < 12; i+=2) {  
    
        char c=Data[i+1];  //pass   
         
        //store pass in 2byte in EEPROM
        
        EE_Write(Data[i],c );  
        
        c=Data[i+1]>>8; 
        
        EE_Write(Data[i]+1,c );
        
    }
}   
 

//read from EEPROM          
unsigned char EE_Read(unsigned int address)       //read from EEPROM
{

 while(EECR.1 == 1);    //Wait till EEPROM is ready  (eeprom not busy)                
 EEAR = address;        //Prepare the address you want to read from
 
 EECR.0 = 1;            //Execute read 
 
 return EEDR;

}

//write into  EEPROM
void EE_Write(unsigned int add, unsigned char data)            //write to EEPROM
{

 while(EECR & 0x2 );    //Wait till EEPROM is ready  (eeprom not busy)              
 EEAR = add;        //Prepare the address you want to read from
 EEDR = data;           //Prepare the data you want to write in the address above
 EECR.2 = 1;            //Master write enable
 EECR.1 = 1;            //Write Enable

}


//admin change id of user
void ChangeId(){
     
        for(i=0;i<12;i+=2)if(saveId==Data[i]){Data[i]=id;break;}//change id in Data array
        
        //restore pass in old id address to new id address
        
        EE_Write(id,EE_Read(saveId) );
        
        EE_Write(id+1,EE_Read(saveId+1) );
        
        //make old id address value to 0 
        
        EE_Write(saveId,0);
         
        EE_Write(saveId+1,0);
    
    
}


//confirm new id that admin changed 
void confirmId(){
         
         oldId=id; 
         
         for(counter=0;counter<3;counter++){
         
            lcd_clear();
            
            lcd_printf("Confirm new Id   ");
            
            readid();          //enter new id again 
             
            if(id==oldId) break;  //new id is confirmed  loop will stop
             
            lcd_clear();
            
            lcd_printf("Id not Match  ");  //new id is not confirmed
            
           alarm();
          
          }  
          lcd_clear();
            
            
          if(counter>=3){   //Admin can't confirm new id 3 times so pass did't change
             
             lcd_printf("Id Can't change"); 
             
            alarm();
          }
          else { 
           
              ChangeId();      //change old id to new one
              
              lcd_printf("Id Changed"); 
              
              delay_ms(1500);
          }
           
}


//admin entrrupt and change id or pass of any one
void Admin(){

      lcd_clear(); 
      
      lcd_printf("Enter Your ID   ");
      
      readid();                        //enter admin id
      
      lcd_clear();
        
      checkPass();                //enter admin pass
      
      if(id==Data[10]&&pass==Data[11]){       //enterd id and pass is id,pass of admin
      
         while(1){
         
            lcd_clear();
            
            lcd_printf("* Close         # Edit");
            
            x=keypad();
            
            if(x==11){  // admin want Edit info   he presed #
            
               lcd_clear();
               
               lcd_printf("* Edit id       # Edit Pass"); //press * for edit id press # for edit pass
               
               x=keypad();
               
               if(x==10){   //admin press * 
               
                    lcd_clear();
                    
                    lcd_printf("Enter ID        ");
                    
                    readid();         //read id of person want to be changed 
                    
                    lcd_clear();
                    
                    saveId=id;        //saveId is id wanted to be changed
                    
                    lcd_printf("Enter new Id    ");
                    
                    readid();        //enter new id
                    
                    confirmId();     //confirm new id
                 
               }
               else { //press # want change pass
               
                lcd_clear(); 
                
                lcd_printf("Enter ID        ");
                
                readid();      //read id of person want to be changed 
                
                lcd_clear(); 
                
                lcd_printf("Enter new Pass   ");
                
                readpass();    //read new pass
                
                lcd_clear();
                
                confirmPass();  //confirm new pass
                
                lcd_clear();
               }
            
            }
            else break;    //press * to close admin mood 
         }
         
      }
      else { //enterd id and pass is not id,pass of admin
          lcd_clear();
          
          lcd_printf("You are not Admin");  
          
          }

}


//handel intrrupt1 at portd3
interrupt [3] void EXT__INT1(void)
{  
   SREG.7 = 1; //enable global intrupt
            
   PORTD.4= 1;  //turn on red led
   
   Admin();//admin mood
   
   PORTD.4= 0;   //turn off red led
   
   delay_ms(500);
   
   lcd_clear();
}

