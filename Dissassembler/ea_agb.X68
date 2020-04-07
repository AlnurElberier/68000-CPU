*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program
    
    
    NEG.W   D0
    ORI.B     #24, D0
    *BCLR    #$12, $1989234
    MOVEA   #$1000, A3 
    LEA     GOOD_BUFFER, A6
    
    *A2 = ENDING ADDRESS
    
    
*******************************************************************************************  
_EA_BCLR:
    LEA     2(A3),A2            *A2 = END OF INSTRUCTION
    MOVE.W  (A3),D3             *D3 = FIRST FOUR HEX BITS
    MOVE.W  D3,D4               *D4 = COPY OF D3
    ANDI    #$0100,D3           *BITMASK TO DISTINGUISH EA MODES
    
    CMP.W   #$0000,D3           *0000 = BCLR_I_M_XN
    BEQ     BCLR_I_M_XN
    BRA     BCLR_D_M_XN         *0100 = BCLR_D_M_XN
    
    
    
BCLR_D_M_XN:
    LEA     S_D,A5              *APPENDING 'D' TO ARRAY
    JSR     LOAD_STRING
    MOVE.W  (A3),D4             *D4 = FIRST FOUR HEX BITS
    JSR     BEGINING_NUMBER_CONVERSION
    BRA     BCLR_M_XN           *COMING TO FINISH
    
    
BCLR_I_M_XN:
    LEA     S_HASH,A5           *APPENDING '#' TO ARRAY
    JSR     LOAD_STRING         
    LEA     S_DOLLAR,A5         *APPENDING '$' TO ARRAY
    JSR     LOAD_STRING
    MOVE    #2,D1               *STORING COUNT PARAMETER        D2 = 2BYTES
    JSR     LOAD_ADDRESS_STRING *LOADING FIRST INITIAL ADDRESS
    BRA     BCLR_M_XN           *COMING TO FINISH
    
BCLR_M_XN:
    MOVE.W  (A3),D3             
    JSR     MODE
*************************************************
    

*********************************************************************************************
_EA_ORI:
    LEA     2(A3),A2            *A2 = END OF INSTRUCTION
    MOVE.W  (A3),D3             *D3 = FIRST FOUR HEX BITS
    JSR     I_2S_M_XN
*************************************************
   
*********************************************************************************************
_EA_CMPI:
    LEA     2(A3),A2            *A2 = END OF INSTRUCTION
    MOVE.W  (A3),D3             *D3 = FIRST FOUR HEX BITS
    JSR     I_2S_M_XN
*************************************************
    

*********************************************************************************************
_EA_NEG:
    LEA     2(A3),A2
    MOVE.W  (A3),D3             *D3 = FIRST FOUR HEX BITS
    JSR     SIZE_TWO_BIT
    JSR     MODE
*************************************************



*********************************************************************************************
_EA_JSR:
    LEA     2(A3),A2
    MOVE.W  (A3),D3             *D3 = FIRST FOUR HEX BITS
    JSR     MODE
*************************************************  
    
    
*********************************************************************************************  
_EA_RTS:
    LEA     2(A3),A2
    CMPI    #$4E76, D3
    *BNE     ERR
*************************************************


*********************************************************************************************  
_EA_LEA:
    LEA     2(A3),A2
    MOVE.W  (A3),D3
    LEA     S_A,A5
    JSR     LOAD_STRING
    JSR     BEGINING_NUMBER_CONVERSION
    JSR     MODE
*************************************************


********************************************************************************************* 
_EA_SUBQ:
    LEA     2(A3),A2
    MOVE.W  (A3),D3             *D3 = FIRST FOUR HEX BITS
    JSR     SIZE_TWO_BIT
    LEA     S_HASH,A5
    JSR     LOAD_STRING
    LEA     S_DOLLAR,A5
    JSR     LOAD_STRING
    JSR     DATA
    MOVE.W  (A3),D3
    JSR     MODE
*******************************************
    
********************************************************************************************* 
_EA_DIVS:
    LEA     2(A3),A2
    MOVE.W  (A3),D3             *D3 = FIRST FOUR HEX BITS
    LEA     S_D,A5
    JSR     LOAD_STRING
    JSR     MODE
*******************************************

********************************************************************************************* 
_EA_OR:
    LEA     2(A3),A2
    MOVE.W  (A3),D3             *D3 = FIRST FOUR HEX BITS
    JSR     DN_D_S_M_XN
*******************************************

********************************************************************************************* 
_EA_SUB:
    LEA     2(A3),A2
    MOVE.W  (A3),D3             *D3 = FIRST FOUR HEX BITS
    JSR     DN_D_S_M_XN
*******************************************

********************************************************************************************* 
_EA_MULS:
    LEA     2(A3),A2
    MOVE.W  (A3),D3             *D3 = FIRST FOUR HEX BITS
    JSR     DN_D_S_M_XN
*******************************************

********************************************************************************************* 
_EA_ADD:
    LEA     2(A3),A2
    MOVE.W  (A3),D3             *D3 = FIRST FOUR HEX BITS
    JSR     DN_D_S_M_XN
*******************************************

********************************************************************************************* 
_EA_ADDA:
    LEA     2(A3),A2
    MOVE.W  (A3),D3             *D3 = FIRST FOUR HEX BITS
    JSR     SIZE_ONE_BIT_BEG
*******************************************






    
    
    
    
    
    

********************************************************************************************* 
DN_D_S_M_XN:
    JSR     SIZE_TWO_BIT
    
    MOVE.W  D3,D4
    ANDI    #$0100,D4
    
    CMPI    #0000,D4
    BEQ     EA_FIRST
    BRA     DATA_FIRST
    
    
DATA_FIRST:
    LEA     S_D,A5
    JSR     LOAD_STRING
    JSR     BEGINING_NUMBER_CONVERSION
    JSR     MODE
    RTS
    
EA_FIRST:
    JSR     MODE
    LEA     S_D,A5
    JSR     LOAD_STRING
    JSR     BEGINING_NUMBER_CONVERSION
    RTS
*******************************************

    
    









I_2S_M_XN:
    JSR     SIZE_TWO_BIT
    LEA     S_HASH,A5           *APPENDING '#' TO ARRAY
    JSR     LOAD_STRING         
    LEA     S_DOLLAR,A5         *APPENDING '$' TO ARRAY
    JSR     LOAD_STRING
    MOVE    D1,D2               *RESETTING COUNT
    JSR     LOAD_ADDRESS_STRING *LOADING FIRST INITIAL ADDRESS
    MOVE    D2,D1               *RESETTING COUNT
    JSR     MODE
    *STORING COUNT PARAMETER IN SIZE METHOD
    JSR     MODE
    RTS





    
**********************************************************************************************
**********************************************************************************************
*INPUTS:
*   D3 = FIRST FOUR BITS OF AN INSTRUCTION
*   DATA = 0000-DDD1-0000-0000
*OUTPUTS:
*   APPENDS APPROPRIATE NUMBER AT THE END OF THE ARRAY
******************************************************    
DATA:
    ANDI    #$0F00,D3
    
    CMPI    #$0300,D3
    BEQ     DATA_3
    
    CMPI    #$0500, D3
    BEQ     DATA_5
    
    CMPI    #$0700, D3
    BEQ     DATA_7

    CMPI    #$0900, D3
    BEQ     DATA_9

    CMPI    #$0B00, D3
    BEQ     DATA_B
    
    CMPI    #$0D00, D3
    BEQ     DATA_D
    
    CMPI    #$0F00, D3
    BEQ     DATA_F
    
    CMPI    #$0000, D3
    BEQ     DATA_8

    
*LOADS 1 TO GOODBUFFER
DATA_3:
    LEA     S_ONE,A5
    JSR     LOAD_STRING
    RTS
*LOADS 2 TO GOODBUFFER
DATA_5:
    LEA     S_TWO,A5
    JSR     LOAD_STRING
    RTS
*LOADS 3 TO GOODBUFFER
DATA_7:
    LEA     S_THREE,A5
    JSR     LOAD_STRING
    RTS
*LOADS 4 TO GOODBUFFER
DATA_9:
    LEA     S_FOUR,A5
    JSR     LOAD_STRING
    RTS
*LOADS 5 TO GOODBUFFER
DATA_B:
    LEA     S_FIVE,A5
    JSR     LOAD_STRING
    RTS
*LOADS 6 TO GOODBUFFER
DATA_D:
    LEA     S_SIX,A5
    JSR     LOAD_STRING
    RTS
*LOADS 7 TO GOODBUFFER
DATA_F:
    LEA     S_SEVEN,A5
    JSR     LOAD_STRING
    RTS
*LOADS 8 TO GOODBUFFER
DATA_8:
    LEA     S_EIGHT,A5
    JSR     LOAD_STRING
    RTS
**********************************************************************************************
**********************************************************************************************

















  




  
    
    
    
    
    
    
**********************************************************************************************
**********************************************************************************************
*INPUTS:
*   D3 = FIRST FOUR HEX BITS OF AN INSTRUCTION
*   TAKES IN AN INSTRUCTION OF FORM 0000-0000-00MM-MXXX
*OUTPUTS:
*   APPENDS APPROPRIATE INFO AT THE END OF THE ARRAY
******************************************************
MODE:
    ANDI    #$0038, D3
    
    CMPI    #$0000, D3
    BEQ     DATA_REGISTER_MODE
    
    CMPI    #$0008, D3
    BEQ     ADDRESS_DIRECT_MODE
    
    CMPI    #$0010, D3
    BEQ     ADDRESS_INDIRECT_MODE
    
    CMPI    #$0018, D3
    BEQ     ADDRESS_POST_INCREMENT_MODE


    CMPI    #$0020, D3
    BEQ     ADDRESS_PRE_DECREMENT_MODE


    CMPI    #$0028, D3
    *BEQ     ERR


    CMPI    #$0030, D3
    *BEQ     ERR

    CMPI    #$0038, D3
    BEQ     IMMEDIATE_MODE
    
    
***********************************************************************
*INPUTS:
*   INSTRRUCTION WITH FORM 0000-0000-0000-0DDD
*   Dn
*OUTPUTS:
*   CORRECT DATA REGISTER APPENDED TO GOODBUFFER
DATA_REGISTER_MODE:
    LEA     S_D,A5
    BRA     LOAD_STRING
    JSR     END_NUMBER_CONVERSION
    RTS
    
***********************************************************************
*INPUTS:
*   INSTRRUCTION WITH FORM 0000-0000-0000-1AAA
*   An
*OUTPUTS:
*   CORRECT DATA REGISTER APPENDED TO GOODBUFFER
ADDRESS_DIRECT_MODE:
    LEA     S_A,A5
    JSR     LOAD_STRING
    JSR     END_NUMBER_CONVERSION
    RTS

***********************************************************************
*INPUTS:
*   INSTRRUCTION WITH FORM 0000-0000-0001-0AAA
*   (An)
*OUTPUTS:
*   CORRECT DATA REGISTER APPENDED TO GOODBUFFER
ADDRESS_INDIRECT_MODE:
    LEA     S_OPEN_BRACKET,A5
    JSR     LOAD_STRING
    JSR     END_NUMBER_CONVERSION
    LEA     S_CLOSED_BRACKET,A5
    JSR     LOAD_STRING
    RTS     

***********************************************************************
*INPUTS:
*   INSTRRUCTION WITH FORM 0000-0000-0001-1AAA
*   (An)+
*OUTPUTS:
*   CORRECT DATA REGISTER APPENDED TO GOODBUFFER
ADDRESS_POST_INCREMENT_MODE:
    LEA     S_OPEN_BRACKET,A5
    JSR     LOAD_STRING
    JSR     END_NUMBER_CONVERSION
    LEA     S_CLOSED_BRACKET,A5
    JSR     LOAD_STRING
    LEA     S_CLOSED_BRACKET,A5
    JSR     LOAD_STRING
    LEA     S_PLUS,A5
    JSR     LOAD_STRING
    RTS 

***********************************************************************
*INPUTS:
*   INSTRRUCTION WITH FORM 0000-0000-0001-1AAA
*   -(An)
*OUTPUTS:
*   CORRECT DATA REGISTER APPENDED TO GOODBUFFER
ADDRESS_PRE_DECREMENT_MODE:
    LEA     S_MINUS,A5
    JSR     LOAD_STRING
    LEA     S_OPEN_BRACKET,A5
    JSR     LOAD_STRING
    JSR     END_NUMBER_CONVERSION
    LEA     S_CLOSED_BRACKET,A5
    JSR     LOAD_STRING
    LEA     S_CLOSED_BRACKET,A5
    JSR     LOAD_STRING
    RTS


***********************************************************************
*INPUTS:
*   INSTRRUCTION WITH FORM 0000-0000-0011-1XXX
*   #XXXX(-XXXX)
*OUTPUTS:
*   CORRECT DATA REGISTER APPENDED TO GOODBUFFER
IMMEDIATE_MODE:
    LEA     S_HASH,A5
    JSR     LOAD_STRING
    MOVE.W  (A3),D3
    ANDI    #$0007,D3
    CMP.W   #$0001,D3
    BEQ     IMMEDIATE_LONG
    CMP.W   #$0000,D3
    BEQ     IMMEDIATE_SHORT
    *BRA     ERR

***********************************************************************
*INPUTS:
*   INSTRRUCTION WITH FORM 0000-0000-0011-1001
*   #XXXX-XXXX
*OUTPUTS:
*   CORRECT DATA REGISTER APPENDED TO GOODBUFFER
IMMEDIATE_LONG:
    MOVE    #4,D1
    JSR     LOAD_ADDRESS_STRING
    MOVE    #4,D1
    RTS

***********************************************************************
*INPUTS:
*   INSTRRUCTION WITH FORM 0000-0000-0011-1000
*   #XXXX
*OUTPUTS:
*   CORRECT DATA REGISTER APPENDED TO GOODBUFFER
IMMEDIATE_SHORT
    MOVE    #2,D1
    JSR     LOAD_ADDRESS_STRING
    MOVE    #2,D1
    RTS
**********************************************************************************************
**********************************************************************************************



























**********************************************************************************************
**********************************************************************************************
*INPUTS:
*   D3 = FIRST FOUR HEX BITS OF AN INSTRUCTION
*   TAKES IN AN INSTRUCTION OF FORM 0000-0000-SS00-0000
*OUTPUTS:
*   APPENDS APPROPRIATE SIZE AT THE END OF THE GOODBUFFER
******************************************************
SIZE_TWO_BIT:
    ANDI    #$00C0, D3
    
    CMPI    #$0000, D3
    BEQ     BYTE_SIZE
    
    CMPI    #$0040, D3
    BEQ     WORD_SIZE
    
    CMPI    #$0080, D3
    BEQ     LONG_SIZE
    
********************************************************
*INPUTS:
*   D3 = FIRST FOUR HEX BITS OF AN INSTRUCTION
*   TAKES IN AN INSTRUCTION OF FORM 0000-0001-0000-0000
*OUTPUTS:
*   APPENDS APPROPRIATE SIZE AT THE END OF THE GOODBUFFER
******************************************************
SIZE_ONE_BIT_BEG:
    MOVE.W  (A3),D3
    ANDI    #$0100,D3
    
    CMPI    #$0000,D3
    BEQ     WORD_SIZE
    BRA     LONG_SIZE
    
********************************************************
*INPUTS:
*   D3 = FIRST FOUR HEX BITS OF AN INSTRUCTION
*   TAKES IN AN INSTRUCTION OF FORM 0000-0000-0100-0000
*OUTPUTS:
*   APPENDS APPROPRIATE SIZE AT THE END OF THE GOODBUFFER
******************************************************
SIZE_ONE_BIT_END:
    MOVE.W  (A3),D3
    ANDI    #$0080,D3
    
    CMPI    #$0000,D3
    BEQ     WORD_SIZE
    BRA     LONG_SIZE


********************************************************
*OUTPUTS:
*   APPENDS '.B ' SIZE AT THE END OF THE GOODBUFFER
******************************************************
BYTE_SIZE:
    MOVE    S_B,A5
    JSR     LOAD_STRING
    MOVE    1,D1
    RTS
********************************************************
*OUTPUTS:
*   APPENDS '.W ' SIZE AT THE END OF THE GOODBUFFER
********************************************************
WORD_SIZE:
    MOVE    S_W,A5
    JSR     LOAD_STRING
    MOVE    2,D1
    RTS
********************************************************
*OUTPUTS:
*   APPENDS '.L ' SIZE AT THE END OF THE GOODBUFFER
********************************************************
LONG_SIZE:
    MOVE    S_L,A5
    JSR     LOAD_STRING
    MOVE    4,D1
    RTS
**********************************************************************************************
**********************************************************************************************



























**********************************************************************************************
**********************************************************************************************
*INPUTS:
*   D3 = FIRST FOUR HEX BITS OF AN INSTRUCTION
*   TAKES IN AN INSTRUCTION OF FORM 0000-NNN0-0000-0000
*OUTPUTS:
*   APPENDS APPROPRIATE NUMBER AT THE END OF THE GOODBUFFER
*********************************************************
BEGINING_NUMBER_CONVERSION:
    ANDI    #$0E00,D4
    
    CMPI    #$0000, D4
    BEQ     ZERO
    
    CMPI    #$0200, D4
    BEQ     ONE
    
    CMPI    #$0400, D4
    BEQ     TWO
    
    CMPI    #$0600, D4
    BEQ     THREE
    
    CMPI    #$0800, D4
    BEQ     FOUR

    CMPI    #$0A00, D4
    BEQ     FIVE

    CMPI    #$0C00, D4
    BEQ     SIX

    CMPI    #$0E00, D4
    BEQ     SEVEN
    
*************************************************************
*INPUTS:
*   D3 = FIRST FOUR HEX BITS OF AN INSTRUCTION
*   TAKES IN AN INSTRUCTION OF FORM 0000-0000-0000-0NNN
*OUTPUTS:
*   APPENDS APPROPRIATE NUMBER AT THE END OF THE GOODBUFFER
*************************************************************
END_NUMBER_CONVERSION:
    ANDI    #$0007, D4
    
    CMPI    #$0000, D4
    BEQ     ZERO
    
    CMPI    #$0001, D4
    BEQ     ONE
    
    CMPI    #$0002, D4
    BEQ     TWO
    
    CMPI    #$0003, D4
    BEQ     THREE
    
    CMPI    #$0004, D4
    BEQ     FOUR

    CMPI    #$0005, D4
    BEQ     FIVE

    CMPI    #$0006, D4
    BEQ     SIX

    CMPI    #$0007, D4
    BEQ     SEVEN

*************************************************************   
*OUTPUTS:
*   APPENDS '0' AT THE END OF THE GOODBUFFER
********************************************
ZERO:
    LEA S_ZERO , A5 
    JSR    LOAD_STRING
    RTS 
    
*************************************************************   
*OUTPUTS:
*   APPENDS '1' AT THE END OF THE GOODBUFFER
********************************************
ONE:
    LEA S_ONE , A5 
    JSR    LOAD_STRING
    RTS 
    
*************************************************************   
*OUTPUTS:
*   APPENDS '2' AT THE END OF THE GOODBUFFER
********************************************
TWO:
    LEA S_TWO , A5 
    JSR    LOAD_STRING
    RTS 

*************************************************************   
*OUTPUTS:
*   APPENDS '3' AT THE END OF THE GOODBUFFER
********************************************
THREE:
    LEA S_THREE , A5 
    JSR    LOAD_STRING
    RTS 

*************************************************************   
*OUTPUTS:
*   APPENDS '4' AT THE END OF THE GOODBUFFER
********************************************
FOUR:
    LEA S_FOUR , A5 
    JSR    LOAD_STRING
    RTS 

*************************************************************   
*OUTPUTS:
*   APPENDS '5' AT THE END OF THE GOODBUFFER
********************************************
FIVE:
    LEA S_FIVE , A5 
    JSR LOAD_STRING
    RTS 

*************************************************************   
*OUTPUTS:
*   APPENDS '6' AT THE END OF THE GOODBUFFER
********************************************
SIX:
    LEA  S_SIX , A5 
    JSR  LOAD_STRING
    RTS 

*************************************************************   
*OUTPUTS:
*   APPENDS '7' AT THE END OF THE GOODBUFFER
********************************************
SEVEN:
    LEA  S_SEVEN , A5 
    JSR  LOAD_STRING
    RTS 
**********************************************************************************************
**********************************************************************************************




























   
**********************************************************************************************
**********************************************************************************************
*INPUTS:
*   A2 = ADRESS TO BEGIN READING FROM
*   D1 = COUNT OF BYTES THAT NEED TO BE READ BYTE=1,WORD=2,LONG=4
*OUTPUTS:
*   DESIRED AMOUNT OF ADDRESS BITS ARE CONVERTED TO ASCII
*   ASCII IS THEN APPENDED TO THE END OF GOOD BUFFER
*********************************************************
LOAD_ADDRESS_STRING:    
    MOVE.B  (A2)+,D3
    MOVE    D3,D4
    ANDI    #$0F,D3
    JSR     ASCII_HEX_CONVERTER
    MOVE.B  D3,(A6)+
    ASR     #4,D4
    MOVE    D4,D3
    JSR     ASCII_HEX_CONVERTER
    MOVE.B  D3,(A6)+
    SUBI    #1, D1
    CMP     #0,D1
    BNE     LOAD_ADDRESS_STRING
    RTS
**********************************************************************************************
**********************************************************************************************























**********************************************************************************************
**********************************************************************************************
*INPUTS:
*   D3 = HEX NUMBER THAT NEEDS TO BE CONVERTED
*OUTPUTS:
*   D3 = ASCII REPRESENTATION OF ORIGINAL INPUT
*********************************************************
ASCII_HEX_CONVERTER: 
    CMPI    #$A,D3
    BGE     ADD_37
    ADDI    #$30, D3        *0-9: ADD 30  
    RTS
ADD_37:
    ADDI    #$37,D3         *A-F: ADD 37
    RTS  
**********************************************************************************************
**********************************************************************************************
    
    













    
    
**********************************************************************************************
**********************************************************************************************
*INPUTS:
*   A5 = STRING TO BE LOADED
*   A6 = GOODBUFFER
*OUTPUTS:
*   A6 += A5
*   A6 POINTER INCREMENTED TO END OF GOODBUFFER
*********************************************************    
LOAD_STRING:
    MOVE.B  (A5)+,D7 
    MOVE.B  D7, (A6)+
    BNE     LOAD_STRING
    RTS
**********************************************************************************************
**********************************************************************************************

    
    
    

S_MINUS             DC.B        '-',0
S_PLUS              DC.B        '+',0
S_HASH              DC.B        '#',0
S_DOLLAR            DC.B        '$',0
S_ZERO              DC.B        '0',0
S_ONE               DC.B        '1',0
S_TWO               DC.B        '2',0 
S_THREE             DC.B        '3',0
S_FOUR              DC.B        '4',0
S_FIVE              DC.B        '5',0
S_SIX               DC.B        '6',0
S_SEVEN             DC.B        '7',0
S_EIGHT             DC.B        '8',0
S_D                 DC.B        'D',0
S_A                 DC.B        'A',0
S_OPEN_BRACKET      DC.B        '(',0
S_CLOSED_BRACKET    DC.B        ')',0
S_B                 DC.B        '.B ',0
S_W                 DC.B        '.W ',0
S_L                 DC.B        '.L ',0

GOOD_BUFFER     DS.B        100

 

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source






*~Font name~Courier New~
*~Font size~14~
*~Tab type~1~
*~Tab size~4~
