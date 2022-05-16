# TTCN-3 Grammar
# ==============
#
# This Grammar is still very much work in progress.


Module: 'module' NAME Language? '{' {ModuleDef} '}';
ModuleDef: Visibility? Decl With? ';'?;

# Decl produces top-level declarations such as templates, functions, imports, ...
Decl
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

# Group declaration
Group     : 'group' NAME '{' {ModuleDef} '}' ;

# Friend declaration
Friend    : 'friend' 'module' Refs;


# Import declaration
Import    : 'import' 'from' REF ('->' NAME)? ('all' ('except' '{' {ExceptSpec} '}')?|'{' {ImportSpec} '}') ;
ExceptSpec: Kind ('all'|Refs)
ImportSpec:

Kind
  : 'altstep'
  | 'const'
  | 'function'
  | 'group'
  | 'import'
  | 'modulepar'
  | 'signature'
  | 'template'
  | 'testcase'
  | 'type'
  ;

Signature : 'signature' NAME FormalPars ('return' REF | 'noblock')? Exception?;
Component : 'type' 'component' NAME Extends? '{' ComponentBody '}' ;
Port      : 'type' 'port' NAME ('message'|'procedure'|'stream') 'realtime'? '{' PortBody '}' ;
SubType   : 'type' REF NAME ArrayDef ValueConstraints?;
Struct    : 'type' ('record'|'set'|'union') NAME { StructBody };
List      : 'type' ('record'|'set') ('length' '(' Expr ')')? 'of' REF NAME;
Enum      : 'type' 'enumerated' NAME '{' EnumBody '}' ;
Map       : 'type' 'map' 'from' REF 'to' REF NAME ;
Class     : 'type' 'external'? 'class' Modifier? Name Extends? {ConfigSpec} ClassBody ('finally' Block)? ;

TestcaseType : 'type' 'testcase' NAME FormalPars {ConfigSpec};
FunctionType : 'type' 'function' Modifiers NAME FormalPars {ConfigSpec} ReturnSpec? ;
AltstepType  : 'type' 'altstep' Modifiers 'interleave'? NAME FormalPars {ConfigSpec} ;

VarDecl  : ('const'|'var'|'modulepar') 'template'? Restriction? Modifiers REF { NAME ArrayDef                      ':=' Expr ','? ... };
Template :                              'template'  Restriction? Modifiers REF   NAME FormalPars? ('modifies' REF)? ':=' Expr;
Testcase : 'testcase' NAME FormalPars {ConfigSpec} Block;
FuncDecl : 'external'? 'function' Modifiers NAME FormalPars {ConfigSpec} ReturnSpec? Exception? Block?;
Config   : 'configuration' NAME FormalPars {ConfigSpec} Block;
Altstep  : 'altstep' Modifiers 'interleave'? NAME FormalPars {ConfigSpec} Block;


# Statements

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

IfStmt     : 'if' '(' Expr ')' Block {'else' 'if' '(' Expr ')'} ('else' Block)?
SelectStmt : 'select' ('union'|'class')? '(' Expr ')' SelectBody
ForStmt    : 'for' '(' (AssignStmt|VarDecl); Expr; AssignStmt ')' Block
WhileStmt  : 'while' '(' Expr ')' Block
DoStmt     : 'do' Block 'while' '(' Expr ')'
JumpStmt   : ('label'|'goto') ID
ReturnStmt : 'return' Expr?
AltStmt    : ('alt'|'interleave') Modifiers? Block



Refs: REF { ',' REF }

Extends: 'extends' Refs
Lanugage: 'language' STRING { ',' STRING }
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
Block 
FormalPars
ArrayDef
ExceptSpec
ImportSpec
AllRef

With     : 'with' '{' { WithStmt} '}'
WithStmt :  ('encode'|'variant'|'display'|'extension'|'optional') ('override'|'@local')? (REF|AllRef)? STRING 

Visibility :'private'|'public'|'friend'
Modifiers : { MODIF }

PortBody := 'address' Ref;
| 'map' 'param' FormalPars
| 'unmap' 'param' FormalPars
| ('in'|'out'|'inout') {REF (('from'|'to') {REF 'with' REF '()' ','?})? ','? }+

NAME:ID
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

GuardStmt  : '[' Expr? ']' Stmt
CaseStmt   : 'case' ('else'|'(' Expr ')') Block
ClassBody
ModuleBody
ComponentBody
StructBody
EnumBody
SelectBody
