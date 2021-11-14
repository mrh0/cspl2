grammar CSPL2;

IDENTIFIER: [_a-zA-Z][_a-zA-Z0-9]*;
ATOM: '#'IDENTIFIER;
INT: '0'|[1-9][0-9]*;
STRING: '"' (~('\'' | '\\') | '\\' . )* '"';
WHITESPACE: [ \t\r\n]+ -> skip;
COMMENT: '//' ~[\r\n]* -> skip;
BLOCKCOMMENT: '/*' .*? '*/' -> skip;
EOS: '\n' | ';';

unop:
    '!' | '~' | '-'
    ;

binop:
    '+' | '-' | '*' | '/' | '%'
    | '<' | '>' | '<=' | '>=' | '==' | '!='
    | '&' | '|' | '&&' | '||'
    | '<<' | '>>' | 'is' | 'as'
    ;

expression:
    IDENTIFIER
    | ATOM
    | INT
    | STRING
    | expression binop expression
    | unop expression
    | '_'
    | inline
    | lambda
    | '(' expression ')'
    ;

statement:
    scope
    | expression EOS
    | '(' expression ')'
    ;

lvalue:
    IDENTIFIER
    ;

inline:
    'if' expression 'then' evaluatable ('else' evaluatable)?
    | 'for' expression 'in' evaluatable ('where' evaluatable)* ('orderby' evaluatable)*
    | 'for' expression 'of' evaluatable ('where' evaluatable)* ('orderby' evaluatable)*
    ;

scope: '{' (statement)* '}';

parameter:
    IDENTIFIER
    | IDENTIFIER '=' expression
    ;

parameters: (parameter (',' parameter)*);

evaluatable:
    expression
    | scope
    ;

lambda:
    IDENTIFIER '->' evaluatable
    | '(' parameters ')' '->' evaluatable
    ;

global:
    statement
    | 'import' IDENTIFIER 'from' STRING ('as' IDENTIFIER)? EOS
    | 'export' expression ('as' IDENTIFIER)? EOS
    ;

program:
    (global)* EOF
    ;