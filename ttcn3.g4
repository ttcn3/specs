# TTCN-3 Grammar
# ==============
#
# This Grammar is still very much work in progress.


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

# Group declaration
Group: Visibility? 'group' Name '{' (ModuleDef ';'?)* '}' With?

# Friend declaration
Friend: Visibility? 'friend' 'module' Refs With?

# Import declaration
Import: Visibility? 'import' 'from' REF ('->' Name)? ('all' ExceptSpec? | ImportSpec);
    ;

ExceptSpec: 'except' '{' ( ExceptStmt ';'? )* '}';
ExceptStmt:
    : ImportKind (Refs|"all")
    | "group"    (Refs|"all")
    ;

ImportSpec:'{' ( ImportStmt ';'? )* '}';
ImportStmt
    : ImportKind (Refs|"all" ("except" Refs)?)
    | "group"    (Ref ExceptSpec?)+
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

# Signature declaration
Signature: 'signature' Name FormalPars ('return' REF | 'noblock')? Exception?;

# Component declaration
Component: 'type' 'component' Name Extends? '{' ComponentBody '}';

# Port declaration
Port: 'type' 'port' Name ('message'|'procedure'|'stream') 'realtime'? ('map' 'to' Refs)? ('connect' 'to' Refs)? '{' (PortAttribute ';'?)* '}';

PortAttribute
   : 'address' Ref;
   | 'map' 'param' FormalPars
   | 'unmap' 'param' FormalPars
   | ('in'|'out'|'inout') (REF  PortTranslation? ','? )+
   ;

PortTranslation:('from'|'to') (REF 'with' REF '(' ')' ','?)*)?;

SubType   : 'type' REF Name ArrayDef ValueConstraints?;
Struct    : 'type' ('record'|'set'|'union') Name { StructBody };
List      : 'type' ('record'|'set') ('length' '(' Expr ')')? 'of' REF Name;
Enum      : 'type' 'enumerated' Name '{' EnumBody '}' ;
Map       : 'type' 'map' 'from' REF 'to' REF Name ;
Class     : 'type' 'external'? 'class' Modifier? Name Extends? {ConfigSpec} ClassBody ('finally' Block)? ;

TestcaseType : 'type' 'testcase' Name FormalPars {ConfigSpec};
FunctionType : 'type' 'function' Modifiers Name FormalPars {ConfigSpec} ReturnSpec? ;
AltstepType  : 'type' 'altstep' Modifiers 'interleave'? Name FormalPars {ConfigSpec} ;

VarDecl  : ('const'|'var'|'modulepar') 'template'? Restriction? Modifiers REF { Name ArrayDef                      ':=' Expr ','? ... };
Template :                              'template'  Restriction? Modifiers REF   Name FormalPars? ('modifies' REF)? ':=' Expr;
Testcase : 'testcase' Name FormalPars {ConfigSpec} Block;
FuncDecl : 'external'? 'function' Modifiers Name FormalPars {ConfigSpec} ReturnSpec? Exception? Block?;
Config   : 'configuration' Name FormalPars {ConfigSpec} Block;
Altstep  : 'altstep' Modifiers 'interleave'? Name FormalPars {ConfigSpec} Block;


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

GuardStmt  : '[' Expr? ']' Stmt
CaseStmt   : 'case' ('else'|'(' Expr ')') Block
ClassBody
ModuleBody
ComponentBody
StructBody
EnumBody
SelectBody
