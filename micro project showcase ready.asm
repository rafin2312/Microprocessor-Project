; ============================================================================
; SOUTHEAST UNIVERSITY - STUDENT MANAGEMENT SYSTEM
; ============================================================================
.MODEL SMALL
.STACK 100H
MAX_STUDENTS EQU 20
NAME_SIZE EQU 31
ID_SIZE EQU 14
FACILITY_COUNT EQU 8
LOG_CAPACITY EQU 30
TOTAL_NAMES EQU MAX_STUDENTS * NAME_SIZE
TOTAL_IDS EQU MAX_STUDENTS * ID_SIZE
TOTAL_CGPAS EQU MAX_STUDENTS * 2
TOTAL_FACILITIES EQU MAX_STUDENTS * FACILITY_COUNT
ACT_START EQU 1
ACT_ADMIN_OK EQU 2
ACT_ADMIN_FAIL EQU 3
ACT_STUDENT_OK EQU 4
ACT_STUDENT_FAIL EQU 5
ACT_ADD EQU 6
ACT_UPDATE EQU 7
ACT_DELETE EQU 8
ACT_FACILITY EQU 9
ACT_SAVE EQU 10
ACT_LOAD EQU 11
ACT_SAVE_FAIL EQU 12
ACT_LOAD_FAIL EQU 13
ACT_ADMIN_OUT EQU 14
ACT_STUDENT_OUT EQU 15
ACT_REPORT EQU 16
ACT_EXIT EQU 17
.DATA
TitleText DB 13,10,'============================================================',13,10,'       SOUTHEAST UNIVERSITY STUDENT DATABASE',13,10
          DB '============================================================','$'
MainMenu DB 13,10,13,10,'SYSTEM GATEWAY',13,10,'  1. Administrator login',13,10,'  2. Student ID login',13,10,'  3. System information',13,10,'  4. Exit cleanly to DOS',13,10,'Select: $'
AdminBanner DB 13,10,'------------------------------------------------------------',13,10,'                    ADMINISTRATION',13,10,'------------------------------------------------------------','$'
AdminMenu DB 13,10,'  1. Add a student',13,10,'  2. List all students',13,10,'  3. Find and view a student',13,10,'  4. Update a student',13,10,'  5. Delete a student',13,10,'  6. Assign facility status',13,10
          DB '  7. CGPA statistics',13,10,'  8. Sorted CGPA report',13,10,'  9. Activity log',13,10,'  A. Assign attendance',13,10,'  F. Assign tuition fee status',13,10,'  P. Change administrator password',13,10
          DB '  S. Save database to disk',13,10,'  L. Load database from disk',13,10,'  X. Administrator logout',13,10
          DB 'Command: $'
StudentBanner DB 13,10,'------------------------------------------------------------',13,10,'                     STUDENT PORTAL',13,10,'------------------------------------------------------------','$'
StudentMenu DB 13,10,'  1. View complete profile',13,10,'  2. View facility assignments',13,10,'  3. View academic standing',13,10,'  4. View attendance',13,10,'  5. View tuition fee status',13,10,'  X. Logout',13,10,'Command: $'
LoginBanner DB 13,10,'------------------------------------------------------------',13,10,'                  SECURE ADMIN LOGIN',13,10,'------------------------------------------------------------','$'
InfoText DB 13,10,'SYSTEM INFORMATION',13,10,'This program keeps at most twenty indexed student records.',13,10,'Names, IDs, CGPAs, facilities, and attendance use parallel arrays.',13,10
         DB 'CGPA values are stored as integer hundredths from 0 to 400.',13,10,'Attendance is stored as a whole-number percentage.',13,10,'The binary file name is STUDENTS.DAT in the current folder.',13,10,'Administrator credentials are configurable.',13,10
         DB 'All screen and file services use DOS or BIOS interrupts.','$'
PromptAdminUser DB 13,10,'Administrator name: $'
PromptAdminPass DB 13,10,'Password: $'
PromptStudentID DB 13,10,'Enter the 13-digit student ID: $'
PromptName DB 13,10,'Enter student name (1-30 characters): $'
PromptID DB 13,10,'Enter exactly 13 numeric ID digits: $'
PromptCGPA DB 13,10,'Enter CGPA in d.dd form (0.00 through 4.00): $'
PromptFindID DB 13,10,'ID to locate: $'
PromptDelete DB 13,10,'Delete this record permanently (Y/N)? $'
PromptPause DB 13,10,13,10,'Press any key to continue...$'
PromptFacility DB 13,10,'Choose facility number (1-8): $'
PromptStatus DB 13,10,'Choose new status (0-9): $'
PromptAttendance DB 13,10,'Enter attendance percentage (0-100): $'
PromptFeeStatus DB 13,10,'Choose fee status (0-3): $'
PromptCurrentPass DB 13,10,'Current administrator password: $'
PromptNewPass DB 13,10,'New administrator password: $'
MsgAttendance DB 13,10,'Attendance updated successfully.$'
MsgFeeStatus DB 13,10,'Tuition fee status updated successfully.$'
MsgBadFeeStatus DB 13,10,'Invalid fee status. Choose a value from 0 to 3.$'
MsgBadAttendance DB 13,10,'Invalid attendance. Enter a value from 0 to 100.$'
MsgPasswordChanged DB 13,10,'Administrator password changed successfully.$'
MsgPasswordWrong DB 13,10,'Current administrator password is incorrect.$'
LabelAttendance DB 13,10,'Attendance    : $'
LabelFeeStatus DB 13,10,'Tuition fee   : $'
LabelRank DB 13,10,'Rank          : $'
PromptUpdate DB 13,10,'Update field:',13,10,'  1. Name',13,10,'  2. Student ID',13,10,'  3. CGPA',13,10,'  4. Name, ID, and CGPA',13,10,'  X. Cancel',13,10,'Command: $'
FacilityMenu DB 13,10,'FACILITIES',13,10,'  1. Central library',13,10,'  2. Hardware laboratory',13,10,'  3. Sports and ECA',13,10,'  4. Hostel and accommodation',13,10,'  5. University transport',13,10
             DB '  6. Medical services',13,10,'  7. Cafeteria plan',13,10,'  8. Finance and waiver',13,10,'$'
StatusMenu DB 13,10,'STATUS CODES',13,10,'  0. Not assigned',13,10,'  1. Requested',13,10,'  2. Active',13,10,'  3. Pending approval',13,10,'  4. Completed or cleared',13,10,'  5. Suspended',13,10
           DB '  6. On hold',13,10,'  7. Expired',13,10,'  8. Denied',13,10,'  9. Special approval',13,10,'$'
FeeStatusMenu DB 13,10,'TUITION FEE STATUS',13,10,'  0. Not assessed',13,10,'  1. Paid',13,10,'  2. Partially paid',13,10,'  3. Due',13,10,'$'
MsgWelcome DB 13,10,'Access granted. Welcome, administrator.$'
MsgDenied DB 13,10,'Access denied. Credentials do not match.$'
MsgAttempts DB 13,10,'No login attempts remain. Returning to gateway.$'
MsgBadChoice DB 13,10,'Invalid command. Choose one of the displayed options.$'
MsgBadName DB 13,10,'Name cannot be empty.$'
MsgBadID DB 13,10,'Invalid ID. Enter exactly thirteen decimal digits.$'
MsgDuplicate DB 13,10,'That student ID already exists in the database.$'
MsgBadCGPA DB 13,10,'Invalid CGPA. Required form is d.dd; maximum is 4.00.$'
MsgFull DB 13,10,'Database is full. Delete a record before adding another.$'
MsgEmpty DB 13,10,'The student database is empty.$'
MsgNotFound DB 13,10,'No student with that ID was found.$'
MsgAdded DB 13,10,'Student record added successfully.$'
MsgUpdated DB 13,10,'Student record updated successfully.$'
MsgDeleted DB 13,10,'Student record deleted and indexes compacted.$'
MsgCancelled DB 13,10,'Operation cancelled. No data was changed.$'
MsgFacility DB 13,10,'Facility assignment updated successfully.$'
MsgSaved DB 13,10,'Database saved to STUDENTS.DAT.$'
MsgLoaded DB 13,10,'Database loaded from STUDENTS.DAT.$'
MsgSaveError DB 13,10,'File error: the database could not be saved completely.$'
MsgLoadError DB 13,10,'File error: no valid STUDENTS.DAT database was loaded.$'
MsgCorrupt DB 13,10,'File error: wrong signature, version, size, or record count.$'
MsgStudentWelcome DB 13,10,'Student ID accepted. Portal session started.$'
MsgLogout DB 13,10,'Session closed.$'
MsgNoLogs DB 13,10,'No activity entries are available.$'
MsgSortedNote DB 13,10,'This report sorts an index array; stored records are unchanged.',13,10,'$'
MsgLineFull DB 7,'$'
LabelRecord DB 13,10,'Record number : $'
LabelName DB 13,10,'Name          : $'
LabelID DB 13,10,'Student ID    : $'
LabelCGPA DB 13,10,'CGPA          : $'
LabelClass DB 13,10,'Classification: $'
LabelFacilities DB 13,10,13,10,'FACILITY ASSIGNMENTS','$'
LabelStudentCount DB 13,10,'Student count : $'
LabelAverage DB 13,10,'Average CGPA  : $'
LabelHighest DB 13,10,'Highest CGPA  : $'
LabelLowest DB 13,10,'Lowest CGPA   : $'
LabelDistCount DB 13,10,'Distinction   : $'
LabelMeritCount DB 13,10,'Merit         : $'
LabelPassCount DB 13,10,'Pass          : $'
LabelProbCount DB 13,10,'Probation     : $'
LabelLog DB 13,10,'ACTIVITY LOG (oldest entry first)',13,10,'$'
LabelSorted DB 13,10,'CGPA REPORT - HIGHEST TO LOWEST',13,10,'$'
LabelSeparator DB 13,10,'------------------------------------------------------------','$'
LabelColon DB ': $'
LabelDash DB ' - $'
FacilityLabel1 DB 13,10,'Central library          : $'
FacilityLabel2 DB 13,10,'Hardware laboratory      : $'
FacilityLabel3 DB 13,10,'Sports and ECA           : $'
FacilityLabel4 DB 13,10,'Hostel/accommodation     : $'
FacilityLabel5 DB 13,10,'University transport     : $'
FacilityLabel6 DB 13,10,'Medical services         : $'
FacilityLabel7 DB 13,10,'Cafeteria plan           : $'
FacilityLabel8 DB 13,10,'Finance and waiver       : $'
FacilityLabelPointers DW OFFSET FacilityLabel1, OFFSET FacilityLabel2, OFFSET FacilityLabel3, OFFSET FacilityLabel4,OFFSET FacilityLabel5, OFFSET FacilityLabel6, OFFSET FacilityLabel7, OFFSET FacilityLabel8
Status0 DB 'Not assigned$'
Status1 DB 'Requested$'
Status2 DB 'Active$'
Status3 DB 'Pending approval$'
Status4 DB 'Completed or cleared$'
Status5 DB 'Suspended$'
Status6 DB 'On hold$'
Status7 DB 'Expired$'
Status8 DB 'Denied$'
Status9 DB 'Special approval$'
StatusUnknown DB 'Unknown status$'
StatusPointers DW OFFSET Status0, OFFSET Status1, OFFSET Status2, OFFSET Status3, OFFSET Status4,OFFSET Status5, OFFSET Status6, OFFSET Status7, OFFSET Status8, OFFSET Status9
FeeStatus0 DB 'Not assessed$'
FeeStatus1 DB 'Paid$'
FeeStatus2 DB 'Partially paid$'
FeeStatus3 DB 'Due$'
FeeStatusPointers DW OFFSET FeeStatus0, OFFSET FeeStatus1, OFFSET FeeStatus2, OFFSET FeeStatus3
ClassDistinction DB 'Distinction$'
ClassMerit DB 'Merit$'
ClassPass DB 'Pass$'
ClassProbation DB 'Probation$'
ActionStart DB 'Program started$'
ActionAdminOK DB 'Administrator login accepted$'
ActionAdminFail DB 'Administrator login rejected$'
ActionStudentOK DB 'Student login accepted$'
ActionStudentFail DB 'Student login rejected$'
ActionAdd DB 'Student added$'
ActionUpdate DB 'Student updated$'
ActionDelete DB 'Student deleted$'
ActionFacility DB 'Facility status changed$'
ActionSave DB 'Database saved$'
ActionLoad DB 'Database loaded$'
ActionSaveFail DB 'Database save failed$'
ActionLoadFail DB 'Database load failed$'
ActionAdminOut DB 'Administrator logged out$'
ActionStudentOut DB 'Student logged out$'
ActionReport DB 'Report or statistics viewed$'
ActionExit DB 'Program terminated$'
ActionUnknown DB 'Unknown activity$'
ActionPointers DW OFFSET ActionStart, OFFSET ActionAdminOK, OFFSET ActionAdminFail, OFFSET ActionStudentOK,OFFSET ActionStudentFail, OFFSET ActionAdd, OFFSET ActionUpdate, OFFSET ActionDelete
               DW OFFSET ActionFacility, OFFSET ActionSave, OFFSET ActionLoad, OFFSET ActionSaveFail,OFFSET ActionLoadFail, OFFSET ActionAdminOut, OFFSET ActionStudentOut, OFFSET ActionReport,OFFSET ActionExit
AdminUser DB 'admin',0
AdminPassword DB 'seu8086',0,13 DUP(0)
DatabaseFile DB 'STUDENTS.DAT',0
InputBuffer DB 64 DUP(0)
PasswordBuffer DB 20 DUP(0)
TempName DB NAME_SIZE DUP(0)
TempID DB ID_SIZE DUP(0)
CurrentIndex DB 0
WorkIndex DB 0
WorkSource DB 0
WorkDest DB 0
CurrentAction DB 0
LoginTries DB 0
SelectedFacility DB 0
SelectedStatus DB 0
SortI DB 0
SortJ DB 0
SortBest DB 0
LoopByte DB 0
SumCGPA DW 0
HighCGPA DW 0
LowCGPA DW 0
AverageCGPA DW 0
CountDistinction DB 0
CountMerit DB 0
CountPass DB 0
CountProbation DB 0
FileHandle DW 0
LogCount DB 0
LogNext DB 0
LogHours DB LOG_CAPACITY DUP(0)
LogMinutes DB LOG_CAPACITY DUP(0)
LogSeconds DB LOG_CAPACITY DUP(0)
LogActions DB LOG_CAPACITY DUP(0)
SortIndex DB MAX_STUDENTS DUP(0)
FileMagic DB 'SDB1'
FileVersion DB 3
StudentCount DB 0
StudentNames DB TOTAL_NAMES DUP(0)
StudentIDs DB TOTAL_IDS DUP(0)
StudentCGPAs DW MAX_STUDENTS DUP(0)
StudentFacilities DB TOTAL_FACILITIES DUP(0)
StudentAttendance DB MAX_STUDENTS DUP(0)
StudentFeeStatus DB MAX_STUDENTS DUP(0)
DatabaseEnd LABEL BYTE
DB_SIZE EQU DatabaseEnd - FileMagic
LoadBuffer DB DB_SIZE DUP(0)
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    MOV ES, AX
    CLD
    CALL InitializeDatabase
    MOV AL, ACT_START
    CALL AddLogEntry
MainLoop:
    CALL ClearScreen
    LEA DX, TitleText
    CALL PrintDollar
    LEA DX, MainMenu
    CALL PrintDollar
    CALL ReadMenuKey
    CMP AL, '1'
    JNE MainCheckStudent
    CALL AdminLogin
    JMP MainLoop
MainCheckStudent:
    CMP AL, '2'
    JNE MainCheckInfo
    CALL StudentLogin
    JMP MainLoop
MainCheckInfo:
    CMP AL, '3'
    JNE MainCheckExit
    CALL ClearScreen
    LEA DX, TitleText
    CALL PrintDollar
    LEA DX, InfoText
    CALL PrintDollar
    CALL PauseScreen
    JMP MainLoop
MainCheckExit:
    CMP AL, '4'
    JNE MainInvalid
    MOV AL, ACT_EXIT
    CALL AddLogEntry
    CALL ClearScreen
    MOV AX, 4C00H
    INT 21H
MainInvalid:
    LEA DX, MsgBadChoice
    CALL PrintDollar
    CALL PauseScreen
    JMP MainLoop
MAIN ENDP
ClearScreen PROC NEAR
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    MOV AX, 0600H
    MOV BH, 07H
    MOV CX, 0000H
    MOV DX, 184FH
    INT 10H
    MOV AH, 02H
    MOV BH, 00H
    MOV DX, 0000H
    INT 10H
    POP DX
    POP CX
    POP BX
    POP AX
    RET
ClearScreen ENDP
PrintDollar PROC NEAR
    PUSH AX
    MOV AH, 09H
    INT 21H
    POP AX
    RET
PrintDollar ENDP
PrintCRLF PROC NEAR
    PUSH AX
    PUSH DX
    MOV DL, 13
    MOV AH, 02H
    INT 21H
    MOV DL, 10
    MOV AH, 02H
    INT 21H
    POP DX
    POP AX
    RET
PrintCRLF ENDP
PrintCharacter PROC NEAR
    PUSH AX
    MOV AH, 02H
    INT 21H
    POP AX
    RET
PrintCharacter ENDP
Beep PROC NEAR
    PUSH DX
    MOV DL, 7
    CALL PrintCharacter
    POP DX
    RET
Beep ENDP
PauseScreen PROC NEAR
    PUSH AX
    PUSH DX
    LEA DX, PromptPause
    CALL PrintDollar
    MOV AH, 08H
    INT 21H
    POP DX
    POP AX
    RET
PauseScreen ENDP
ReadMenuKey PROC NEAR
ReadMenuAgain:
    MOV AH, 08H
    INT 21H
    CMP AL, 'a'
    JB ReadMenuNotLower
    CMP AL, 'z'
    JA ReadMenuNotLower
    SUB AL, 20H
ReadMenuNotLower:
    CMP AL, 32
    JB ReadMenuAgain
    PUSH AX
    MOV DL, AL
    CALL PrintCharacter
    CALL PrintCRLF
    POP AX
    RET
ReadMenuKey ENDP
ReadLine PROC NEAR
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    MOV SI, DX
    XOR BX, BX
ReadLineLoop:
    MOV AH, 08H
    INT 21H
    CMP AL, 13
    JE ReadLineDone
    CMP AL, 8
    JE ReadLineBackspace
    CMP AL, 32
    JB ReadLineReject
    CMP AL, 126
    JA ReadLineReject
    CMP BX, CX
    JAE ReadLineFull
    MOV [SI+BX], AL
    INC BX
    MOV DL, AL
    CALL PrintCharacter
    JMP ReadLineLoop
ReadLineBackspace:
    CMP BX, 0
    JE ReadLineReject
    DEC BX
    MOV BYTE PTR [SI+BX], 0
    MOV DL, 8
    CALL PrintCharacter
    MOV DL, ' '
    CALL PrintCharacter
    MOV DL, 8
    CALL PrintCharacter
    JMP ReadLineLoop
ReadLineFull:
    CALL Beep
    JMP ReadLineLoop
ReadLineReject:
    CALL Beep
    JMP ReadLineLoop
ReadLineDone:
    MOV BYTE PTR [SI+BX], 0
    CALL PrintCRLF
    MOV AX, BX
    POP SI
    POP DX
    POP CX
    POP BX
    RET
ReadLine ENDP
ReadPassword PROC NEAR
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    MOV SI, DX
    XOR BX, BX
ReadPasswordLoop:
    MOV AH, 08H
    INT 21H
    CMP AL, 13
    JE ReadPasswordDone
    CMP AL, 8
    JE ReadPasswordBackspace
    CMP AL, 32
    JB ReadPasswordReject
    CMP AL, 126
    JA ReadPasswordReject
    CMP BX, CX
    JAE ReadPasswordFull
    MOV [SI+BX], AL
    INC BX
    MOV DL, '*'
    CALL PrintCharacter
    JMP ReadPasswordLoop
ReadPasswordBackspace:
    CMP BX, 0
    JE ReadPasswordReject
    DEC BX
    MOV BYTE PTR [SI+BX], 0
    MOV DL, 8
    CALL PrintCharacter
    MOV DL, ' '
    CALL PrintCharacter
    MOV DL, 8
    CALL PrintCharacter
    JMP ReadPasswordLoop
ReadPasswordFull:
    CALL Beep
    JMP ReadPasswordLoop
ReadPasswordReject:
    CALL Beep
    JMP ReadPasswordLoop
ReadPasswordDone:
    MOV BYTE PTR [SI+BX], 0
    CALL PrintCRLF
    MOV AX, BX
    POP SI
    POP DX
    POP CX
    POP BX
    RET
ReadPassword ENDP
PrintZ PROC NEAR
    PUSH AX
    PUSH DX
    PUSH SI
    MOV SI, DX
PrintZLoop:
    MOV AL, [SI]
    OR AL, AL
    JZ PrintZDone
    MOV DL, AL
    CALL PrintCharacter
    INC SI
    JMP PrintZLoop
PrintZDone:
    POP SI
    POP DX
    POP AX
    RET
PrintZ ENDP
PrintUInt PROC NEAR
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    XOR CX, CX
    MOV BX, 10
    CMP AX, 0
    JNE PrintUIntDivide
    MOV DL, '0'
    CALL PrintCharacter
    JMP PrintUIntDone
PrintUIntDivide:
    XOR DX, DX
    DIV BX
    PUSH DX
    INC CX
    CMP AX, 0
    JNE PrintUIntDivide
PrintUIntDigits:
    POP DX
    ADD DL, '0'
    CALL PrintCharacter
    LOOP PrintUIntDigits
PrintUIntDone:
    POP DX
    POP CX
    POP BX
    POP AX
    RET
PrintUInt ENDP
PrintTwoDigits PROC NEAR
    PUSH AX
    PUSH BX
    PUSH DX
    XOR AH, AH
    AAM
    MOV BX, AX
    MOV DL, BH
    ADD DL, '0'
    CALL PrintCharacter
    MOV DL, BL
    ADD DL, '0'
    CALL PrintCharacter
    POP DX
    POP BX
    POP AX
    RET
PrintTwoDigits ENDP
PrintCGPA PROC NEAR
    PUSH AX
    PUSH BX
    PUSH DX
    XOR DX, DX
    MOV BX, 100
    DIV BX
    MOV BX, DX
    CALL PrintUInt
    MOV DL, '.'
    CALL PrintCharacter
    MOV AL, BL
    CALL PrintTwoDigits
    POP DX
    POP BX
    POP AX
    RET
PrintCGPA ENDP
StringEqual PROC NEAR
    PUSH AX
    PUSH SI
    PUSH DI
StringEqualLoop:
    MOV AL, [SI]
    CMP AL, [DI]
    JNE StringEqualNo
    OR AL, AL
    JZ StringEqualYes
    INC SI
    INC DI
    JMP StringEqualLoop
StringEqualYes:
    CLC
    JMP StringEqualExit
StringEqualNo:
    STC
StringEqualExit:
    POP DI
    POP SI
    POP AX
    RET
StringEqual ENDP
ValidateID PROC NEAR
    PUSH AX
    PUSH CX
    PUSH SI
    MOV SI, DX
    MOV CX, 13
ValidateIDLoop:
    MOV AL, [SI]
    CMP AL, '0'
    JB ValidateIDBad
    CMP AL, '9'
    JA ValidateIDBad
    INC SI
    LOOP ValidateIDLoop
    CMP BYTE PTR [SI], 0
    JNE ValidateIDBad
    CLC
    JMP ValidateIDExit
ValidateIDBad:
    STC
ValidateIDExit:
    POP SI
    POP CX
    POP AX
    RET
ValidateID ENDP
ParseCGPA PROC NEAR
    PUSH BX
    PUSH DX
    PUSH SI
    MOV SI, DX
    MOV AL, [SI]
    CMP AL, '0'
    JB ParseCGPABad
    CMP AL, '4'
    JA ParseCGPABad
    CMP BYTE PTR [SI+1], '.'
    JNE ParseCGPABad
    MOV AL, [SI+2]
    CMP AL, '0'
    JB ParseCGPABad
    CMP AL, '9'
    JA ParseCGPABad
    MOV AL, [SI+3]
    CMP AL, '0'
    JB ParseCGPABad
    CMP AL, '9'
    JA ParseCGPABad
    CMP BYTE PTR [SI+4], 0
    JNE ParseCGPABad
    CMP BYTE PTR [SI], '4'
    JNE ParseCGPAConvert
    CMP BYTE PTR [SI+2], '0'
    JNE ParseCGPABad
    CMP BYTE PTR [SI+3], '0'
    JNE ParseCGPABad
ParseCGPAConvert:
    XOR AX, AX
    MOV AL, [SI]
    SUB AL, '0'
    MOV BL, 100
    MUL BL
    MOV BX, AX
    XOR AX, AX
    MOV AL, [SI+2]
    SUB AL, '0'
    MOV DL, 10
    MUL DL
    ADD BX, AX
    XOR AX, AX
    MOV AL, [SI+3]
    SUB AL, '0'
    ADD BX, AX
    MOV AX, BX
    CLC
    JMP ParseCGPAExit
ParseCGPABad:
    XOR AX, AX
    STC
ParseCGPAExit:
    POP SI
    POP DX
    POP BX
    RET
ParseCGPA ENDP
InputValidName PROC NEAR
InputNameAgain:
    LEA DX, PromptName
    CALL PrintDollar
    LEA DX, TempName
    MOV CX, NAME_SIZE-1
    CALL ReadLine
    CMP AX, 0
    JNE InputNameOK
    LEA DX, MsgBadName
    CALL PrintDollar
    JMP InputNameAgain
InputNameOK:
    RET
InputValidName ENDP
InputValidID PROC NEAR
InputIDAgain:
    LEA DX, PromptID
    CALL PrintDollar
    LEA DX, TempID
    MOV CX, 13
    CALL ReadLine
    LEA DX, TempID
    CALL ValidateID
    JNC InputIDOK
    LEA DX, MsgBadID
    CALL PrintDollar
    JMP InputIDAgain
InputIDOK:
    RET
InputValidID ENDP
InputValidCGPA PROC NEAR
InputCGPAAgain:
    LEA DX, PromptCGPA
    CALL PrintDollar
    LEA DX, InputBuffer
    MOV CX, 4
    CALL ReadLine
    LEA DX, InputBuffer
    CALL ParseCGPA
    JNC InputCGPAOK
    LEA DX, MsgBadCGPA
    CALL PrintDollar
    JMP InputCGPAAgain
InputCGPAOK:
    RET
InputValidCGPA ENDP
GetNamePointer PROC NEAR
    PUSH AX
    PUSH BX
    XOR AH, AH
    MOV BL, NAME_SIZE
    MUL BL
    LEA DI, StudentNames
    ADD DI, AX
    POP BX
    POP AX
    RET
GetNamePointer ENDP
GetIDPointer PROC NEAR
    PUSH AX
    PUSH BX
    XOR AH, AH
    MOV BL, ID_SIZE
    MUL BL
    LEA DI, StudentIDs
    ADD DI, AX
    POP BX
    POP AX
    RET
GetIDPointer ENDP
GetCGPAPointer PROC NEAR
    PUSH AX
    XOR AH, AH
    SHL AX, 1
    LEA DI, StudentCGPAs
    ADD DI, AX
    POP AX
    RET
GetCGPAPointer ENDP
GetFacilityPointer PROC NEAR
    PUSH AX
    PUSH BX
    XOR AH, AH
    MOV BL, FACILITY_COUNT
    MUL BL
    LEA DI, StudentFacilities
    ADD DI, AX
    POP BX
    POP AX
    RET
GetFacilityPointer ENDP
GetAttendancePointer PROC NEAR
    PUSH AX
    XOR AH, AH
    LEA DI, StudentAttendance
    ADD DI, AX
    POP AX
    RET
GetAttendancePointer ENDP
GetCGPAValue PROC NEAR
    CALL GetCGPAPointer
    MOV AX, [DI]
    RET
GetCGPAValue ENDP
CopyToFixed PROC NEAR
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH SI
    PUSH DI
    MOV BX, CX
    PUSH DI
    XOR AL, AL
    REP STOSB
    POP DI
    MOV CX, BX
    DEC CX
CopyToFixedLoop:
    LODSB
    OR AL, AL
    JZ CopyToFixedDone
    STOSB
    LOOP CopyToFixedLoop
CopyToFixedDone:
    MOV BYTE PTR ES:[DI], 0
    POP DI
    POP SI
    POP CX
    POP BX
    POP AX
    RET
CopyToFixed ENDP
ClearRecord PROC NEAR
    PUSH AX
    PUSH CX
    PUSH DI
    MOV WorkIndex, AL
    CALL GetNamePointer
    MOV CX, NAME_SIZE
    XOR AL, AL
    REP STOSB
    MOV AL, WorkIndex
    CALL GetIDPointer
    MOV CX, ID_SIZE
    XOR AL, AL
    REP STOSB
    MOV AL, WorkIndex
    CALL GetCGPAPointer
    MOV WORD PTR [DI], 0
    MOV AL, WorkIndex
    CALL GetFacilityPointer
    MOV CX, FACILITY_COUNT
    XOR AL, AL
    REP STOSB
    MOV AL, WorkIndex
    XOR AH, AH
    LEA DI, StudentAttendance
    ADD DI, AX
    MOV BYTE PTR [DI], 0
    LEA DI, StudentFeeStatus
    ADD DI, AX
    MOV BYTE PTR [DI], 0
    POP DI
    POP CX
    POP AX
    RET
ClearRecord ENDP
InitializeDatabase PROC NEAR
    PUSH AX
    PUSH CX
    PUSH DI
    LEA DI, FileMagic
    MOV CX, DB_SIZE
    XOR AL, AL
    REP STOSB
    MOV BYTE PTR FileMagic, 'S'
    MOV BYTE PTR FileMagic+1, 'D'
    MOV BYTE PTR FileMagic+2, 'B'
    MOV BYTE PTR FileMagic+3, '1'
    MOV BYTE PTR FileVersion, 3
    MOV BYTE PTR StudentCount, 0
    POP DI
    POP CX
    POP AX
    RET
InitializeDatabase ENDP
FindByID PROC NEAR
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH DI
    XOR BX, BX
FindIDOuter:
    CMP BL, StudentCount
    JAE FindIDMissing
    MOV AL, BL
    CALL GetIDPointer
    MOV SI, DX
    MOV CX, 13
FindIDCompare:
    MOV AL, [SI]
    CMP AL, [DI]
    JNE FindIDNext
    INC SI
    INC DI
    LOOP FindIDCompare
    MOV AL, BL
    CLC
    JMP FindIDExit
FindIDNext:
    INC BL
    JMP FindIDOuter
FindIDMissing:
    XOR AL, AL
    STC
FindIDExit:
    POP DI
    POP SI
    POP DX
    POP CX
    POP BX
    RET
FindByID ENDP
CopyRecord PROC NEAR
    PUSH AX
    PUSH CX
    PUSH SI
    PUSH DI
    MOV WorkDest, AL
    MOV WorkSource, AH
    MOV AL, WorkSource
    CALL GetNamePointer
    MOV SI, DI
    MOV AL, WorkDest
    CALL GetNamePointer
    MOV CX, NAME_SIZE
    REP MOVSB
    MOV AL, WorkSource
    CALL GetIDPointer
    MOV SI, DI
    MOV AL, WorkDest
    CALL GetIDPointer
    MOV CX, ID_SIZE
    REP MOVSB
    MOV AL, WorkSource
    CALL GetCGPAPointer
    MOV SI, DI
    MOV AL, WorkDest
    CALL GetCGPAPointer
    MOV CX, 2
    REP MOVSB
    MOV AL, WorkSource
    CALL GetFacilityPointer
    MOV SI, DI
    MOV AL, WorkDest
    CALL GetFacilityPointer
    MOV CX, FACILITY_COUNT
    REP MOVSB
    MOV AL, WorkSource
    XOR AH, AH
    LEA SI, StudentAttendance
    ADD SI, AX
    MOV AL, WorkDest
    XOR AH, AH
    LEA DI, StudentAttendance
    ADD DI, AX
    MOVSB
    MOV AL, WorkSource
    XOR AH, AH
    LEA SI, StudentFeeStatus
    ADD SI, AX
    MOV AL, WorkDest
    XOR AH, AH
    LEA DI, StudentFeeStatus
    ADD DI, AX
    MOVSB
    POP DI
    POP SI
    POP CX
    POP AX
    RET
CopyRecord ENDP
AdminLogin PROC NEAR
    MOV LoginTries, 3
AdminLoginAgain:
    CALL ClearScreen
    LEA DX, TitleText
    CALL PrintDollar
    LEA DX, LoginBanner
    CALL PrintDollar
    LEA DX, PromptAdminUser
    CALL PrintDollar
    LEA DX, InputBuffer
    MOV CX, 15
    CALL ReadLine
    LEA SI, InputBuffer
    LEA DI, AdminUser
    CALL StringEqual
    JC AdminLoginFailed
    LEA DX, PromptAdminPass
    CALL PrintDollar
    LEA DX, PasswordBuffer
    MOV CX, 15
    CALL ReadPassword
    LEA SI, PasswordBuffer
    LEA DI, AdminPassword
    CALL StringEqual
    JC AdminLoginFailed
    MOV AL, ACT_ADMIN_OK
    CALL AddLogEntry
    LEA DX, MsgWelcome
    CALL PrintDollar
    CALL PauseScreen
    CALL AdminPortal
    RET
AdminLoginFailed:
    MOV AL, ACT_ADMIN_FAIL
    CALL AddLogEntry
    LEA DX, MsgDenied
    CALL PrintDollar
    DEC LoginTries
    JZ AdminLoginLocked
    CALL PauseScreen
    JMP AdminLoginAgain
AdminLoginLocked:
    LEA DX, MsgAttempts
    CALL PrintDollar
    CALL PauseScreen
    RET
AdminLogin ENDP
AdminPortal PROC NEAR
AdminPortalLoop:
    CALL ClearScreen
    LEA DX, TitleText
    CALL PrintDollar
    LEA DX, AdminBanner
    CALL PrintDollar
    LEA DX, LabelStudentCount
    CALL PrintDollar
    XOR AX, AX
    MOV AL, StudentCount
    CALL PrintUInt
    LEA DX, AdminMenu
    CALL PrintDollar
    CALL ReadMenuKey
    CMP AL, '1'
    JNE AdminChoice2
    CALL AdminAddStudent
    JMP AdminPortalLoop
AdminChoice2:
    CMP AL, '2'
    JNE AdminChoice3
    CALL AdminListStudents
    JMP AdminPortalLoop
AdminChoice3:
    CMP AL, '3'
    JNE AdminChoice4
    CALL AdminFindStudent
    JMP AdminPortalLoop
AdminChoice4:
    CMP AL, '4'
    JNE AdminChoice5
    CALL AdminUpdateStudent
    JMP AdminPortalLoop
AdminChoice5:
    CMP AL, '5'
    JNE AdminChoice6
    CALL AdminDeleteStudent
    JMP AdminPortalLoop
AdminChoice6:
    CMP AL, '6'
    JNE AdminChoice7
    CALL AdminAssignFacility
    JMP AdminPortalLoop
AdminChoice7:
    CMP AL, '7'
    JNE AdminChoice8
    CALL ShowStatistics
    JMP AdminPortalLoop
AdminChoice8:
    CMP AL, '8'
    JNE AdminChoice9
    CALL ShowSortedReport
    JMP AdminPortalLoop
AdminChoice9:
    CMP AL, '9'
    JNE AdminChoiceAttendance
    CALL ShowActivityLog
    JMP AdminPortalLoop
AdminChoiceAttendance:
    CMP AL, 'A'
    JNE AdminChoiceFee
    CALL AdminAssignAttendance
    JMP AdminPortalLoop
AdminChoiceFee:
    CMP AL, 'F'
    JNE AdminChoicePassword
    CALL AdminAssignFeeStatus
    JMP AdminPortalLoop
AdminChoicePassword:
    CMP AL, 'P'
    JNE AdminChoiceSave
    CALL AdminChangePassword
    JMP AdminPortalLoop
AdminChoiceSave:
    CMP AL, 'S'
    JNE AdminChoiceLoad
    CALL SaveDatabase
    JMP AdminPortalLoop
AdminChoiceLoad:
    CMP AL, 'L'
    JNE AdminChoiceExit
    CALL LoadDatabase
    JMP AdminPortalLoop
AdminChoiceExit:
    CMP AL, 'X'
    JNE AdminChoiceBad
    MOV AL, ACT_ADMIN_OUT
    CALL AddLogEntry
    LEA DX, MsgLogout
    CALL PrintDollar
    CALL PauseScreen
    RET
AdminChoiceBad:
    LEA DX, MsgBadChoice
    CALL PrintDollar
    CALL PauseScreen
    JMP AdminPortalLoop
AdminPortal ENDP
StudentLogin PROC NEAR
    CALL ClearScreen
    LEA DX, TitleText
    CALL PrintDollar
    LEA DX, StudentBanner
    CALL PrintDollar
    LEA DX, PromptStudentID
    CALL PrintDollar
    LEA DX, TempID
    MOV CX, 13
    CALL ReadLine
    LEA DX, TempID
    CALL ValidateID
    JC StudentLoginBad
    LEA DX, TempID
    CALL FindByID
    JC StudentLoginBad
    MOV CurrentIndex, AL
    MOV AL, ACT_STUDENT_OK
    CALL AddLogEntry
    LEA DX, MsgStudentWelcome
    CALL PrintDollar
    CALL PauseScreen
    CALL StudentPortal
    RET
StudentLoginBad:
    MOV AL, ACT_STUDENT_FAIL
    CALL AddLogEntry
    LEA DX, MsgNotFound
    CALL PrintDollar
    CALL PauseScreen
    RET
StudentLogin ENDP
StudentPortal PROC NEAR
StudentPortalLoop:
    CALL ClearScreen
    LEA DX, TitleText
    CALL PrintDollar
    LEA DX, StudentBanner
    CALL PrintDollar
    MOV AL, CurrentIndex
    CALL GetNamePointer
    MOV DX, DI
    CALL PrintZ
    LEA DX, StudentMenu
    CALL PrintDollar
    CALL ReadMenuKey
    CMP AL, '1'
    JNE StudentChoice2
    CALL StudentViewProfile
    JMP StudentPortalLoop
StudentChoice2:
    CMP AL, '2'
    JNE StudentChoice3
    CALL StudentViewFacilities
    JMP StudentPortalLoop
StudentChoice3:
    CMP AL, '3'
    JNE StudentChoice4
    CALL StudentViewAcademic
    JMP StudentPortalLoop
StudentChoice4:
    CMP AL, '4'
    JNE StudentChoice5
    CALL StudentViewAttendance
    JMP StudentPortalLoop
StudentChoice5:
    CMP AL, '5'
    JNE StudentChoiceExit
    CALL StudentViewFeeStatus
    JMP StudentPortalLoop
StudentChoiceExit:
    CMP AL, 'X'
    JNE StudentChoiceBad
    MOV AL, ACT_STUDENT_OUT
    CALL AddLogEntry
    LEA DX, MsgLogout
    CALL PrintDollar
    CALL PauseScreen
    RET
StudentChoiceBad:
    LEA DX, MsgBadChoice
    CALL PrintDollar
    CALL PauseScreen
    JMP StudentPortalLoop
StudentPortal ENDP
PrintClassification PROC NEAR
    CMP AX, 350
    JB ClassCheckMerit
    LEA DX, ClassDistinction
    CALL PrintDollar
    JMP ClassPrintDone
ClassCheckMerit:
    CMP AX, 300
    JB ClassCheckPass
    LEA DX, ClassMerit
    CALL PrintDollar
    JMP ClassPrintDone
ClassCheckPass:
    CMP AX, 200
    JB ClassIsProbation
    LEA DX, ClassPass
    CALL PrintDollar
    JMP ClassPrintDone
ClassIsProbation:
    LEA DX, ClassProbation
    CALL PrintDollar
ClassPrintDone:
    RET
PrintClassification ENDP
PrintRecordSummary PROC NEAR
    MOV WorkIndex, AL
    LEA DX, LabelSeparator
    CALL PrintDollar
    LEA DX, LabelRecord
    CALL PrintDollar
    XOR AX, AX
    MOV AL, WorkIndex
    INC AX
    CALL PrintUInt
    LEA DX, LabelID
    CALL PrintDollar
    MOV AL, WorkIndex
    CALL GetIDPointer
    MOV DX, DI
    CALL PrintZ
    LEA DX, LabelName
    CALL PrintDollar
    MOV AL, WorkIndex
    CALL GetNamePointer
    MOV DX, DI
    CALL PrintZ
    LEA DX, LabelCGPA
    CALL PrintDollar
    MOV AL, WorkIndex
    CALL GetCGPAValue
    CALL PrintCGPA
    LEA DX, LabelClass
    CALL PrintDollar
    MOV AL, WorkIndex
    CALL GetCGPAValue
    CALL PrintClassification
    RET
PrintRecordSummary ENDP
DisplayProfile PROC NEAR
    MOV WorkIndex, AL
    LEA DX, LabelSeparator
    CALL PrintDollar
    LEA DX, LabelRecord
    CALL PrintDollar
    XOR AX, AX
    MOV AL, WorkIndex
    INC AX
    CALL PrintUInt
    LEA DX, LabelName
    CALL PrintDollar
    MOV AL, WorkIndex
    CALL GetNamePointer
    MOV DX, DI
    CALL PrintZ
    LEA DX, LabelID
    CALL PrintDollar
    MOV AL, WorkIndex
    CALL GetIDPointer
    MOV DX, DI
    CALL PrintZ
    LEA DX, LabelCGPA
    CALL PrintDollar
    MOV AL, WorkIndex
    CALL GetCGPAValue
    CALL PrintCGPA
    LEA DX, LabelClass
    CALL PrintDollar
    MOV AL, WorkIndex
    CALL GetCGPAValue
    CALL PrintClassification
    LEA DX, LabelAttendance
    CALL PrintDollar
    MOV AL, WorkIndex
    CALL GetAttendancePointer
    XOR AX, AX
    MOV AL, [DI]
    CALL PrintUInt
    MOV DL, '%'
    CALL PrintCharacter
    LEA DX, LabelFeeStatus
    CALL PrintDollar
    MOV AL, WorkIndex
    XOR AH, AH
    LEA DI, StudentFeeStatus
    ADD DI, AX
    MOV AL, [DI]
    XOR AH, AH
    MOV BX, AX
    CMP BX, 3
    JA FeeStatusUnknown
    SHL BX, 1
    MOV DX, FeeStatusPointers[BX]
    CALL PrintDollar
    JMP FeeStatusDisplayed
FeeStatusUnknown:
    LEA DX, StatusUnknown
    CALL PrintDollar
FeeStatusDisplayed:
    MOV AL, WorkIndex
    CALL DisplayFacilities
    RET
DisplayProfile ENDP
PrintFacilityStatus PROC NEAR
    PUSH BX
    CMP AL, 9
    JA FacilityStatusBad
    XOR AH, AH
    SHL AX, 1
    MOV BX, AX
    MOV DX, StatusPointers[BX]
    JMP FacilityStatusPrint
FacilityStatusBad:
    LEA DX, StatusUnknown
FacilityStatusPrint:
    CALL PrintDollar
    POP BX
    RET
PrintFacilityStatus ENDP
DisplayFacilities PROC NEAR
    PUSH BX
    PUSH CX
    PUSH SI
    LEA DX, LabelFacilities
    CALL PrintDollar
    CALL GetFacilityPointer
    MOV SI, DI
    XOR BX, BX
    MOV CX, FACILITY_COUNT
DisplayFacilityLoop:
    MOV DX, FacilityLabelPointers[BX]
    CALL PrintDollar
    MOV AL, [SI]
    CALL PrintFacilityStatus
    INC SI
    ADD BX, 2
    LOOP DisplayFacilityLoop
    POP SI
    POP CX
    POP BX
    RET
DisplayFacilities ENDP
AdminAddStudent PROC NEAR
    CALL ClearScreen
    LEA DX, AdminBanner
    CALL PrintDollar
    CMP StudentCount, MAX_STUDENTS
    JB AddHasRoom
    LEA DX, MsgFull
    CALL PrintDollar
    CALL PauseScreen
    RET
AddHasRoom:
    CALL InputValidName
AddReadID:
    CALL InputValidID
    LEA DX, TempID
    CALL FindByID
    JC AddUniqueID
    LEA DX, MsgDuplicate
    CALL PrintDollar
    JMP AddReadID
AddUniqueID:
    CALL InputValidCGPA
    PUSH AX
    MOV AL, StudentCount
    CALL GetNamePointer
    LEA SI, TempName
    MOV CX, NAME_SIZE
    CALL CopyToFixed
    MOV AL, StudentCount
    CALL GetIDPointer
    LEA SI, TempID
    MOV CX, ID_SIZE
    CALL CopyToFixed
    MOV AL, StudentCount
    CALL GetCGPAPointer
    POP AX
    MOV [DI], AX
    MOV AL, StudentCount
    CALL GetFacilityPointer
    MOV CX, FACILITY_COUNT
    XOR AL, AL
    REP STOSB
    MOV AL, StudentCount
    CALL GetAttendancePointer
    MOV BYTE PTR [DI], 0
    LEA DI, StudentFeeStatus
    XOR AH, AH
    MOV AL, StudentCount
    ADD DI, AX
    MOV BYTE PTR [DI], 0
    INC StudentCount
    MOV AL, ACT_ADD
    CALL AddLogEntry
    LEA DX, MsgAdded
    CALL PrintDollar
    CALL PauseScreen
    RET
AdminAddStudent ENDP
AdminListStudents PROC NEAR
    CALL ClearScreen
    LEA DX, AdminBanner
    CALL PrintDollar
    CMP StudentCount, 0
    JNE ListHasRecords
    LEA DX, MsgEmpty
    CALL PrintDollar
    CALL PauseScreen
    RET
ListHasRecords:
    MOV LoopByte, 0
ListRecordLoop:
    MOV AL, LoopByte
    CALL PrintRecordSummary
    INC LoopByte
    MOV AL, LoopByte
    CMP AL, StudentCount
    JB ListRecordLoop
    CALL PauseScreen
    RET
AdminListStudents ENDP
PromptAndFind PROC NEAR
    LEA DX, PromptFindID
    CALL PrintDollar
    LEA DX, TempID
    MOV CX, 13
    CALL ReadLine
    LEA DX, TempID
    CALL ValidateID
    JC PromptFindBad
    LEA DX, TempID
    CALL FindByID
    JNC PromptFindExit
PromptFindBad:
    LEA DX, MsgNotFound
    CALL PrintDollar
    STC
PromptFindExit:
    RET
PromptAndFind ENDP
AdminFindStudent PROC NEAR
    CALL ClearScreen
    LEA DX, AdminBanner
    CALL PrintDollar
    CALL PromptAndFind
    JC FindStudentDone
    CALL DisplayProfile
FindStudentDone:
    CALL PauseScreen
    RET
AdminFindStudent ENDP
AdminUpdateStudent PROC NEAR
    CALL ClearScreen
    LEA DX, AdminBanner
    CALL PrintDollar
    CALL PromptAndFind
    JC UpdateFinish
    MOV CurrentIndex, AL
    CALL DisplayProfile
    LEA DX, PromptUpdate
    CALL PrintDollar
    CALL ReadMenuKey
    CMP AL, '1'
    JE UpdateNameOnly
    CMP AL, '2'
    JE UpdateIDOnly
    CMP AL, '3'
    JE UpdateCGPAOnly
    CMP AL, '4'
    JE UpdateAllFields
    LEA DX, MsgCancelled
    CALL PrintDollar
    JMP UpdateFinish
UpdateNameOnly:
    CALL InputValidName
    CALL StoreUpdatedName
    JMP UpdateSuccess
UpdateIDOnly:
    CALL ReadUniqueUpdateID
    CALL StoreUpdatedID
    JMP UpdateSuccess
UpdateCGPAOnly:
    CALL InputValidCGPA
    PUSH AX
    MOV AL, CurrentIndex
    CALL GetCGPAPointer
    POP AX
    MOV [DI], AX
    JMP UpdateSuccess
UpdateAllFields:
    CALL InputValidName
    CALL ReadUniqueUpdateID
    CALL InputValidCGPA
    PUSH AX
    CALL StoreUpdatedName
    CALL StoreUpdatedID
    MOV AL, CurrentIndex
    CALL GetCGPAPointer
    POP AX
    MOV [DI], AX
UpdateSuccess:
    MOV AL, ACT_UPDATE
    CALL AddLogEntry
    LEA DX, MsgUpdated
    CALL PrintDollar
UpdateFinish:
    CALL PauseScreen
    RET
AdminUpdateStudent ENDP
StoreUpdatedName PROC NEAR
    MOV AL, CurrentIndex
    CALL GetNamePointer
    LEA SI, TempName
    MOV CX, NAME_SIZE
    CALL CopyToFixed
    RET
StoreUpdatedName ENDP
StoreUpdatedID PROC NEAR
    MOV AL, CurrentIndex
    CALL GetIDPointer
    LEA SI, TempID
    MOV CX, ID_SIZE
    CALL CopyToFixed
    RET
StoreUpdatedID ENDP
ReadUniqueUpdateID PROC NEAR
UpdateIDAgain:
    CALL InputValidID
    LEA DX, TempID
    CALL FindByID
    JC UpdateIDUnique
    CMP AL, CurrentIndex
    JE UpdateIDUnique
    LEA DX, MsgDuplicate
    CALL PrintDollar
    JMP UpdateIDAgain
UpdateIDUnique:
    RET
ReadUniqueUpdateID ENDP
AdminDeleteStudent PROC NEAR
    CALL ClearScreen
    LEA DX, AdminBanner
    CALL PrintDollar
    CALL PromptAndFind
    JC DeleteFinish
    MOV CurrentIndex, AL
    CALL DisplayProfile
    LEA DX, PromptDelete
    CALL PrintDollar
    CALL ReadMenuKey
    CMP AL, 'Y'
    JE DeleteConfirmed
    LEA DX, MsgCancelled
    CALL PrintDollar
    JMP DeleteFinish
DeleteConfirmed:
    MOV BL, CurrentIndex
DeleteShiftLoop:
    MOV AL, StudentCount
    DEC AL
    CMP BL, AL
    JAE DeleteClearLast
    MOV AL, BL
    MOV AH, BL
    INC AH
    CALL CopyRecord
    INC BL
    JMP DeleteShiftLoop
DeleteClearLast:
    DEC StudentCount
    MOV AL, StudentCount
    CALL ClearRecord
    MOV AL, ACT_DELETE
    CALL AddLogEntry
    LEA DX, MsgDeleted
    CALL PrintDollar
DeleteFinish:
    CALL PauseScreen
    RET
AdminDeleteStudent ENDP
AdminAssignFacility PROC NEAR
    CALL ClearScreen
    LEA DX, AdminBanner
    CALL PrintDollar
    CALL PromptAndFind
    JC AssignFinish
    MOV CurrentIndex, AL
AssignFacilityAgain:
    LEA DX, FacilityMenu
    CALL PrintDollar
    LEA DX, PromptFacility
    CALL PrintDollar
    CALL ReadMenuKey
    CMP AL, '1'
    JB AssignBad
    CMP AL, '8'
    JA AssignBad
    SUB AL, '1'
    MOV SelectedFacility, AL
    LEA DX, StatusMenu
    CALL PrintDollar
    LEA DX, PromptStatus
    CALL PrintDollar
    CALL ReadMenuKey
    CMP AL, '0'
    JB AssignBad
    CMP AL, '9'
    JA AssignBad
    SUB AL, '0'
    MOV SelectedStatus, AL
    MOV AL, CurrentIndex
    CALL GetFacilityPointer
    XOR BX, BX
    MOV BL, SelectedFacility
    MOV AL, SelectedStatus
    MOV [DI+BX], AL
    MOV AL, ACT_FACILITY
    CALL AddLogEntry
    LEA DX, MsgFacility
    CALL PrintDollar
    JMP AssignFinish
AssignBad:
    LEA DX, MsgBadChoice
    CALL PrintDollar
    JMP AssignFacilityAgain
AssignFinish:
    CALL PauseScreen
    RET
AdminAssignFacility ENDP
AdminChangePassword PROC NEAR
    LEA DX, PromptCurrentPass
    CALL PrintDollar
    LEA DX, PasswordBuffer
    MOV CX, 19
    CALL ReadPassword
    LEA SI, PasswordBuffer
    LEA DI, AdminPassword
    CALL StringEqual
    JNC PasswordCurrentOK
    LEA DX, MsgPasswordWrong
    CALL PrintDollar
    CALL PauseScreen
    RET
PasswordCurrentOK:
    LEA DX, PromptNewPass
    CALL PrintDollar
    LEA DX, InputBuffer
    MOV CX, 19
    CALL ReadPassword
    CMP AX, 0
    JE PasswordChangeDone
    LEA SI, InputBuffer
    LEA DI, AdminPassword
    MOV CX, 20
    CALL CopyToFixed
    LEA DX, MsgPasswordChanged
    CALL PrintDollar
PasswordChangeDone:
    CALL PauseScreen
    RET
AdminChangePassword ENDP

AdminAssignAttendance PROC NEAR
    CALL ClearScreen
    LEA DX, AdminBanner
    CALL PrintDollar
    CALL PromptAndFind
    JC AttendanceFinish
AttendanceAgain:
    LEA DX, PromptAttendance
    CALL PrintDollar
    LEA DX, InputBuffer
    MOV CX, 3
    CALL ReadLine
    LEA DX, InputBuffer
    CALL ParseAttendance
    JC AttendanceBad
    MOV WorkIndex, AL
    MOV AL, CurrentIndex
    CALL GetAttendancePointer
    MOV AL, WorkIndex
    MOV [DI], AL
    MOV AL, ACT_UPDATE
    CALL AddLogEntry
    LEA DX, MsgAttendance
    CALL PrintDollar
    JMP AttendanceFinish
AttendanceBad:
    LEA DX, MsgBadAttendance
    CALL PrintDollar
    JMP AttendanceAgain
AttendanceFinish:
    CALL PauseScreen
    RET
AdminAssignAttendance ENDP

AdminAssignFeeStatus PROC NEAR
    CALL ClearScreen
    LEA DX, AdminBanner
    CALL PrintDollar
    CALL PromptAndFind
    JC FeeStatusFinish
FeeStatusAgain:
    LEA DX, FeeStatusMenu
    CALL PrintDollar
    LEA DX, PromptFeeStatus
    CALL PrintDollar
    CALL ReadMenuKey
    CMP AL, '0'
    JB FeeStatusBad
    CMP AL, '3'
    JA FeeStatusBad
    SUB AL, '0'
    MOV WorkIndex, AL
    XOR AH, AH
    LEA DI, StudentFeeStatus
    MOV AL, CurrentIndex
    ADD DI, AX
    MOV AL, WorkIndex
    MOV [DI], AL
    MOV AL, ACT_UPDATE
    CALL AddLogEntry
    LEA DX, MsgFeeStatus
    CALL PrintDollar
    JMP FeeStatusFinish
FeeStatusBad:
    LEA DX, MsgBadFeeStatus
    CALL PrintDollar
    JMP FeeStatusAgain
FeeStatusFinish:
    CALL PauseScreen
    RET
AdminAssignFeeStatus ENDP

ParseAttendance PROC NEAR
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    MOV SI, DX
    XOR AX, AX
ParseAttendanceLoop:
    MOV DL, [SI]
    OR DL, DL
    JZ ParseAttendanceDone
    CMP DL, '0'
    JB ParseAttendanceBad
    CMP DL, '9'
    JA ParseAttendanceBad
    SUB DL, '0'
    XOR DH, DH
    MOV BX, DX
    MOV DX, 10
    MUL DX
    ADD AX, BX
    CMP AX, 100
    JA ParseAttendanceBad
    INC SI
    JMP ParseAttendanceLoop
ParseAttendanceDone:
    CLC
    JMP ParseAttendanceExit
ParseAttendanceBad:
    XOR AX, AX
    STC
ParseAttendanceExit:
    POP SI
    POP DX
    POP CX
    POP BX
    RET
ParseAttendance ENDP

CalculateStatistics PROC NEAR
    MOV SumCGPA, 0
    MOV CountDistinction, 0
    MOV CountMerit, 0
    MOV CountPass, 0
    MOV CountProbation, 0
    CMP StudentCount, 0
    JE StatisticsCalculated
    MOV AL, 0
    CALL GetCGPAValue
    MOV HighCGPA, AX
    MOV LowCGPA, AX
    MOV LoopByte, 0
StatisticsLoop:
    MOV AL, LoopByte
    CALL GetCGPAValue
    ADD SumCGPA, AX
    CMP AX, HighCGPA
    JBE StatisticsNotHigh
    MOV HighCGPA, AX
StatisticsNotHigh:
    CMP AX, LowCGPA
    JAE StatisticsNotLow
    MOV LowCGPA, AX
StatisticsNotLow:
    CMP AX, 350
    JB StatisticsMerit
    INC CountDistinction
    JMP StatisticsNext
StatisticsMerit:
    CMP AX, 300
    JB StatisticsPass
    INC CountMerit
    JMP StatisticsNext
StatisticsPass:
    CMP AX, 200
    JB StatisticsProbation
    INC CountPass
    JMP StatisticsNext
StatisticsProbation:
    INC CountProbation
StatisticsNext:
    INC LoopByte
    MOV AL, LoopByte
    CMP AL, StudentCount
    JB StatisticsLoop
    MOV AX, SumCGPA
    XOR DX, DX
    XOR BX, BX
    MOV BL, StudentCount
    DIV BX
    MOV AverageCGPA, AX
StatisticsCalculated:
    RET
CalculateStatistics ENDP
ShowStatistics PROC NEAR
    CALL ClearScreen
    LEA DX, AdminBanner
    CALL PrintDollar
    CMP StudentCount, 0
    JNE StatisticsShow
    LEA DX, MsgEmpty
    CALL PrintDollar
    CALL PauseScreen
    RET
StatisticsShow:
    CALL CalculateStatistics
    LEA DX, LabelStudentCount
    CALL PrintDollar
    XOR AX, AX
    MOV AL, StudentCount
    CALL PrintUInt
    LEA DX, LabelAverage
    CALL PrintDollar
    MOV AX, AverageCGPA
    CALL PrintCGPA
    LEA DX, LabelHighest
    CALL PrintDollar
    MOV AX, HighCGPA
    CALL PrintCGPA
    LEA DX, LabelLowest
    CALL PrintDollar
    MOV AX, LowCGPA
    CALL PrintCGPA
    LEA DX, LabelDistCount
    CALL PrintDollar
    XOR AX, AX
    MOV AL, CountDistinction
    CALL PrintUInt
    LEA DX, LabelMeritCount
    CALL PrintDollar
    XOR AX, AX
    MOV AL, CountMerit
    CALL PrintUInt
    LEA DX, LabelPassCount
    CALL PrintDollar
    XOR AX, AX
    MOV AL, CountPass
    CALL PrintUInt
    LEA DX, LabelProbCount
    CALL PrintDollar
    XOR AX, AX
    MOV AL, CountProbation
    CALL PrintUInt
    MOV AL, ACT_REPORT
    CALL AddLogEntry
    CALL PauseScreen
    RET
ShowStatistics ENDP
BuildSortedIndex PROC NEAR
    MOV LoopByte, 0
BuildIndexLoop:
    MOV AL, LoopByte
    XOR BX, BX
    MOV BL, LoopByte
    MOV SortIndex[BX], AL
    INC LoopByte
    MOV AL, LoopByte
    CMP AL, StudentCount
    JB BuildIndexLoop
    MOV SortI, 0
SortOuterLoop:
    MOV AL, SortI
    CMP AL, StudentCount
    JAE SortIndexDone
    MOV SortBest, AL
    MOV SortJ, AL
    INC SortJ
SortInnerLoop:
    MOV AL, SortJ
    CMP AL, StudentCount
    JAE SortSwap
    XOR BX, BX
    MOV BL, SortJ
    MOV AL, SortIndex[BX]
    CALL GetCGPAValue
    MOV DX, AX
    XOR BX, BX
    MOV BL, SortBest
    MOV AL, SortIndex[BX]
    CALL GetCGPAValue
    CMP DX, AX
    JBE SortNoNewBest
    MOV AL, SortJ
    MOV SortBest, AL
SortNoNewBest:
    INC SortJ
    JMP SortInnerLoop
SortSwap:
    XOR BX, BX
    MOV BL, SortI
    MOV AL, SortIndex[BX]
    XOR SI, SI
    MOV SI, BX
    XOR BX, BX
    MOV BL, SortBest
    XCHG AL, SortIndex[BX]
    MOV SortIndex[SI], AL
    INC SortI
    JMP SortOuterLoop
SortIndexDone:
    RET
BuildSortedIndex ENDP
ShowSortedReport PROC NEAR
    CALL ClearScreen
    LEA DX, LabelSorted
    CALL PrintDollar
    CMP StudentCount, 0
    JNE SortedHasData
    LEA DX, MsgEmpty
    CALL PrintDollar
    CALL PauseScreen
    RET
SortedHasData:
    LEA DX, MsgSortedNote
    CALL PrintDollar
    CALL BuildSortedIndex
    MOV LoopByte, 0
SortedPrintLoop:
    LEA DX, LabelRank
    CALL PrintDollar
    XOR AX, AX
    MOV AL, LoopByte
    INC AX
    CALL PrintUInt
    XOR BX, BX
    MOV BL, LoopByte
    MOV AL, SortIndex[BX]
    CALL PrintRecordSummary
    INC LoopByte
    MOV AL, LoopByte
    CMP AL, StudentCount
    JB SortedPrintLoop
    MOV AL, ACT_REPORT
    CALL AddLogEntry
    CALL PauseScreen
    RET
ShowSortedReport ENDP
AddLogEntry PROC NEAR
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    MOV CurrentAction, AL
    MOV AH, 2CH
    INT 21H
    XOR AX, AX
    MOV AL, LogNext
    MOV SI, AX
    MOV LogHours[SI], CH
    MOV LogMinutes[SI], CL
    MOV LogSeconds[SI], DH
    MOV AL, CurrentAction
    MOV LogActions[SI], AL
    INC LogNext
    CMP LogNext, LOG_CAPACITY
    JB AddLogNoWrap
    MOV LogNext, 0
AddLogNoWrap:
    CMP LogCount, LOG_CAPACITY
    JAE AddLogDone
    INC LogCount
AddLogDone:
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
AddLogEntry ENDP
GetActionPointer PROC NEAR
    PUSH AX
    PUSH BX
    CMP AL, ACT_START
    JB ActionPointerBad
    CMP AL, ACT_EXIT
    JA ActionPointerBad
    DEC AL
    XOR AH, AH
    SHL AX, 1
    MOV BX, AX
    MOV DX, ActionPointers[BX]
    JMP ActionPointerDone
ActionPointerBad:
    LEA DX, ActionUnknown
ActionPointerDone:
    POP BX
    POP AX
    RET
GetActionPointer ENDP
ShowActivityLog PROC NEAR
    CALL ClearScreen
    LEA DX, LabelLog
    CALL PrintDollar
    CMP LogCount, 0
    JNE LogHasEntries
    LEA DX, MsgNoLogs
    CALL PrintDollar
    CALL PauseScreen
    RET
LogHasEntries:
    MOV AL, LogNext
    CMP LogCount, LOG_CAPACITY
    JE LogStartReady
    MOV AL, LogNext
    SUB AL, LogCount
    JNC LogStartReady
    ADD AL, LOG_CAPACITY
LogStartReady:
    MOV WorkIndex, AL
    MOV LoopByte, 0
LogDisplayLoop:
    CALL PrintCRLF
    XOR BX, BX
    MOV BL, WorkIndex
    MOV AL, LogHours[BX]
    CALL PrintTwoDigits
    MOV DL, ':'
    CALL PrintCharacter
    MOV AL, LogMinutes[BX]
    CALL PrintTwoDigits
    MOV DL, ':'
    CALL PrintCharacter
    MOV AL, LogSeconds[BX]
    CALL PrintTwoDigits
    LEA DX, LabelDash
    CALL PrintDollar
    MOV AL, LogActions[BX]
    CALL GetActionPointer
    CALL PrintDollar
    INC WorkIndex
    CMP WorkIndex, LOG_CAPACITY
    JB LogIndexReady
    MOV WorkIndex, 0
LogIndexReady:
    INC LoopByte
    MOV AL, LoopByte
    CMP AL, LogCount
    JB LogDisplayLoop
    CALL PauseScreen
    RET
ShowActivityLog ENDP
SaveDatabase PROC NEAR
    LEA DX, DatabaseFile
    MOV CX, 0
    MOV AH, 3CH
    INT 21H
    JC SaveFailed
    MOV FileHandle, AX
    MOV BX, AX
    LEA DX, FileMagic
    MOV CX, DB_SIZE
    MOV AH, 40H
    INT 21H
    JC SaveCloseFailed
    CMP AX, DB_SIZE
    JNE SaveCloseFailed
    MOV BX, FileHandle
    MOV AH, 3EH
    INT 21H
    JC SaveFailed
    MOV AL, ACT_SAVE
    CALL AddLogEntry
    LEA DX, MsgSaved
    CALL PrintDollar
    CALL PauseScreen
    RET
SaveCloseFailed:
    MOV BX, FileHandle
    MOV AH, 3EH
    INT 21H
SaveFailed:
    MOV AL, ACT_SAVE_FAIL
    CALL AddLogEntry
    LEA DX, MsgSaveError
    CALL PrintDollar
    CALL PauseScreen
    RET
SaveDatabase ENDP
LoadDatabase PROC NEAR
    LEA DX, DatabaseFile
    MOV AL, 0
    MOV AH, 3DH
    INT 21H
    JC LoadOpenFailed
    MOV FileHandle, AX
    MOV BX, AX
    LEA DX, LoadBuffer
    MOV CX, DB_SIZE
    MOV AH, 3FH
    INT 21H
    JC LoadCloseFailed
    CMP AX, DB_SIZE
    JNE LoadCorruptClose
    MOV BX, FileHandle
    LEA DX, InputBuffer
    MOV CX, 1
    MOV AH, 3FH
    INT 21H
    JC LoadCloseFailed
    CMP AX, 0
    JNE LoadCorruptClose
    MOV BX, FileHandle
    MOV AH, 3EH
    INT 21H
    JC LoadOpenFailed
    CMP BYTE PTR LoadBuffer, 'S'
    JNE LoadCorrupt
    CMP BYTE PTR LoadBuffer+1, 'D'
    JNE LoadCorrupt
    CMP BYTE PTR LoadBuffer+2, 'B'
    JNE LoadCorrupt
    CMP BYTE PTR LoadBuffer+3, '1'
    JNE LoadCorrupt
    CMP BYTE PTR LoadBuffer+4, 3
    JNE LoadCorrupt
    CMP BYTE PTR LoadBuffer+5, MAX_STUDENTS
    JA LoadCorrupt
    LEA SI, LoadBuffer
    LEA DI, FileMagic
    MOV CX, DB_SIZE
    REP MOVSB
    MOV AL, ACT_LOAD
    CALL AddLogEntry
    LEA DX, MsgLoaded
    CALL PrintDollar
    CALL PauseScreen
    RET
LoadCorruptClose:
    MOV BX, FileHandle
    MOV AH, 3EH
    INT 21H
LoadCorrupt:
    MOV AL, ACT_LOAD_FAIL
    CALL AddLogEntry
    LEA DX, MsgCorrupt
    CALL PrintDollar
    CALL PauseScreen
    RET
LoadCloseFailed:
    MOV BX, FileHandle
    MOV AH, 3EH
    INT 21H
LoadOpenFailed:
    MOV AL, ACT_LOAD_FAIL
    CALL AddLogEntry
    LEA DX, MsgLoadError
    CALL PrintDollar
    CALL PauseScreen
    RET
LoadDatabase ENDP
StudentViewProfile PROC NEAR
    CALL ClearScreen
    LEA DX, StudentBanner
    CALL PrintDollar
    MOV AL, CurrentIndex
    CALL DisplayProfile
    CALL PauseScreen
    RET
StudentViewProfile ENDP
StudentViewFacilities PROC NEAR
    CALL ClearScreen
    LEA DX, StudentBanner
    CALL PrintDollar
    MOV AL, CurrentIndex
    CALL DisplayFacilities
    CALL PauseScreen
    RET
StudentViewFacilities ENDP
StudentViewAcademic PROC NEAR
    CALL ClearScreen
    LEA DX, StudentBanner
    CALL PrintDollar
    LEA DX, LabelName
    CALL PrintDollar
    MOV AL, CurrentIndex
    CALL GetNamePointer
    MOV DX, DI
    CALL PrintZ
    LEA DX, LabelCGPA
    CALL PrintDollar
    MOV AL, CurrentIndex
    CALL GetCGPAValue
    CALL PrintCGPA
    LEA DX, LabelClass
    CALL PrintDollar
    MOV AL, CurrentIndex
    CALL GetCGPAValue
    CALL PrintClassification
    CALL PauseScreen
    RET
StudentViewAcademic ENDP
StudentViewAttendance PROC NEAR
    CALL ClearScreen
    LEA DX, StudentBanner
    CALL PrintDollar
    LEA DX, LabelName
    CALL PrintDollar
    MOV AL, CurrentIndex
    CALL GetNamePointer
    MOV DX, DI
    CALL PrintZ
    LEA DX, LabelAttendance
    CALL PrintDollar
    MOV AL, CurrentIndex
    CALL GetAttendancePointer
    XOR AX, AX
    MOV AL, [DI]
    CALL PrintUInt
    MOV DL, '%'
    CALL PrintCharacter
    CALL PauseScreen
    RET
StudentViewAttendance ENDP
StudentViewFeeStatus PROC NEAR
    CALL ClearScreen
    LEA DX, StudentBanner
    CALL PrintDollar
    LEA DX, LabelName
    CALL PrintDollar
    MOV AL, CurrentIndex
    CALL GetNamePointer
    MOV DX, DI
    CALL PrintZ
    LEA DX, LabelFeeStatus
    CALL PrintDollar
    XOR AH, AH
    LEA DI, StudentFeeStatus
    MOV AL, CurrentIndex
    ADD DI, AX
    MOV AL, [DI]
    XOR AH, AH
    MOV BX, AX
    CMP BX, 3
    JA StudentFeeUnknown
    SHL BX, 1
    MOV DX, FeeStatusPointers[BX]
    CALL PrintDollar
    JMP StudentFeeDone
StudentFeeUnknown:
    LEA DX, StatusUnknown
    CALL PrintDollar
StudentFeeDone:
    CALL PauseScreen
    RET
StudentViewFeeStatus ENDP
END MAIN
