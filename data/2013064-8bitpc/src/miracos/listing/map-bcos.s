Modules list:
-------------
bcos.o:
    CODE              Offs=000000  Size=000216  Align=00001  Fill=0000
    RODATA            Offs=000000  Size=000000  Align=00001  Fill=0000
    BSS               Offs=000000  Size=000040  Align=00001  Fill=0000
    DATA              Offs=000000  Size=000000  Align=00001  Fill=0000
    ZEROPAGE          Offs=000000  Size=000028  Align=00001  Fill=0000
    NULL              Offs=000000  Size=000000  Align=00001  Fill=0000
    MONVAR            Offs=000000  Size=0000EF  Align=00001  Fill=0000
    COSVAR            Offs=000000  Size=000040  Align=00001  Fill=0000
    ROMBF100          Offs=000000  Size=000300  Align=00001  Fill=0000
    COSBF100          Offs=000000  Size=000B00  Align=00001  Fill=0000
    COSLIB            Offs=000000  Size=0010BE  Align=00001  Fill=0000
    SYSCALL           Offs=000000  Size=000034  Align=00001  Fill=0000
    COSCODE           Offs=000000  Size=0001A8  Align=00001  Fill=0000


Segment list:
-------------
Name                   Start     End    Size  Align
----------------------------------------------------
NULL                  000000  000000  000000  00001
RODATA                000000  000000  000000  00001
ZEROPAGE              000000  000027  000028  00001
ROMBF100              000200  0004FF  000300  00001
MONVAR                000500  0005EE  0000EF  00001
SYSCALL               000600  000633  000034  00001
CODE                  005000  005215  000216  00001
BSS                   005216  005255  000040  00001
DATA                  005300  005300  000000  00001
COSCODE               006000  0061A7  0001A8  00001
COSLIB                0061A8  007265  0010BE  00001
COSVAR                007266  0072A5  000040  00001
COSBF100              007300  007DFF  000B00  00001


Exports list by name:
---------------------
__CODE_LOAD__             005000  LA    __CODE_RUN__              005000  LA    
__CODE_SIZE__             000216  EA    __COSBF100_LOAD__         007300  LA    
__COSBF100_RUN__          007300  LA    __COSBF100_SIZE__         000B00  EA    
__COSCODE_LOAD__          006000  LA    __COSCODE_RUN__           006000  LA    
__COSCODE_SIZE__          0001A8  EA    __COSLIB_LOAD__           0061A8  LA    
__COSLIB_RUN__            0061A8  LA    __COSLIB_SIZE__           0010BE  EA    
__COSVAR_LOAD__           007266  LA    __COSVAR_RUN__            007266  LA    
__COSVAR_SIZE__           000040  EA    


Exports list by value:
----------------------
__COSVAR_SIZE__           000040  EA    __COSCODE_SIZE__          0001A8  EA    
__CODE_SIZE__             000216  EA    __COSBF100_SIZE__         000B00  EA    
__COSLIB_SIZE__           0010BE  EA    __CODE_LOAD__             005000  LA    
__CODE_RUN__              005000  LA    __COSCODE_LOAD__          006000  LA    
__COSCODE_RUN__           006000  LA    __COSLIB_LOAD__           0061A8  LA    
__COSLIB_RUN__            0061A8  LA    __COSVAR_LOAD__           007266  LA    
__COSVAR_RUN__            007266  LA    __COSBF100_LOAD__         007300  LA    
__COSBF100_RUN__          007300  LA    


Imports list:
-------------
__CODE_LOAD__ ([linker generated]):
__CODE_RUN__ ([linker generated]):
__CODE_SIZE__ ([linker generated]):
__COSBF100_LOAD__ ([linker generated]):
__COSBF100_RUN__ ([linker generated]):
__COSBF100_SIZE__ ([linker generated]):
__COSCODE_LOAD__ ([linker generated]):
__COSCODE_RUN__ ([linker generated]):
__COSCODE_SIZE__ ([linker generated]):
__COSLIB_LOAD__ ([linker generated]):
__COSLIB_RUN__ ([linker generated]):
__COSLIB_SIZE__ ([linker generated]):
__COSVAR_LOAD__ ([linker generated]):
__COSVAR_RUN__ ([linker generated]):
__COSVAR_SIZE__ ([linker generated]):

