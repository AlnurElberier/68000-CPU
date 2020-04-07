*--------------------------------------------------------------------------
* Title      : Disassembler Skeleton 
* Written by : You, and you should change all default comments
* Date       :
* 
* Description: This code contains a method for you to use
* with your Disassembler project IO, and a short demo of 
* how to call this method in the body of the "START" code.
* 
* Hints and Tips:
*   -Follow the code commenting convention here for file & method headers
*   -Don't rename this file name (Main.X68)
*   -Don't reorg the start address ($1000)
*   -Don't rename or edit the IO method I've provided you with here
*   -Don't rename the config.cfg file or change the file format: 
*    <Long_StartAddress>\CR\LF
*    <Long_EndAddress>\CR\LF<EOF>
*---------------------------------------------------------------------------
    ORG    $1000    *Don't change this; see hints and tips above
*---------------------------------------------------------------------------
START:
    ***********************************************************
    * Code demo for printing strings to console & file is here
    * Pay close attention to:
    *   (1) the detailed comments, 
    *   (2) how to build a (Callee-Saved) method
    *   (3) how to call that method using JSR (return with RTS)
    ***********************************************************
*    LEA MSG1, A1        ; buffer of chars to write
*    JSR TrapTask13
*    
*    LEA MSG2, A1        ; buffer of chars to write    
*    JSR TrapTask13
*
*    LEA ascii_val, A1
*    JSR AsciiToHex     ;  example of how to convert ascii to hex
*
    **************************************************
    *Your disassembler code goes here
    **************************************************
    
    ;Open config.cfg (trap subtasks 50-59) (this is an IO responsibility if 3 team members)
    ;load start and end address as longs
    
    ;loop from start to end, printing out the instruction or DATA if not recognized 
    ;   use my method below (printStringToFileAndConsole) to print out the individual instruction (or DATA)

   * SIMHALT
    
    *MOVEA  A3,A2
    *MOVE    #1,D2
    *EOR.L   D1,D2
    *SUB.L   D1,D3
    
*----------------------------------------------------------
          * ----------PRINT WELCOME MESSAGE-------
*----------------------------------------------------------

WELLCOME_MESSA   LEA MESSAGE, A1 
                 MOVE.B #14, D0  
                 TRAP #15                
    
READ_A_FILE: 
     LEA        FILENAME,A1
     MOVE.B     #51,D0
     TRAP       #15
     MOVE.L     D1,D3


     LEA        STRING,A1
     MOVE.L     D3,D1
     CLR.L      D2
     MOVE.W     #80,D2
     MOVE.B     #53,D0
     TRAP       #15

     MOVE.B     #56,D0
     TRAP       #15 



    *STARTING ADDRESS = A3
    LEA string, A1
    JSR AsciiToHex
    MOVE.L D7, A3

    ;ENDING ADDRESS = A4
    ADDA.L #2, A1
    JSR AsciiToHex
    MOVE.L D7, A4    
    
    
    
    
    
VALIDATION:
    MOVE.L  A3,D3
    MOVE.L  A4,D4
    JSR     ODD
    JSR     NEGATIVE
    JSR     START_END
    JSR     MAX
    BRA     _OPCODE
    
    
    
ODD:
    BTST #0,D3 
    BNE TEST_ODD_FAIL
    BTST #0,D4
    BNE TEST_ODD_FAIL
    RTS
    
    
TEST_ODD_FAIL       
    LEA     ODD_ADRESS_MES, A1 
    MOVE.B  #14, D0 
    TRAP    #15   
    SIMHALT             ; halt simulator 
    
NEGATIVE:
    CMPI.L  #0,D3
    BLE     LENGTH_TOO_SHORT
    CMPI.L  #0,D4
    BLE     LENGTH_TOO_SHORT
    RTS
    
    
LENGTH_TOO_SHORT   
    LEA     ERROR_LENGTH_TOO_SHORT, A1 
    MOVE.B  #14, D0  
    TRAP    #15 
    SIMHALT             ; halt simulator
    
    
START_END
    CMP.L   D3,D4
    BLT     ERROR 
    RTS
    
ERROR              
    LEA     ERROR_SIZE, A1 
    MOVE.B  #14, D0  
    TRAP    #15  
    SIMHALT             ; halt simulator 
    
MAX
    CMPI.L  #$00FFFFFE,D3
    BGE     ERROR
    CMPI.L  #$00FFFFFE,D3
    BGT     ERROR
    RTS
    
    
PRINT:      
    LEA S_NULL,A5
    JSR LOAD_NULL 
    JSR TrapTask13 
    CLR GOOD_BUFFER 
    LEA (A2),A3
    CMP.L A3,A4 
    BGE _OPCODE 
    BRA END 
            
ERR:
    MOVE.W  A3,D0  
    ROR     #8,D0
    MOVE.B  D0,D3
    JSR     LOAD_DATA_STRING
    ROL     #8,D0
    MOVE.B  D0,D3
    JSR     LOAD_DATA_STRING
    LEA     S_DATA_ERR,A5
    JSR     LOAD_STRING
    CLR     D1
    MOVE    #$2,D1
    LEA     (A3),A2
    JSR     LOAD_ADDRESS_STRING
    BRA     PRINT

   
LOAD_DATA_STRING:
    MOVE    D3,D4                   *COPY D3 TO D4
    ASR     #4,D3                   *ISOLATE FIRST NIBBLE
    JSR     ASCII_HEX_CONVERTER     *CONVERT D3 TO ASCII
    MOVE.B  D3,(A6)+                *APPENDING D3 TO GOOD_BUFFER OR A6
    ANDI    #$0F,D4                 *ISOLATING SECOND NUBBLE
    MOVE    D4,D3                   *D3 = SECOND NIBBLE
    JSR     ASCII_HEX_CONVERTER     *CONVERT D3 TO ASCII
    MOVE.B  D3,(A6)+                *APPENDING
    RTS

    

            
            
END    SIMHALT 
*--------------------------------------------------------------------------------------------------







    MOVE.B  D1,D2
    MOVE.L  D2,D1
    
    CMPI    #$1234,-(A3)
    
















*********************************************************************************
* Method Name: yourDisassemblerFirstMethodHere
* Description: call this method from your code above; see the examples above on
*   how to call methods and use them profusely as you build your final project
*
* Preconditions:  TBA
* Postconditions: TBA
*********************************************************************************



_OPCODE:

    *---------------------------------
    *TESTING AND OUTPUT TO FIND OPCODE
    
    CLR     D0
    CLR     D1
    CLR     D2
    CLR     D3
    CLR     D4
    CLR     D5
    CLR     D6
    CLR     D7
    
    
    
    LEA     GOOD_BUFFER,A6
    MOVE.W  (A3),D1
    
    ANDI    #$F000,D1
    
    CMP.W   #$0000, D1    *OPCODE = 0000
    BEQ     _0
    
    CMP.W   #$1000, D1    *OPCODE = 0001
    BEQ     _1
    
    CMP.W   #$2000, D1    *OPCODE = 0010
    BEQ     _2
    
    CMP.W   #$3000, D1    *OPCODE = 0011
    BEQ     _3
    
    CMP.W   #$4000, D1    *OPCODE = 0100
    BEQ     _4
    
    CMP.W   #$5000, D1    *OPCODE = 0101
    BEQ     _5
    
    CMP.W   #$6000, D1    *OPCODE = 0110
    BEQ     _6
    
    CMP.W   #$7000, D1    *OPCODE = 0111
    BEQ     _7
    
    CMP.W   #$8000, D1    *OPCODE = 1000
    BEQ     _8
    
    CMP.W   #$9000, D1    *OPCODE = 1001
    BEQ     _9
    
    CMP.W   #$A000, D1    *OPCODE = 1010
    BEQ     _A
    
    CMP.W   #$B000, D1    *OPCODE = 1011
    BEQ     _B
    
    CMP.W   #$C000, D1    *OPCODE = 1100
    BEQ     _C
    
    CMP.W   #$D000, D1    *OPCODE = 1101
    BEQ     _D
    
    CMP.W   #$E000, D1    *OPCODE = 1110
    BEQ     _E
    
    CMP.W   #$F000, D1    *OPCODE = 1111
    BEQ     _F
    
    

_0: *[BCLR, ORI, CMPI]
    MOVE.W      (A3),D2
    ANDI.W      #$0F00,D2
    
    CMP.W       #$0800,D2
    BEQ         BCLR_LOAD
    
    CMP.W       #$0000,D2
    BEQ         ORI_LOAD
    
    CMP.W       #$0C00,D2
    BEQ         CMPI_LOAD
    
    MOVE.W      (A3),D2
    ANDI.W      #$0100,D2
    
    CMP.W       #$0100,D2
    BEQ         BCLR_LOAD

    
    BRA         ERR

    
_1: *[MOVE.B]
    BRA         MOVEB_LOAD     



_2: *[MOVE.L, MOVEA,L]
    MOVE.W      (A3),D2
    ANDI.W      #$01C0,D2
    
    CMP.W       #$0080,D2
    BEQ         MOVEAL_LOAD
    
    BRA         MOVEL_LOAD




_3: *[MOVE.W, MOVEA.W]
    MOVE.W      (A3),D2
    ANDI.W      #$01C0,D2
    
    CMP.W       #$0080,D2
    BEQ         MOVEAW_LOAD
    
    BRA         MOVEW_LOAD

    
    
    
    
_4: *[MOVEM, LEA, NEG, JSR, RTS]
    MOVE.W      (A3),D2
    ANDI.W      #$0FC0,D2
    
    CMP.W       #$0E40, D2
    BEQ         RTS_LOAD
    
    CMP.W       #$0E80, D2
    BEQ         JSR_LOAD
    
    MOVE.W      (A3),D2
    ANDI.W      #$0100,D2
    
    CMP.W       #$0100,D2
    BEQ         LEA_LOAD
    
    MOVE.W      (A3),D2
    ANDI.W      #$0800,D2
    
    CMP.W       #$0000,D2
    BEQ         NEG_LOAD
    
    CMP.W       #$0800,D2
    BEQ         MOVEM_LOAD
    
    BRA         ERR
    
    
    
_5: *[SUBQ]
    BRA         SUBQ_LOAD
    


_6: *[BCC(BCS-BVC), BRA]
    MOVE.W      (A3),D2
    ANDI.W      #$0F00,D2
    
    CMP.W       #$0000,D2
    BEQ         BRA_LOAD
    
    CMP.W       #$0500,D2
    BEQ         BCS_LOAD

    CMP.W       #$0C00,D2
    BEQ         BGE_LOAD
    
    CMP.W       #$0D00,D2
    BEQ         BLT_LOAD
    
    CMP.W       #$0800,D2
    BEQ         BVC_LOAD
    
    BRA        ERR


    
_7: *[XXXXXXXXXX]
    BRA        ERR
    
_8: *[DIVS, OR]
    MOVE.W      (A3),D2
    ANDI.W      #$00C0, D2
    
    CMP.W       #$00C0, D2
    BEQ         DIVS_LOAD
    
    BRA         OR_LOAD
    
    
_9: *[SUB]
    BRA         SUB_LOAD

_A: *[XXXXXXXXXX]
    BRA         ERR

_B: *[EOR, CMP]
    MOVE.W      (A3),D2
    ANDI.W      #$0100,D2
    
    CMP.W       #$0100,D2
    BEQ         EOR_LOAD
    
    CMP.W       #$0000,D2
    BEQ         CMP_LOAD
    
    BRA         ERR


_C: *[MULS]
    BRA         MULS_LOAD

_D: *[ADD, ADDA]
    MOVE.W      (A3),D2
    ANDI.W      #$00C0,D2
    
    CMP.W       #$00C0,D2
    BEQ         ADDA_LOAD
    
    BRA         ADD_LOAD
    
    
    

_E: *[LSR, LSL, ASR, ASL, ROL, ROR]
    MOVE.W      (A3),D2
    ANDI        #$00C0,D2
    
    CMPI        #$00C0,D2
    BEQ         SHIFT_MEMORY
    
    MOVE.W      (A3),D2
    ANDI        #$0118,D2
    
    CMPI        #$0000,D2
    BEQ         ASR_LOAD_I
    
    CMPI        #$0100,D2
    BEQ         ASL_LOAD_I

    CMPI        #$0008,D2
    BEQ         LSR_LOAD_I

    CMPI        #$0108,D2
    BEQ         LSL_LOAD_I

    CMPI        #$0018,D2
    BEQ         ROR_LOAD_I

    CMPI        #$0118,D2
    BEQ         ROL_LOAD_I

    BRA         ERR
 
    
    
    
    
SHIFT_MEMORY:
    MOVE        (A3),D2
    ANDI        #$0F00,D2
    
    CMPI        #$0000,D2
    BEQ         ASR_LOAD_M
    
    CMPI        #$0100,D2
    BEQ         ASL_LOAD_M

    CMPI        #$0200,D2
    BEQ         LSR_LOAD_M
    
    CMPI        #$0300,D2
    BEQ         LSL_LOAD_M


    CMPI        #$0600,D2
    BEQ         ROR_LOAD_M


    CMPI        #$0700,D2
    BEQ         ROL_LOAD_M

    BRA        ERR    
    
    
_F: *[XXXXXXXXXX]
    BRA         ERR
               
               
               
               
               
BCLR_LOAD:
    LEA     S_BCLR,A5
    JSR     LOAD_STRING
    BRA    _EA_BCLR
    
ORI_LOAD:
    LEA     S_ORI,A5
    JSR     LOAD_STRING
    BRA     _EA_ORI
               
CMPI_LOAD:
    LEA     S_CMPI,A5
    JSR     LOAD_STRING
    BRA     _EA_CMPI

MOVEB_LOAD:
    LEA     S_MOVE,A5
    JSR     LOAD_STRING
    LEA     S_B,A5
    JSR     LOAD_STRING
    BRA     _EA_MOVEB
    
MOVEAL_LOAD:
    LEA     S_MOVEA,A5
    JSR     LOAD_STRING
    LEA     S_L,A5
    JSR     LOAD_STRING
    BRA     _EA_MOVEAL
      
MOVEL_LOAD:
    LEA     S_MOVE,A5
    JSR     LOAD_STRING
    LEA     S_L,A5
    JSR     LOAD_STRING
    BRA     _EA_MOVEL

MOVEAW_LOAD:
    LEA     S_MOVEA,A5
    JSR     LOAD_STRING
    LEA     S_W,A5
    JSR     LOAD_STRING
    BRA     _EA_MOVEAW
      
MOVEW_LOAD:
    LEA     S_MOVE,A5
    JSR     LOAD_STRING
    LEA     S_W,A5
    JSR     LOAD_STRING
    BRA     _EA_MOVEW
    
RTS_LOAD:
    LEA     S_RTS,A5
    JSR     LOAD_STRING
    BRA     _EA_RTS
    
JSR_LOAD:
    LEA     S_JSR,A5
    JSR     LOAD_STRING
    BRA     _EA_JSR 
    
LEA_LOAD:
    LEA     S_LEA,A5
    JSR     LOAD_STRING
    BRA     _EA_LEA

NEG_LOAD:
    LEA     S_NEG,A5
    JSR     LOAD_STRING
    BRA     _EA_NEG
    
MOVEM_LOAD:
    LEA     S_MOVEM,A5
    JSR     LOAD_STRING
    BRA     _EA_MOVEM
    
SUBQ_LOAD:
    LEA     S_SUBQ,A5
    JSR     LOAD_STRING
    BRA     _EA_SUBQ
    
BRA_LOAD
    LEA     S_BRA,A5
    JSR     LOAD_STRING
    BRA     _EA_BRA
    
BCS_LOAD
    LEA     S_BCS,A5
    JSR     LOAD_STRING
    BRA     _EA_BCS

BGE_LOAD
    LEA     S_BGE,A5
    JSR     LOAD_STRING
    BRA     _EA_BGE
    
BLT_LOAD
    LEA     S_BLT,A5
    JSR     LOAD_STRING
    BRA     _EA_BLT
    
BVC_LOAD
    LEA     S_BVC,A5
    JSR     LOAD_STRING
    BRA     _EA_BVC
    
DIVS_LOAD:
    LEA     S_DIVS,A5
    JSR     LOAD_STRING
    BRA     _EA_DIVS
    
OR_LOAD:
    LEA     S_OR,A5
    JSR     LOAD_STRING
    BRA     _EA_OR
    
SUB_LOAD:
    LEA     S_SUB,A5
    JSR     LOAD_STRING
    BRA     _EA_SUB 

EOR_LOAD:
    LEA     S_EOR,A5
    JSR     LOAD_STRING
    BRA     _EA_EOR

CMP_LOAD:
    LEA     S_CMP,A5
    JSR     LOAD_STRING
    BRA     _EA_CMP
    
MULS_LOAD: 
    LEA     S_MULS,A5
    JSR     LOAD_STRING
    BRA     _EA_CMP
    
ADDA_LOAD:
    LEA     S_ADDA,A5
    JSR     LOAD_STRING
    BRA     _EA_ADDA
    
ADD_LOAD:
    LEA     S_ADD,A5
    JSR     LOAD_STRING
    BRA     _EA_ADD

    
ASR_LOAD_I:
    LEA     S_ASR,A5
    JSR     LOAD_STRING
    BRA     _EA_ASR_I
    
ASL_LOAD_I:
    LEA     S_ASL,A5
    JSR     LOAD_STRING
    BRA     _EA_ASL_I


LSR_LOAD_I:
    LEA     S_LSR,A5
    JSR     LOAD_STRING
    BRA     _EA_LSR_I

    
LSL_LOAD_I:
    LEA     S_LSL,A5
    JSR     LOAD_STRING
    BRA     _EA_LSL_I


ROR_LOAD_I:
    LEA     S_ROR,A5
    JSR     LOAD_STRING
    BRA     _EA_ROR_I


ROL_LOAD_I:
    LEA     S_ROL,A5
    JSR     LOAD_STRING
    BRA     _EA_ROL_I

ASR_LOAD_M:
    LEA     S_ASR,A5
    JSR     LOAD_STRING
    BRA     _EA_ASR_M

    
ASL_LOAD_M:
    LEA     S_ASL,A5
    JSR     LOAD_STRING
    BRA     _EA_ASL_M

    

LSR_LOAD_M:
    LEA     S_LSR,A5
    JSR     LOAD_STRING
    BRA     _EA_LSR_M


LSL_LOAD_M:
    LEA     S_LSL,A5
    JSR     LOAD_STRING
    BRA     _EA_LSL_M


ROR_LOAD_M:
    LEA     S_ROR,A5
    JSR     LOAD_STRING
    BRA     _EA_ROR_M
    

ROL_LOAD_M:
    LEA     S_ROL,A5
    JSR     LOAD_STRING
    BRA     _EA_ROL_M
























*********************************************************************************
* Method Name: yourDisassemblerSecondMethodHere
* Description:    TBA
*
* Preconditions:  TBA
* Postconditions: TBA
*********************************************************************************








*********************************************************************************************
_EA_BCLR:  
    LEA     2(A3),A2            *A2 = END OF INSTRUCTION
    MOVE.W  (A3),D3             *D3 = FIRST FOUR HEX BITS
    MOVE.W  D3,D4               *D4 = COPY OF D3
    ANDI    #$0100,D3           *BITMASK TO DISTINGUISH EA MODES
    
    CMP.W   #$0000,D3           *0000 = BCLR_I_M_XN
    BEQ     BCLR_I_M_XN
    BRA     BCLR_D_M_XN         *0100 = BCLR_D_M_XN
    
    
    
    
BCLR_D_M_XN:
    MOVE.W  (A3),D3
    ANDI    #$01C0,D3
    CMPI    #$0180,D3
    BNE     ERR
    MOVE.W  (A3),D3
    LEA     S_SPACE,A5
    JSR     LOAD_STRING
    LEA     S_D,A5              *APPENDING 'D' TO ARRAY
    JSR     LOAD_STRING
    MOVE.W  (A3),D4             *D4 = FIRST FOUR HEX BITS
    JSR     BEGINING_NUMBER_CONVERSION
    LEA     S_COMMA,A5
    JSR     LOAD_STRING
    BRA     BCLR_M_XN           *COMING TO FINISH
    
    
BCLR_I_M_XN:
    MOVE.W  (A3),D3
    ANDI    #$0FC0,D3
    CMPI    #$0880,D3
    BNE     ERR
    MOVE.W  (A3),D3
    LEA     S_SPACE,A5
    JSR     LOAD_STRING
    LEA     S_HASH,A5           *APPENDING '#' TO ARRAY
    JSR     LOAD_STRING         
    LEA     S_DOLLAR,A5         *APPENDING '$' TO ARRAY
    JSR     LOAD_STRING
    MOVE    #2,D1               *STORING COUNT PARAMETER        D2 = 2BYTES
    JSR     LOAD_ADDRESS_STRING *LOADING FIRST INITIAL ADDRESS
    LEA     S_COMMA,A5
    JSR     LOAD_STRING
    BRA     BCLR_M_XN           *COMING TO FINISH
    
BCLR_M_XN:
    MOVE.W  (A3),D3             
    JSR     MODE
    BRA     PRINT
*************************************************
    

*********************************************************************************************
_EA_ORI:
    MOVE.W  (A3),D3
    ANDI    #$0F00,D3
    CMPI    #$0000,D3
    BNE     ERR
    
    LEA     2(A3),A2            *A2 = END OF INSTRUCTION
    MOVE.W  (A3),D3             *D3 = FIRST FOUR HEX BITS
    JSR     I_2S_M_XN
    BRA     PRINT

*************************************************
   
*********************************************************************************************
_EA_CMPI:
    MOVE.W  (A3),D3
    ANDI    #$0F00,D3
    CMPI    #$0C00,D3
    BNE     ERR
    
    LEA     2(A3),A2            *A2 = END OF INSTRUCTION
    MOVE.W  (A3),D3             *D3 = FIRST FOUR HEX BITS
    JSR     I_2S_M_XN
    BRA     PRINT
*************************************************
    

*********************************************************************************************
_EA_NEG:
    MOVE.W  (A3),D3
    ANDI    #$0F00,D3
    CMPI    #$0400,D3
    BNE     ERR
    LEA     2(A3),A2
    MOVE.W  (A3),D3             *D3 = FIRST FOUR HEX BITS
    JSR     SIZE_TWO_BIT
    JSR     MODE
    BRA     PRINT
*************************************************



*********************************************************************************************
_EA_JSR:
    MOVE.W  (A3),D3
    ANDI    #$0FC0,D3
    CMPI    #$0E80,D3
    BNE     ERR
    LEA     S_SPACE,A5
    JSR     LOAD_STRING
    LEA     2(A3),A2
    MOVE.W  (A3),D3             *D3 = FIRST FOUR HEX BITS
    JSR     MODE
    BRA     PRINT
*************************************************  
    
    
*********************************************************************************************  
_EA_RTS:
    LEA     2(A3),A2
    CMPI    #$4E76, D3
    BNE     ERR
    BRA     PRINT
*************************************************


*************************************************************************************************  
_EA_LEA:
    MOVE.W  (A3),D3
    ANDI    #$01C0,D3
    CMPI    #$01C0,D3
    BNE     ERR
    LEA     S_SPACE,A5
    JSR     LOAD_STRING
    LEA     2(A3),A2
    MOVE.W  (A3),D3
    JSR     MODE_LEA
    LEA     S_COMMA,A5
    JSR     LOAD_STRING
    LEA     S_A,A5
    JSR     LOAD_STRING
    JSR     BEGINING_NUMBER_CONVERSION
    BRA     PRINT
    
    
    
MODE_LEA:
    MOVE.W  (A3),D3
    ANDI    #$0038, D3

    CMPI    #$0010, D3
    BEQ     ADDRESS_INDIRECT_MODE

    CMPI    #$0038, D3
    BEQ     IMMEDIATE_MODE_LEA
    
    
IMMEDIATE_MODE_LEA:
    LEA     S_DOLLAR,A5
    JSR     LOAD_STRING
    MOVE.W  (A3),D3
    ANDI    #$0007,D3
    CMP.W   #$0001,D3
    BEQ     IMMEDIATE_LONG
    CMP.W   #$0000,D3
    BEQ     IMMEDIATE_SHORT
    *BRA     ERR
*******************************************

********************************************************************************************* 
_EA_SUBQ:
    MOVE.W  (A3),D3
    ANDI    #$0100,D3
    CMPI    #$0100,D3
    BNE     ERR
    LEA     2(A3),A2
    MOVE.W  (A3),D3             *D3 = FIRST FOUR HEX BITS
    JSR     SIZE_TWO_BIT
    LEA     S_HASH,A5
    JSR     LOAD_STRING
    LEA     S_DOLLAR,A5
    JSR     LOAD_STRING
    JSR     DATA
    LEA     S_COMMA,A5
    JSR     LOAD_STRING
    MOVE.W  (A3),D3
    JSR     MODE
    BRA     PRINT
*******************************************
    
********************************************************************************************* 
_EA_DIVS:
    MOVE.W  (A3),D3
    ANDI    #$01C0,D3
    CMPI    #$01C0,D3
    BNE     ERR
    LEA     2(A3),A2
    MOVE.W  (A3),D3             *D3 = FIRST FOUR HEX BITS
    LEA     S_SPACE,A5
    JSR     LOAD_STRING
    JSR     MODE
    LEA     S_COMMA,A5
    JSR     LOAD_STRING
    LEA     S_D,A5
    JSR     LOAD_STRING
    JSR     BEGINING_NUMBER_CONVERSION
    BRA     PRINT
*******************************************

********************************************************************************************* 
_EA_OR:
    MOVE.W  (A3),D3
    ANDI    #$0100,D3
    CMPI    #$0100,D3
    BNE     ERR
    
    LEA     2(A3),A2
    MOVE.W  (A3),D3             *D3 = FIRST FOUR HEX BITS
    JSR     DN_D_S_M_XN
    BRA     PRINT
*******************************************

********************************************************************************************* 
_EA_SUB:
    LEA     2(A3),A2
    MOVE.W  (A3),D3             *D3 = FIRST FOUR HEX BITS
    JSR     DN_D_S_M_XN
    BRA     PRINT
*******************************************

********************************************************************************************* 
_EA_MULS:
    MOVE.W  (A3),D3
    ANDI    #$01C0,D3
    CMPI    #$01C0,D3
    BNE     ERR
    LEA     2(A3),A2
    MOVE.W  (A3),D3             *D3 = FIRST FOUR HEX BITS
    JSR     DN_D_S_M_XN
    BRA     PRINT
*******************************************

********************************************************************************************* 
_EA_ADD:
    LEA     2(A3),A2
    MOVE.W  (A3),D3             *D3 = FIRST FOUR HEX BITS
    JSR     DN_D_S_M_XN
    BRA     PRINT
*******************************************

********************************************************************************************* 
_EA_ADDA:
    LEA     2(A3),A2
    MOVE.W  (A3),D3             *D3 = FIRST FOUR HEX BITS
    JSR     SIZE_ONE_BIT_BEG
    JSR     MODE
    LEA     S_COMMA,A5
    JSR     LOAD_STRING
    LEA     S_A,A5
    JSR     LOAD_STRING
    JSR     BEGINING_NUMBER_CONVERSION
    BRA     PRINT
*******************************************


















_EA_MOVEB:
    
    MOVE.W  #$2,D1
    LEA     2(A3),A2
    MOVE.W  (A3),D3
    JSR     MODE
    LEA     S_COMMA,A5
    JSR     LOAD_STRING
    JSR     MODE_BEG
    BRA     PRINT


_EA_MOVEW:
    MOVE.W  #$2,D1
    LEA     2(A3),A2
    MOVE.W  (A3),D3
    JSR     MODE
    LEA     S_COMMA,A5
    JSR     LOAD_STRING
    JSR     MODE_BEG
    BRA     PRINT




_EA_MOVEL:
    MOVE.W  #$4,D1
    LEA     2(A3),A2
    MOVE.W  (A3),D3
    JSR     MODE
    LEA     S_COMMA,A5
    JSR     LOAD_STRING
    JSR     MODE_BEG
    BRA     PRINT



_EA_MOVEAW:
    MOVE.W  #$2,D1
    LEA     2(A3),A2
    MOVE.W  (A3),D3
    JSR     MODE
    LEA     S_COMMA,A5
    JSR     LOAD_STRING
    LEA     S_A,A5
    JSR     LOAD_STRING
    JSR     BEGINING_NUMBER_CONVERSION
    BRA     PRINT



_EA_MOVEAL:
    MOVE.W  #$4,D1
    LEA     2(A3),A2
    MOVE.W  (A3),D3
    JSR     MODE
    LEA     S_COMMA,A5
    JSR     LOAD_STRING
    LEA     S_A,A5
    JSR     LOAD_STRING
    JSR     BEGINING_NUMBER_CONVERSION
    BRA     PRINT




_EA_MOVEM:


_EA_BRA:
    BRA     BCC

_EA_BCS:
    BRA     BCC

_EA_BGE:
    BRA     BCC

_EA_BLT:
    BRA     BCC

_EA_BVC:
    BRA     BCC



BCC:
    LEA     S_SPACE,A5
    JSR     LOAD_STRING
    LEA     S_CUR_AD,A5
    JSR     LOAD_STRING
    JSR     DATA_TO_ARRAY
    LEA     1(A3),A2
    CLR     D1
    MOVE.B  #$3,D1
    LEA     S_DISP,A5
    JSR     LOAD_STRING
    JSR     LOAD_ADDRESS_STRING
    BRA     PRINT



DATA_TO_ARRAY
    MOVE.W  A3,D0  
    ROR     #8,D0
    MOVE.B    D0,D3
    JSR     LOAD_DATA_STRING
    ROL     #8,D0
    MOVE.B  D0,D3
    JSR     LOAD_DATA_STRING
    RTS



_EA_CMP:
    MOVE.W  (A3),D3
    ANDI    #$0100,D3
    CMPI    #$0000,D3
    BNE     ERR
    LEA     2(A3),A2
    MOVE.W  (A3),D3             *D3 = FIRST FOUR HEX BITS
    JSR     DN_D_S_M_XN
    BRA     PRINT




_EA_EOR:
    LEA     2(A3),A2
    MOVE.W  (A3),D3             *D3 = FIRST FOUR HEX BITS
    JSR     DN_D_S_M_XN
    BRA     PRINT

_EA_ASR_I:
    MOVE.W  (A3),D3
    ANDI    #$0EC0,D3
    CMPI    #$00C0,D3
    BNE     ERR
    MOVE.W  (A3),D3
    LEA     2(A3),A2
    LEA     S_SPACE,A5
    JSR     LOAD_STRING
    LEA     S_HASH,A5
    JSR     LOAD_STRING
    LEA     S_DOLLAR,A5
    JSR     LOAD_STRING
    JSR     ROTATION
    LEA     S_COMMA,A5
    JSR     LOAD_STRING
    LEA     S_D,A5
    JSR     LOAD_STRING
    JSR     END_NUMBER_CONVERSION
    BRA     PRINT
    
    


_EA_ASL_I:
    MOVE.W  (A3),D3
    ANDI    #$0EC0,D3
    CMPI    #$00C0,D3
    BNE     ERR
    MOVE.W  (A3),D3
    LEA     2(A3),A2
    LEA     S_SPACE,A5
    JSR     LOAD_STRING
    LEA     S_HASH,A5
    JSR     LOAD_STRING
    LEA     S_DOLLAR,A5
    JSR     LOAD_STRING
    JSR     ROTATION
    LEA     S_COMMA,A5
    JSR     LOAD_STRING
    LEA     S_D,A5
    JSR     LOAD_STRING
    JSR     END_NUMBER_CONVERSION
    BRA     PRINT


_EA_LSR_I:
    MOVE.W  (A3),D3
    ANDI    #$0EC0,D3
    CMPI    #$02C0,D3
    BNE     ERR
    MOVE.W  (A3),D3
    LEA     2(A3),A2
    LEA     S_SPACE,A5
    JSR     LOAD_STRING
    LEA     S_HASH,A5
    JSR     LOAD_STRING
    LEA     S_DOLLAR,A5
    JSR     LOAD_STRING
    JSR     ROTATION
    LEA     S_COMMA,A5
    JSR     LOAD_STRING
    LEA     S_D,A5
    JSR     LOAD_STRING
    JSR     END_NUMBER_CONVERSION
    BRA     PRINT


_EA_LSL_I:
    MOVE.W  (A3),D3
    ANDI    #$0EC0,D3
    CMPI    #$02C0,D3
    BNE     ERR
    MOVE.W  (A3),D3
    LEA     2(A3),A2
    ANDI    #$0FC0,D3
    CMPI    #$0880,D3
    BNE     ERR
    LEA     S_SPACE,A5
    JSR     LOAD_STRING
    LEA     S_HASH,A5
    JSR     LOAD_STRING
    LEA     S_DOLLAR,A5
    JSR     LOAD_STRING
    JSR     ROTATION
    LEA     S_COMMA,A5
    JSR     LOAD_STRING
    LEA     S_D,A5
    JSR     LOAD_STRING
    JSR     END_NUMBER_CONVERSION
    BRA     PRINT

_EA_ROL_I:
    MOVE.W  (A3),D3
    ANDI    #$0EC0,D3
    CMPI    #$06C0,D3
    BNE     ERR
    MOVE.W  (A3),D3
    LEA     2(A3),A2
    ANDI    #$0EC0,D3
    CMPI    #$02C0,D3
    BNE     ERR
    LEA     S_SPACE,A5
    JSR     LOAD_STRING
    LEA     S_HASH,A5
    JSR     LOAD_STRING
    LEA     S_DOLLAR,A5
    JSR     LOAD_STRING
    JSR     ROTATION
    LEA     S_COMMA,A5
    JSR     LOAD_STRING
    LEA     S_D,A5
    JSR     LOAD_STRING
    JSR     END_NUMBER_CONVERSION
    BRA     PRINT


_EA_ROR_I:
    MOVE.W  (A3),D3
    ANDI    #$0EC0,D3
    CMPI    #$06C0,D3
    BNE     ERR
    MOVE.W  (A3),D3
    LEA     2(A3),A2
    LEA     S_SPACE,A5
    JSR     LOAD_STRING
    LEA     S_HASH,A5
    JSR     LOAD_STRING
    LEA     S_DOLLAR,A5
    JSR     LOAD_STRING
    JSR     ROTATION
    LEA     S_COMMA,A5
    JSR     LOAD_STRING
    LEA     S_D,A5
    JSR     LOAD_STRING
    JSR     END_NUMBER_CONVERSION
    BRA     PRINT


_EA_ASR_M:
    MOVE.W  (A3),D3
    ANDI    #$0018,D3
    CMPI    #$0000,D3
    BNE     ERR
    MOVE.W  (A3),D3
    LEA     S_SPACE,A5
    JSR     LOAD_STRING
    LEA     2(A3),A2
    JSR     MODE_SHIFT
    BRA     PRINT



_EA_ASL_M:
    MOVE.W  (A3),D3
    ANDI    #$0018,D3
    CMPI    #$0000,D3
    BNE     ERR
    MOVE.W  (A3),D3
    LEA     S_SPACE,A5
    JSR     LOAD_STRING
    LEA     2(A3),A2
    JSR     MODE_SHIFT
    BRA     PRINT


_EA_LSR_M:
    MOVE.W  (A3),D3
    ANDI    #$0018,D3
    CMPI    #$0008,D3
    BNE     ERR
    MOVE.W  (A3),D3
    LEA     S_SPACE,A5
    JSR     LOAD_STRING
    LEA     2(A3),A2
    JSR     MODE_SHIFT
    BRA     PRINT

_EA_LSL_M:
    MOVE.W  (A3),D3
    ANDI    #$0018,D3
    CMPI    #$0008,D3
    BNE     ERR
    MOVE.W  (A3),D3
    LEA     S_SPACE,A5
    JSR     LOAD_STRING
    LEA     2(A3),A2
    JSR     MODE_SHIFT
    BRA     PRINT


_EA_ROR_M:
    MOVE.W  (A3),D3
    ANDI    #$0018,D3
    CMPI    #$0018,D3
    BNE     ERR
    MOVE.W  (A3),D3
    LEA     S_SPACE,A5
    JSR     LOAD_STRING
    LEA     2(A3),A2
    JSR     MODE_SHIFT
    BRA     PRINT


_EA_ROL_M:
    MOVE.W  (A3),D3
    ANDI    #$0018,D3
    CMPI    #$0018,D3
    BNE     ERR
    MOVE.W  (A3),D3
    LEA     S_SPACE,A5
    JSR     LOAD_STRING
    LEA     2(A3),A2
    JSR     MODE_SHIFT
    BRA     PRINT
    
    
    
MODE_SHIFT:
    MOVE.W  (A3),D3
    ANDI.W  #$0280,D3
    CMPI    #$0280,D3
    BEQ    IMMEDIATE_MODE_LEA
    BRA    MODE






ROTATION:
    MOVE.W  (A3),D3
    ANDI    #$0E00,D3
    
    CMPI    #$0000,D3
    BEQ     EIGHT
    
    CMPI    #$0200,D3
    BEQ     ONE
    
    CMPI    #0400,D3
    BEQ     TWO
    
    CMPI    #$0600,D3
    BEQ     THREE
    
    CMPI    #$0800,D3
    BEQ     FOUR

    CMPI    #$0A00,D3
    BEQ     FIVE
    
    CMPI    #$0C00,D3
    BEQ     SIX
    
    CMPI    #$0E00,D3
    BEQ     SEVEN
    
    BRA     ERR



    
    
    
    
    
    

********************************************************************************************* 
DN_D_S_M_XN:
    JSR     SIZE_TWO_BIT
    MOVE.W  (A3),D3
    MOVE.W  D3,D4
    ANDI    #$0100,D4
    
    CMPI    #0000,D4
    BEQ     EA_FIRST
    BRA     DATA_FIRST
    
    
DATA_FIRST:
    LEA     S_D,A5
    JSR     LOAD_STRING
    JSR     BEGINING_NUMBER_CONVERSION
    LEA     S_COMMA,A5
    JSR     LOAD_STRING
    JSR     MODE
    RTS
    
EA_FIRST:
    JSR     MODE
    LEA     S_COMMA,A5
    JSR     LOAD_STRING
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
    LEA     S_COMMA,A5
    JSR     LOAD_STRING
    MOVE    D2,D1               *RESETTING COUNT
    JSR     MODE
    *STORING COUNT PARAMETER IN SIZE METHOD
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
    MOVE.W  (A3),D3
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
MODE_BEG:
    MOVE.W  (A3),D3
    ANDI    #$01C0, D3
    
    CMPI    #$0000, D3
    BEQ     DATA_REGISTER_MODE_BEG
    
    CMPI    #$0040, D3
    BEQ     ADDRESS_DIRECT_MODE_BEG
    
    CMPI    #$0080, D3
    BEQ     ADDRESS_INDIRECT_MODE
    
    CMPI    #$00C0, D3
    BEQ     ADDRESS_POST_INCREMENT_MODE


    CMPI    #$0100, D3
    BEQ     ADDRESS_PRE_DECREMENT_MODE


    CMPI    #$01C0, D3
    BEQ     IMMEDIATE_MODE
    
    BRA     ERR
    
    
***********************************************************************
*INPUTS:
*   INSTRRUCTION WITH FORM 0000-0000-0000-0DDD
*   Dn
*OUTPUTS:
*   CORRECT DATA REGISTER APPENDED TO GOODBUFFER
DATA_REGISTER_MODE_BEG:
    LEA     S_D,A5
    JSR     LOAD_STRING
    JSR     BEGINING_NUMBER_CONVERSION
    RTS
    
***********************************************************************
*INPUTS:
*   INSTRRUCTION WITH FORM 0000-0000-0000-1AAA
*   An
*OUTPUTS:
*   CORRECT DATA REGISTER APPENDED TO GOODBUFFER
ADDRESS_DIRECT_MODE_BEG:
    LEA     S_A,A5
    JSR     LOAD_STRING
    JSR     BEGINING_NUMBER_CONVERSION
    RTS

***********************************************************************
*INPUTS:
*   INSTRRUCTION WITH FORM 0000-0000-0001-0AAA
*   (An)
*OUTPUTS:
*   CORRECT DATA REGISTER APPENDED TO GOODBUFFER
ADDRESS_INDIRECT_MODE_BEG:
    LEA     S_OPEN_BRACKET,A5
    JSR     LOAD_STRING
    LEA     S_A,A5
    JSR     LOAD_STRING
    JSR     BEGINING_NUMBER_CONVERSION
    LEA     S_CLOSED_BRACKET,A5
    JSR     LOAD_STRING
    RTS     

***********************************************************************
*INPUTS:
*   INSTRRUCTION WITH FORM 0000-0000-0001-1AAA
*   (An)+
*OUTPUTS:
*   CORRECT DATA REGISTER APPENDED TO GOODBUFFER
ADDRESS_POST_INCREMENT_MODE_BEG:
    LEA     S_OPEN_BRACKET,A5
    JSR     LOAD_STRING
    LEA     S_A,A5
    JSR     LOAD_STRING
    JSR     BEGINING_NUMBER_CONVERSION
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
ADDRESS_PRE_DECREMENT_MODE_BEG:
    LEA     S_MINUS,A5
    JSR     LOAD_STRING
    LEA     S_OPEN_BRACKET,A5
    JSR     LOAD_STRING
    LEA     S_A,A5
    JSR     LOAD_STRING
    JSR     BEGINING_NUMBER_CONVERSION
    LEA     S_CLOSED_BRACKET,A5
    JSR     LOAD_STRING
    RTS


***********************************************************************
*INPUTS:
*   INSTRRUCTION WITH FORM 0000-0000-0011-1XXX
*   #XXXX(-XXXX)
*OUTPUTS:
*   CORRECT DATA REGISTER APPENDED TO GOODBUFFER
IMMEDIATE_MODE_BEG:
    LEA     S_HASH,A5
    JSR     LOAD_STRING
    LEA     S_DOLLAR,A5
    JSR     LOAD_STRING
    MOVE.W  (A3),D3
    ANDI    #$0E00,D3
    CMP.W   #$0200,D3
    BEQ     IMMEDIATE_LONG
    CMP.W   #$0000,D3
    BEQ     IMMEDIATE_SHORT

    
***********************************************************************
*INPUTS:
*   INSTRRUCTION WITH FORM 0000-0000-0011-1000
*   #XXXX
*OUTPUTS:
*   CORRECT DATA REGISTER APPENDED TO GOODBUFFER
IMMEDIATE_SHORT_BEG:
    MOVE    #2,D1
    JSR     LOAD_ADDRESS_STRING
    MOVE    #2,D1
    RTS

***********************************************************************
*INPUTS:
*   INSTRRUCTION WITH FORM 0000-0000-0011-1001
*   #XXXX-XXXX
*OUTPUTS:
*   CORRECT DATA REGISTER APPENDED TO GOODBUFFER
IMMEDIATE_LONG_BEG:
    MOVE    #4,D1
    JSR     LOAD_ADDRESS_STRING
    MOVE    #4,D1
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
    MOVE.W  (A3),D3
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
    JSR     LOAD_STRING
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
    LEA     S_A,A5
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
    LEA     S_A,A5
    JSR     LOAD_STRING
    JSR     END_NUMBER_CONVERSION
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
    LEA     S_A,A5
    JSR     LOAD_STRING
    JSR     END_NUMBER_CONVERSION
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
    LEA     S_DOLLAR,A5
    JSR     LOAD_STRING
    MOVE.W  (A3),D3
    ANDI    #$0007,D3
    CMP.W   #$0001,D3
    BEQ     IMMEDIATE_LONG
    CMP.W   #$0000,D3
    BEQ     IMMEDIATE_SHORT
    CMP.W   #$0004,D3
    BEQ     IMMEDIATE

    
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
    
IMMEDIATE:
    JSR     LOAD_ADDRESS_STRING
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
    LEA     S_B,A5
    JSR     LOAD_STRING
    MOVE    #$1,D1
    RTS
********************************************************
*OUTPUTS:
*   APPENDS '.W ' SIZE AT THE END OF THE GOODBUFFER
********************************************************
WORD_SIZE:
    LEA     S_W,A5
    JSR     LOAD_STRING
    MOVE    #$2,D1
    RTS
********************************************************
*OUTPUTS:
*   APPENDS '.L ' SIZE AT THE END OF THE GOODBUFFER
********************************************************
LONG_SIZE:
    LEA     S_L,A5
    JSR     LOAD_STRING
    MOVE    #$4,D1
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
    CLR     D4
    MOVE.W  (A3),D4
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
    CLR     D4
    MOVE.W  (A3),D4
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
    LEA     S_ZERO ,A5 
    JSR     LOAD_STRING
    RTS 
    
*************************************************************   
*OUTPUTS:
*   APPENDS '1' AT THE END OF THE GOODBUFFER
********************************************
ONE:
    LEA     S_ONE , A5 
    JSR     LOAD_STRING
    RTS 
    
*************************************************************   
*OUTPUTS:
*   APPENDS '2' AT THE END OF THE GOODBUFFER
********************************************
TWO:
    LEA     S_TWO , A5 
    JSR     LOAD_STRING
    RTS 

*************************************************************   
*OUTPUTS:
*   APPENDS '3' AT THE END OF THE GOODBUFFER
********************************************
THREE:
    LEA     S_THREE , A5 
    JSR     LOAD_STRING
    RTS 

*************************************************************   
*OUTPUTS:
*   APPENDS '4' AT THE END OF THE GOODBUFFER
********************************************
FOUR:
    LEA     S_FOUR , A5 
    JSR     LOAD_STRING
    RTS 

*************************************************************   
*OUTPUTS:
*   APPENDS '5' AT THE END OF THE GOODBUFFER
********************************************
FIVE:
    LEA     S_FIVE , A5 
    JSR     LOAD_STRING
    RTS 

*************************************************************   
*OUTPUTS:
*   APPENDS '6' AT THE END OF THE GOODBUFFER
********************************************
SIX:
    LEA     S_SIX , A5 
    JSR     LOAD_STRING
    RTS 

*************************************************************   
*OUTPUTS:
*   APPENDS '7' AT THE END OF THE GOODBUFFER
********************************************
SEVEN:
    LEA     S_SEVEN , A5 
    JSR     LOAD_STRING
    RTS 
    
*************************************************************   
*OUTPUTS:
*   APPENDS '7' AT THE END OF THE GOODBUFFER
********************************************
EIGHT: 
    LEA     S_EIGHT,A5
    JSR     LOAD_STRING
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
    MOVE.B  (A2)+,D3                *D3 = FIRST TWO BITS OF #A
    MOVE    D3,D4                   *COPY D3 TO D4
    ASR     #4,D3                   *ISOLATE FIRST NIBBLE
    JSR     ASCII_HEX_CONVERTER     *CONVERT D3 TO ASCII
    MOVE.B  D3,(A6)+                *APPENDING D3 TO GOOD_BUFFER OR A6
    ANDI    #$0F,D4                 *ISOLATING SECOND NUBBLE
    MOVE    D4,D3                   *D3 = SECOND NIBBLE
    JSR     ASCII_HEX_CONVERTER     *CONVERT D3 TO ASCII
    MOVE.B  D3,(A6)+                *APPENDING 
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
    CLR     D0
    MOVE.B  (A5),D0
    CMPI    #$00,D0
    BEQ     SKIP
    MOVE.B  (A5)+,(A6)+
    
SKIP:    
    BNE     LOAD_STRING
    LEA     $0, A5
    RTS
**********************************************************************************************
**********************************************************************************************


LOAD_NULL:
    MOVE.B  (A5)+,(A6)+ 
    BNE     LOAD_STRING
    LEA     $0, A5
    RTS





















*********************************************************************************
* Method Name: TrapTask13
* Description: Creates a file if none exists, and appends bytes to that file
*   while also echoing the written bytes to the screen.  You shouldn't need to
*   change this code.
*
* Calling Convention: Callee-Saved 
*
* Preconditions & Method Input:
*   A1 points to the null-terminated buffer to write (newline will be added for you)
*
* Postconditions & Output:
*   ALL files that were previously open will be CLOSED (FileIDs will be invalid)
*   See 'Output.txt' in directory for the results, also piped to the console
*
*
*  A2 holds a pointer to null terminated string to write (input)
*  A3 points to the null-terminated file name
*  D3 holds the number of bytes already in the file to write
*
*  D5 holds number of bytes to write
********************************************************************************
toSave REG D0-D5/A2-A3
TrapTask13:
    *******************************************************************
    * Method initialization, regsiter spilling, parameter saving, etc.
    *******************************************************************
    LEA GOOD_BUFFER, A1 
    MOVEM.L toSave, -(SP)   ;  Callee-Saved, so save and restore     
      
    MOVEA.L A1, A2 ; save this buffer to write
    LEA outFilename, A3  ; save this for later, too
      
    move #50,d0   
    trap #15 ; close all files, suggested to begin any IO 
    *******************************************************************
    * End Method Init
    *******************************************************************

    ******************************************************************************************
    * Calculate the number of bytes to write by searching for the null in the target buffer A0
    ******************************************************************************************
    CLR.L D5 *D5 is now the number of bytes to write
nullLoop:
    MOVE.B (A1)+, D0
    CMPI.B #0,D0  * compare to null
    BEQ findNullLoopDone
    ADDI.W #1, D5
    BRA nullLoop
    
findNullLoopDone:
    MOVEA.L A3, A1 * reset A1 so it points to the file to write to (to open, next)
    
    ;check if file exists, and open with task 51 if so, otherwise 52
    ;(precondition here is A1 points to the null-terminated filename )
    MOVE.B #51, D0      ;open file (task 51 is existing, 52 is new)
    trap #15
      
    if.w D0 <NE> #0 then.s         ; if file error (404, not found)
        MOVE.B #52, D0             ; open new file (52 is new)
        trap #15
    endi
    
    ********************************************************************************************************* 
    * Seek to END of FILE by counting the number of bytes, closing, reopening, then seeking.
    *    (first, count number of bytes already in the file to obtain seek position)
    *********************************************************************************************************
    Clr.L D3   ;TODO: reg save, D3 is now our count of bytes read
    MOVE.L #1, D2 ; read one byte at a time
    LEA byteRead, A1
    
countLoop:
    MOVE.B #53, D0 ; try to read one byte (TODO: move out of loop)
    trap #15
    
    CMPI.W #1,D0  ;1 == EOF
    BEQ countDone
    ADDI #1, D3
    BRA countLoop
    
countDone:    
    * close this file
     move #56,d0  
     trap #15 
     
     * reopen the target file
     MOVE.L A3,A1
     MOVE #51, D0
     trap #15
     
    * seek to right position, then continue with writing
    MOVE.L D3, D2 ; move the number of bytes found in the file to D2
    MOVE #55, D0  ; position file task
    trap #15

    ******************************************************************************
    * Actually write the buffer to the file, after caculating the number of bytes 
    *  to write and after seeking to the right location in the file for append
    ******************************************************************************

    MOVE.L D5, D2 ; restore this for the actually writing the buffer 
    ; assumes A0 hasnt changed since handed to this method      
    MOVEA.L A2, A1 ; load the address of the buffer we want to write to disk
    ; assumes file ID is still stored in D1.L  
    MOVE.B #54, D0 ; subtask 54 is write to open file (append, or?), assumes D2 holds # of bytes
    trap #15

    ; add a newline to the file output
    LEA NEWLINE, A1
    MOVE.B #54, D0 
    MOVE.B #2,D2  ; kills # of bytes to write from input param
    trap #15
    
    ; finally, close only this file
    MOVE.B #56, D0 ; close file task
    trap #15
  
    ; report to screen
    MOVEA.L A2, A1 ; load the address of the buffer we want to write to disk & screen
    MOVE.B #13, D0
    trap #15
      
    ; restore context
    MOVEM.L (SP)+, toSave
    
    RTS
    
    
*----------------------------------------------------------------------------------
* Method Name: AsciiToHex
* Written by : Berger, Modified by Nash
* Date       : 3/1/2019
* Description: Converts chars '0'-'9' and 'a'-'f' to 0-9,a-F
*              Transforms/unpacks 8 chars (8b each) pointed to by A1 into 
*              its (4b each) equivalent hex value 
*  
*  Preconditions & Input
*       A1 (input) points to a memory buffer holding 8 ascii chars (not null-terminated) 
*       This function calls another function (strip_ascii)
*
*  Postconditions & Output
*       D7 (output) holds the converted value 
*       Caller-Saved : D0 is temp, D6 is a loop var
*----------------------------------------------------------------------------------
AsciiToHexRegList REG D0,D6
AsciiToHex     
    MOVEM.L asciiToHexRegList, -(SP)  *save context
    CLR.L D7 * clear our return value
    MOVE.L #8, D6 ; and set up our loop counter

chrLoop
    MOVE.B (A1)+,D0 * Get the first byte
    jsr strip_ascii * Get rid of the ascii code    
    OR.W D0,D7 * Load the bits into D7
    
    subI.B #1,D6  *decrement our loop variable
    BEQ chrDone   *skip shifting if we are done
    
    ASL.L #4,D7 * shift left 4 bits to prepare for next byte
    BRA chrLoop

chrDone
    MOVEM.L (SP)+,asciiToHexRegList 
    RTS


**********************************************************************
* SUBROUTINE: strip_ascii
* remove the ascii code from the digits 0-9,a-f, or A-F
* Input Parameters: <D0> = ascii code
*
* Return parameters: D0.B = number 0...F, returned as 00...0F
* Registers used internally: D0
* Assumptions: D0 contains $30-$39, $41-$46 or $61-66
*
***********************************************************************
strip_ascii
      CMP.B #$39,D0 * Is it in range of 0-9?
      BLE sub30 * Its a number
      CMP.B #$46,D0 * Is is A...F?
      BLE sub37 * Its A...F
      SUB.B #$57,D0 * Its a...f
      BRA ret_sa * Go back
sub37 SUB.B #$37,D0 * Strip 37
      BRA ret_sa * Go back
sub30 SUB.B #$30,D0 * Strip 30
ret_sa RTS * Go back

    
* Required variables and constants go here for your Disassembler
CR                  EQU $0D
LF                  EQU $0A
NEWLINE             DC.B CR,LF,0  
MSG1                DC.B 'MOVE.L D4,D5',0
MSG2                DC.B 'ADD.B D0,D1',0
outFilename         DC.B 'Output.txt',0
byteRead            DS.B 1
ascii_val           DC.B $31,$41,$30,$30,$31,$41,$30,$30 * Test value $1A001A00




S_ADD     DC.B        '  ADD',0
S_ADDA    DC.B        '  ADDA',0
S_ASL     DC.B        '  ASL',0
S_ASR     DC.B        '  ASR',0
S_BCS     DC.B        '  BCS',0
S_BGE     DC.B        '  BGE',0
S_BLT     DC.B        '  BLT',0
S_BVC     DC.B        '  BVC',0
S_BCLR    DC.B        '  BCLR',0
S_BRA     DC.B        '  BRA',0
S_CMP     DC.B        '  CMP',0
S_CMPI    DC.B        '  CMPI',0
S_OCDATA  DC.B        '  DATA',0
S_DIVS    DC.B        '  DIVS',0
S_EOR     DC.B        '  EOR',0
S_JSR     DC.B        '  JSR',0
S_LEA     DC.B        '  LEA',0
S_LSL     DC.B        '  LSL',0
S_LSR     DC.B        '  LSR',0
S_MOVE    DC.B        '  MOVE',0
S_MOVEA   DC.B        '  MOVEA',0
S_MOVEM   DC.B        '  MOVEM',0
S_MULS    DC.B        '  MULS',0
S_NEG     DC.B        '  NEG',0
S_NOP     DC.B        '  NOP',0
S_OR      DC.B        '  OR',0
S_ORI     DC.B        '  ORI',0
S_ROL     DC.B        '  ROL',0
S_ROR     DC.B        '  ROR',0
S_RTS     DC.B        '  RTS',0
S_SUB     DC.B        '  SUB',0
S_SUBQ    DC.B        '  SUBQ',0
S_COMMA     DC.B        ',',0
S_PLUS      DC.B        '+',0
S_MINUS     DC.B        '-',0
S_SLASH     DC.B        '/',0
S_SPACE     DC.B        ' ',0
S_CUR_AD    DC.B        'CURRENT ADDRESS: $',0
S_DISP      DC.B        ' DISPLACEMENT: #$',0




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
S_NULL              DC.B        '',0
S_DATA_ERR          DC.B        '    DATA    ',0

fileName         DC.B 'Config.cfg',0
STATING_BUFFER   DS.B      10 
ENDING_BUFFER    DS.B      10 
BUFFER           DS.B      80
FILE_SIZE        DC.B      80







*CR  EQU $0D
*LF  EQU $0A 
*NEWLINE                            DC.B CR,LF,0 
MESSAGE                            DC.B 'WELLCOME TO DISASMBLING ', CR, LF, 0 
                                   DC.B '  ',CR,LF,0 
startingADDRESS                    DC.B 'ENTER STARTING ADRESS: ', CR,LF, 0 
ERROR_LENGTH_TOO_SHORT             DC.B 'STARTING ADRESS IS TOO SMALL ', CR,LF,0 
ERROR_LENGTH_TOO_LONG              DC.B 'STARTING ADRESS IS TOO LONG ', CR, LF, 0
ending_ADRESS                      DC.B 'ENTER ENDING ADRESS ', CR,LF,0 
ERROR_SIZE                         DC.B 'THE ADRESS YOU ENTERED IS NOT VALED',CR,LF,0
ALL_TEST_PASS                      DC.B 'ALL TEST HAS BEEN SUCCSFULLY PASS. ADRESS IS READY TO USE',CR,LF,0 
ODD_ADRESS_MES                     DC.B 'OPPS! YOU ENTERED an ODD ADRESS',CR,LF,0  
*outFilename                        DC.B 'Output.txt',0
*byteRead                           DS.B 1 
STARTING                           DS.B  80 
ENDING                             DS.B  80  

GOOD_BUFFER     DS.B        100
STRING          DS.B        80


   END    START        ; last line of source








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
