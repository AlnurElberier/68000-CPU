*-----------------------------------------------------------
* Title      :
* Written by : Goitom, Berry, Alnur  
* Date       :
* Description: 
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program 

*----------------------------------------------------------
          * ----------PRINT WELCOME MESSAGE-------
*----------------------------------------------------------

WELLCOME_MESSA   LEA MESSAGE, A1 
                 MOVE.B #14, D0  
                 TRAP #15
    
*----------------------------------------------------------
          * ----------ASKE USER FOR STARTING ADRESS-------
          * STARTING ADRESS SAVE IN   =  D5  then to    A3    
*----------------------------------------------------------
    
STARTING_ADD     LEA startingADDRESS, A1 
                 MOVE.B #14, D0  
                 TRAP #15
                 LEA STARTING, A1       * STORE INPUT HERE 
                 MOVE.B #2, D0          * accept user input 
                 TRAP #15 
                 JSR CHEEK_LENGTH       * jump to cheek the length of the input 
                 CLR D2                 * ready D2 to store the ending address 
                 JSR ASSIC_HEX          * convert to hex 
                 JSR MAX_SIZE
                 MOVEA.L D5, A3          * store starting address IN TO regester A3    
                 CLR.L D5       
                 BRA ENDING_ADD         
           
CHEEK_LENGTH    MOVEQ  #$0, D2          * store 0 in D2  
                CMP.B D2, D1            * compare if the value in D1 is equal to 1  
                BEQ LENGTH_TOO_SHORT    * if length is 0 then branch to error message 
                CLR D2                  * make ready D2 to use for next instruction 
                MOVEQ  #$8, D2          * stop the value 8 in D2 
                CMP.B  D2, D1           * compare if the value in D1 is greater than 8  
                BGT LENGTH_TOO_LONG     * if the length is greater then branch it to error length 
                RTS     
                
                 
LENGTH_TOO_SHORT   LEA ERROR_LENGTH_TOO_SHORT, A1 
                   MOVE.B #14, D0  
                   TRAP #15 
         SIMHALT             ; halt simulator
*----------------------------------------------------------
          * ----------ASKE USER FOR ENDING  ADRESS-------
          * ENDING ADRESS SAVE IN   =  D1    then to A4  
*----------------------------------------------------------
         
LENGTH_TOO_LONG    LEA ERROR_LENGTH_TOO_LONG, A1 
                   MOVE.B #14, D0  
                   TRAP #15  
        SIMHALT             ; halt simulator 
 
ENDING_ADD        LEA ending_ADRESS, A1 
                  MOVE.B #14, D0 
                  TRAP #15 
                  LEA ENDING, A1 
                  MOVE.B #2, D0 
                  TRAP #15
                  JSR CHEEK_LENGTH 
                  CLR D2 
                  JSR ASSIC_HEX 
                  JSR MAX_SIZE
                  JSR COMPAIR_START_ENDING 
                  MOVEA.L D5, A4
                  CLR.L D5   
                  BRA TEST_DONE
                                    
COMPAIR_START_ENDING   CMP.L A3, D5     
                       BLT  ERROR 
                       RTS 
                       
ERROR              LEA ERROR_SIZE, A1 
                   MOVE.B #14, D0  
                   TRAP #15  
 SIMHALT             ; halt simulator 
  
      
MAX_SIZE         MOVE.L #MAX_ENDE_ADDRESS, D6     * STORE MAX SIZE HERE TO COMPAIR IT NEXT 
                 CMP D5, D6                       * COMPAIR CURRENT INPUT ADDRESS WITH MAX SIZE 
                 BGT ERROR                        * IF CURRENT INPUT IS GREATER THAN MAX, PRINT TO ERROR 
                 CLR.L D6                           * CLER MEMORY TO USE IT FOR LATER      
                 RTS                                  
                                 
ASSIC_HEX      CMPI.B #$0, D1  
               BEQ ALL_CONVERTED  
               MOVE.B (A1)+, D4 
               CMPI.B #$40, D4   * IS IT 0-9 
               BLT   ITS_NUMBER    * YES, THEN BRANCHE IT 
               CMPI.B #$47, D4   * IS IT A-F?  
               BLT   ITS_UPPER   * BRANCHE IT TO UPPER CASE 
               CMP.B #$67, D4    * IS IT a-f ? 
               BLT   ITS_LOWER 
  
ALL_CONVERTED  RTS

CHAR_LOOP       SUBI.B  #$1, D1 
                ADD.B   D4, D5 
                CMPI.B  #$0, D1  * CHEAK IF ALL ASSIC HAVE CONVERTED 
                BEQ  ASSIC_HEX 
                *ROL.L  #4, D5    * SHIFET TO LEFT T ADD THE NEW VALUE TO THE LEFT 
                ASL.L #4,D5        * SHIFET TO LEFT T ADD THE NEW VALUE TO THE LEFT 
 
                BRA ASSIC_HEX 

ITS_NUMBER      SUBI.B #$30, D4     * SUBSTRUCT 30 TO GET 1 - 9 
                BRA CHAR_LOOP
                
ITS_UPPER       SUBI.B #$37, D4     * SUBSTRUCT 37 TO GET A- F 
                BRA CHAR_LOOP
          
ITS_LOWER       SUBI.B   #$57, D4   * SUBSTRUCT 57 TO GET a-f 
                BRA CHAR_LOOP    
                
TEST_DONE          LEA ALL_TEST_PASS, A1 
                   MOVE.B #14, D0  
                   TRAP #15            


    SIMHALT             ; halt simulator
    
CR  EQU $0D
LF  EQU $0A 
MESSAGE                            DC.B 'WELLCOME TO DISASMBLING ', CR, LF, 0 
                                   DC.B '  ',CR,LF,0 
startingADDRESS                    DC.B 'ENTER STARTING ADRESS: ', CR,LF, 0 
ERROR_LENGTH_TOO_SHORT             DC.B 'STARTING ADRESS IS TOO SMALL ', CR,LF,0 
ERROR_LENGTH_TOO_LONG              DC.B 'STARTING ADRESS IS TOO LONG ', CR, LF, 0
ending_ADRESS                      DC.B 'ENTER ENDING ADRESS ', CR,LF,0 
ERROR_SIZE                         DC.B 'THE ADRESS YOU ENTERED IS NOT VALED',CR,LF,0
ALL_TEST_PASS                      DC.B 'ALL TEST HAS BEEN SUCCSFULLY PASS. ADRESS IS READY TO USE',CR,LF,0 

STARTING                           DS.B  80 
ENDING                             DS.B  80 
MAX_ENDE_ADDRESS                   EQU   $00FFFFFE  
* Put variables and constants here

    END    START        ; last line of source





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
