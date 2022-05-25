// TTCN-3 Grammar
// ==============
//
// This Grammar is still very much work in progress.
//

grammar ttcn3;

//
// Modules, module defintions and declarations.
// --------------------------------------------
//

Module: 'module' Name Language? '{' (ModuleDef ';'?)* '}' With? ';'?;

ModuleDef
    : Altstep
    | AltstepType
    | Class
    | Component
    | Config
    | Enum
    | Friend
    | Function
    | FunctionType
    | Group
    | Import
    | List
    | Map
    | Port
    | Signature
    | Struct
    | SubType
    | Template
    | Testcase
    | TestcaseType
    | VarDecl
    ;

// Group declaration
Group: Visibility? 'group' Name '{' (ModuleDef ';'?)* '}' With?;

// Friend declaration
Friend: Visibility? 'friend' 'module' Refs With?;

// Import declaration
Import: Visibility? 'import' 'from' Ref ('->' Name)? ('all' ExceptSpec? | ImportSpec) With?;

ExceptSpec: 'except' '{' ( ExceptStmt ';'? )* '}';
ExceptStmt
    : ImportKind (Refs|'all')
    | 'group'    (Refs|'all')
    ;

ImportSpec:'{' ( ImportStmt ';'? )* '}';
ImportStmt
    : ImportKind (Refs|'all' ('except' Refs)?)
    | 'group'    (Ref ExceptSpec?)+
    ;

ImportKind
    : 'altstep'
    | 'const'
    | 'function'
    | 'import'
    | 'modulepar'
    | 'signature'
    | 'template'
    | 'testcase'
    | 'type'
    ;

// Signature declaration
Signature: Visibility? 'signature' Name FormalPars ('return' Ref | 'noblock')? Exception? With?;

// Component declaration
Component: Visibility? 'type' 'component' Name Extends? Block With?;

// Port declaration
Port: Visibility? 'type' 'port' Name ('message'|'procedure'|'stream') 'realtime'? ('map' 'to' Refs)? ('connect' 'to' Refs)? '{' (PortAttribute ';'?)* '}' With?;

PortAttribute
    : 'map'   'param' FormalPars
    | 'unmap' 'param' FormalPars
    | 'address' Ref PortTranslation?
    | ('in'|'out'|'inout') PortElement (',' PortElement)* ','?
    ;

PortElement: Ref PortTranslation?;
PortTranslation:('from'|'to') Ref 'with' Ref '(' ')';

// User defined types

SubType: Visibility? 'type' Ref Name ArrayDef* ValueConstraints? With?;

Struct: Visibility? 'type' ('record'|'set'|'union') Name
        '{'
           StructMember ((','|';') StructMember)* (','|';')?
	'}' With?;

StructMember: '@default'? NestedType Name ArrayDef* ValueConstraints?;

List: Visibility? 'type' ('record'|'set') ('length' '(' Expr ')')? 'of' NestedType Name With?;

Enum: Visibility? 'type' 'enumerated' Name
      '{'
          EnumLabel ((','|';') EnumLabel)* (','|';')?
      '}' With?;

EnumLabel: Name ('(' Expr ')')?;

Map: Visibility? 'type' 'map' 'from' Ref 'to' Ref Name With?;

Class: Visibility? 'type' 'external'? 'class' MODIF* Name Extends? ConfigSpec* ClassBody ('finally' Block)? With?;

TestcaseType: Visibility? 'type' 'testcase' Name FormalPars ConfigSpec* With?;

FunctionType: Visibility? 'type' 'function' MODIF* Name FormalPars ConfigSpec* ReturnSpec? With?;

AltstepType: Visibility? 'type' 'altstep' MODIF* 'interleave'? Name FormalPars ConfigSpec* With?;


// Variable declaration and module parameters.

VarDecl: Visibility? ('const'|'var'|'modulepar') NestedTemplate? MODIF* Ref Declarator ( ',' Declarator)* With?;

TimerDecl: 'timer' Declarator ( ',' Declarator)* With?;
PortDecl: 'port' Ref Declarator ( ',' Declarator)* With?;

// Template declaration
Template: Visibility? 'template' ( '(' TemplateRestriction ')')? MODIF* Ref Name FormalPars? ('modifies' Ref)? ':=' Expr With?;

// Testcase declaration
Testcase: Visibility? 'testcase' Name FormalPars ConfigSpec* Block;

// Function declaration
Function: Visibility? 'external'? 'function' MODIF* Name FormalPars ConfigSpec* ReturnSpec? Exception? Block? With?;

// Configuration declaration
Config: Visibility? 'configuration' Name FormalPars ConfigSpec* Block With?;

// Altstep declaration
Altstep: Visibility? 'altstep' MODIF* 'interleave'? Name FormalPars ConfigSpec* Block With?;

//
// Statements
// ----------
//

Stmt
    : AltStmt
    | AssignStmt
    | Block
    | DoStmt
    | Expr
    | ForStmt
    | GotoStmt
    | GuardStmt
    | IfStmt
    | LabelStmt
    | PortDecl
    | ReturnStmt
    | SelectStmt
    | Template
    | TimerDecl
    | VarDecl
    | WhileStmt
    ;

IfStmt     : 'if' '(' ((AssignStmt|VarDecl) ';')? Expr ')' Block ('else' 'if' '(' Expr ')')* ('else' Block)?;
SelectStmt : 'select' ('union'|'class')? '(' Expr ')' '{' ( 'case' ('else'|'(' Expr ')') Block )* '}';
ForStmt    : 'for' '(' (AssignStmt|VarDecl) ('in' Ref|';' Expr';' AssignStmt) ')' Block;
WhileStmt  : 'while' '(' Expr ')' Block;
DoStmt     : 'do' Block 'while' '(' Expr ')';
GotoStmt   : 'goto' Ref;
LabelStmt  : 'label' Name;
ReturnStmt : 'return' Expr?;
AltStmt    : ('alt'|'interleave') MODIF* Block;
AssignStmt : Ref ':=' Expr;
GuardStmt  : '[' Expr? ']' Stmt;


Block: BasicBlock ('catch' '(' Ref Name ')' BasicBlock)? ('finally' BasicBlock)?;

BasicBlock: '{' ( Stmt ';'? )* '}';


//
// Fragments, building blocks and helpers
// --------------------------------------
//

With     : 'with' '{' WithStmt* '}';

WithStmt :  ('encode'|'variant'|'display'|'extension'|'optional') ('override'|'@local')? ('(' WithQualifier ','? ')')? STRING;

WithQualifier
    : Ref
    | '[' Expr ']'
    | WithKind ( 'except' '{' Refs '}' )?
    ;

WithKind
    : 'altstep'
    | 'const'
    | 'function'
    | 'group'
    | 'modulepar'
    | 'signature'
    | 'template'
    | 'testcase'
    | 'type'
    ;

Refs: Ref ( ',' Ref )* ','?;

Extends: 'extends' Refs;
Language: 'language' STRING ( ',' STRING )* ','?;
ReturnSpec: 'return' NestedTemplate? Ref ArrayDef* ;

ValueConstraints: '(' Expr ( ',' Expr )* ','? ')';

ConfigSpec
    : 'runs' 'on' Ref
    | 'system' Ref
    | 'mtc' Ref
    | 'port' Ref
    | 'execute' 'on' Ref
    ;

Exception: 'exception' '(' Refs ')';


Visibility: 'private'|'public'|'friend';

Name: ID;
Ref : ID TypePars?
    | 'address'
    | 'all' 'component'
    | 'all' 'port'
    | 'all' 'timer'
    | 'any'
    | 'any' 'component'
    | 'any' 'port'
    | 'any' 'timer'
    | 'map'
    | 'mtc'
    | 'self'
    | 'system'
    | 'this'
    | 'timer'
    | 'unmap'
    ;

TypePars: '<' TypePar (',' TypePar)* ','? '>';
TypePar: 'in'? ('type'|'signature'|Ref) Declarator;

FormalPars: '(' FormalPar (',' FormalPar)* ','? ')';
FormalPar: ('in'|'out'|'inout') Ref Declarator;

Declarator: Name ArrayDef* (':=' Expr)?;

ArrayDef: '[' Expr ']';

TemplateRestriction: 'omit' | 'value' | 'present';


NestedTemplate
    : template
    | template ( TemplateRestriction )
    | TemplateRestriction
    ;


ID: [a-zA-Z0-9-]+;
MODIF: '@' ID;
STRING: '"' ( '""' | ~('\\'|'"') )* '"';

