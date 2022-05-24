//
// TTCN-3 Grammar
// ==============
//
// This Grammar is still very much work in progress.


//
// Modules, module defintions and declarations.
// --------------------------------------------
//

Module: 'module' Name Language? '{' (ModuleDef ';'?)* '}' With? ';'?

ModuleDef
    : Altstep
    | BehaviorType
    | Class
    | Component
    | Config
    | Enum
    | Friend
    | Function
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
    | VarDecl
    ;

// Group declaration
Group: Visibility? 'group' Name '{' (ModuleDef ';'?)* '}' With?;

// Friend declaration
Friend: Visibility? 'friend' 'module' Refs With?;

// Import declaration
Import: Visibility? 'import' 'from' REF ('->' Name)? ('all' ExceptSpec? | ImportSpec) With?;

ExceptSpec: 'except' '{' ( ExceptStmt ';'? )* '}';
ExceptStmt:
    : ImportKind (Refs|"all")
    | "group"    (Refs|"all")
    ;

ImportSpec:'{' ( ImportStmt ';'? )* '}';
ImportStmt
    : ImportKind (Refs|"all" ("except" Refs)?)
    | "group"    (REF ExceptSpec?)+
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
Signature: Visibility? 'signature' Name FormalPars ('return' REF | 'noblock')? Exception? With?;

// Component declaration
Component: Visibility? 'type' 'component' Name Extends? '{' ComponentBody '}' With?;

// Port declaration
Port: Visibility? 'type' 'port' Name ('message'|'procedure'|'stream') 'realtime'? ('map' 'to' Refs)? ('connect' 'to' Refs)? '{' (PortAttribute ';'?)* '}' With?;

PortAttribute
    : 'map'   'param' FormalPars
    | 'unmap' 'param' FormalPars
    | 'address' REF PortTranslation?
    | ('in'|'out'|'inout') (REF  PortTranslation? ','? )+
    ;

PortTranslation:('from'|'to') (REF 'with' REF '(' ')' ','?)*)?;

// User defined types

SubType: Visibility? 'type' REF Name ArrayDef? ValueConstraints? With?;

Struct: Visibility? 'type' ('record'|'set'|'union') Name
        '{'
           ( "@default"? NestedType Name ArrayDef? Constraint? ','? )*
	'}' With?;


List: Visibility? 'type' ('record'|'set') ('length' '(' Expr ')')? 'of' NestedType Name With?;

Enum: Visibility? 'type' 'enumerated' Name
      '{'
          ( Name ('(' Expr ')')? ','? )*
      '}' With?;

Map: Visibility? 'type' 'map' 'from' REF 'to' REF Name With?;

Class: Visibility? 'type' 'external'? 'class' MODIF* Name Extends? ConfigSpec* ClassBody ('finally' Block)? With?;

TestcaseType: Visibility? 'type' 'testcase' Name FormalPars ConfigSpec* With?;

FunctionType: Visibility? 'type' 'function' MODIF* Name FormalPars ConfigSpec* ReturnSpec? With?;

AltstepType: Visibility? 'type' 'altstep' MODIF* 'interleave'? Name FormalPars ConfigSpec* With?;


// Variable declaration and module parameters.

VarDecl: Visibility? ('const'|'var'|'modulepar') 'template'? Restriction? MODIF* REF Declarator ( ',' Declarator)* With?;

Declarator: Name (':=' Expr)?

// Temaplte declaration
Template: Visibility? 'template' Restriction? MODIF* REF Name FormalPars? ('modifies' REF)? ':=' Expr With?;

// Testcase declaration
Testcase: Visibility? 'testcase' Name FormalPars ConfigSpec* Block;

// Function declaration
FuncDecl: Visibility? 'external'? 'function' MODIF* Name FormalPars ConfigSpec* ReturnSpec? Exception? Block? With?;

// Configuration declaration
Config: Visibility? 'configuration' Name FormalPars ConfigSpec* Block With?;

// Altstep declaration
Altstep: Visibility? 'altstep' MODIF* 'interleave'? Name FormalPars ConfigSpec* Block With?;

//
// Statements
// ----------
//

Stmt
    : Expr
    | VarDecl
    | Template
    | Block
    | IfStmt
    | SelectStmt
    | ForStmt
    | WhileStmt
    | DoStmt
    | JumpStmt
    | ReturnStmt
    | AltStmt
    ;


IfStmt     : 'if' '(' Expr ')' Block {'else' 'if' '(' Expr ')'} ('else' Block)?;
SelectStmt : 'select' ('union'|'class')? '(' Expr ')' SelectBody;
ForStmt    : 'for' '(' (AssignStmt|VarDecl); Expr; AssignStmt ')' Block;
WhileStmt  : 'while' '(' Expr ')' Block;
DoStmt     : 'do' Block 'while' '(' Expr ')';
JumpStmt   : ('label'|'goto') ID;
ReturnStmt : 'return' Expr?;
AltStmt    : ('alt'|'interleave') MODIF* Block;

Block: BasicBlock ('catch' '(' Ref Name ')' BasicBlock)? ('finally' BasicBlock)?;

BasicBlock: '{' ( Stmt ';'? )* '}';

Refs: REF { ',' REF }

Extends: 'extends' Refs
Language: 'language' STRING { ',' STRING }
ReturnSpec: 'return' 'template'? Restriction? REF ArrayDef? ;

ValueConstraints: '(' Expr { ',' Expr } ')';

ConfigSpec
: 'runs' 'on' REF
| 'system' REF
| 'mtc' REF
| 'port' REF
| 'execute' 'on' REF
;

Exception: 'exception' '(' Refs ')'
# Secondary rules
FormalPars
ArrayDef
ExceptSpec
ImportSpec
AllRef

With     : 'with' '{' { WithStmt} '}'
WithStmt :  ('encode'|'variant'|'display'|'extension'|'optional') ('override'|'@local')? (REF|AllRef)? STRING 

Visibility :'private'|'public'|'friend'

Name:ID;
REF
    : ID TypePars?
    | 'any'
    | 'any' 'component'
    | 'any' 'port'
    | 'any' 'timer'
    | 'all' 'component'
    | 'all' 'port'
    | 'all' 'timer'
    | 'address'
    | 'system'
    | 'mtc'
    | 'map'
    | 'timer'
    | 'unmap'
    ;

TypePars: '<' TypePar { ',' TypePar } '>'
TypePar: Todo

NestedType:
GuardStmt  : '[' Expr? ']' Stmt
CaseStmt   : 'case' ('else'|'(' Expr ')') Block
ClassBody
ModuleBody
ComponentBody
StructBody
EnumBody
SelectBody
