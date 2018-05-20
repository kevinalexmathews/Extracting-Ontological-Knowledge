grammar ClassExpo;
   
/* ---------- BOLT --------- */
 
start
	: lexpr rexpr FULLSTOP
	;
      
lexpr
	: CLASS       # lexpr1 
	| INDIVIDUAL  # lexpr2
	;	

rexpr
	: unionOf
	;

/* --------- FRONT RUNNERS ------- */

unionOf 
	: intersectionOf (OR unionOf)*    # unionOf1   // ambiguous case ??? 
	| complementOf   (OR unionOf)*    # unionOf2   // ambiguous case ???
 	;

intersectionOf 
	: soloCombo ( INTERSECTIONOF_FLAG intersectionOf)*
	;

soloCombo
    : solo (SOLO_FLAG? soloCombo)*
    ;

/* --------- MID GETS ------- */

solo
	: complementOf      		 # soloComp
	| allValuesFrom     		 # soloAll
	| someValuesFrom    		 # soloSome
	| hasValue          		 # soloVal
	| hasSelf           		 # soloSelf
	| qualifiedExactCardinality  # soloQualExact
	| qualifiedMinCardinality    # soloQualMin
	| qualifiedMaxCardinality    # soloQualMax
	| exactCardinality  		 # soloExact
	| minCardinality    		 # soloMin
	| maxCardinality    		 # soloMax
	| classCombo        		 # soloCls 
	;


complementOf
	: ( (PRE_COMPLEMENT_FLAG PROPERTY ANY_FLAG) | (PROPERTY POST_COMPLEMENT_FLAG) )  classCombo 				                    
	;

allValuesFrom
	: (PROPERTY UNIVERSAL_FLAG classCombo)   // likes only cats
	| (UNIVERSAL_FLAG PROPERTY classCombo)   // only likes cats 
	;

someValuesFrom
	: ( PROPERTY EXISTENTIAL_FLAG classCombo )  # someValuesFrom1
	| ( PROPERTY classCombo )                   # someValuesFrom2	// ambiguous case 
	;
 
// Each such class expression can be seen as a syntactic shortcut for the 
// class expression ObjectSomeValuesFrom( OPE ObjectOneOf( a ) ).  
hasValue
	: PROPERTY INDIVIDUAL
	;

hasSelf
	: PROPERTY SELF_FLAG
	;
 
exactCardinality
	: PROPERTY EXACT_CARDINALITY_FLAG CARDINALITY 
	| PROPERTY AMBI_EXACT_CARDINALITY_FLAG CARDINALITY          // ambiguous case
	;

minCardinality 
	: PROPERTY PRE_MIN_CARDINALITY_FLAG CARDINALITY 
	| PROPERTY CARDINALITY POST_MIN_CARDINALITY_FLAG 
	;
	
maxCardinality
	: PROPERTY PRE_MAX_CARDINALITY_FLAG CARDINALITY 
	| PROPERTY CARDINALITY POST_MAX_CARDINALITY_FLAG 
	;

qualifiedExactCardinality	
	: PROPERTY EXACT_CARDINALITY_FLAG CARDINALITY classCombo
	| PROPERTY AMBI_EXACT_CARDINALITY_FLAG CARDINALITY classCombo         // ambiguous case
	;

qualifiedMinCardinality 
	: PROPERTY PRE_MIN_CARDINALITY_FLAG CARDINALITY classCombo
	| PROPERTY CARDINALITY POST_MIN_CARDINALITY_FLAG classCombo
	;
	
qualifiedMaxCardinality
	: PROPERTY PRE_MAX_CARDINALITY_FLAG CARDINALITY classCombo
	| PROPERTY CARDINALITY POST_MAX_CARDINALITY_FLAG classCombo
	;

classCombo	
    : CLASS (SOLO_FLAG classCombo)*
	;

/* --------- OOMPA LOOMPA ------- */ 

CLASS       				: 'C' NUM ;

INDIVIDUAL  				: 'I' NUM ; 

PROPERTY    				: 'P' NUM ; 

CARDINALITY					: 'N' NUM ; 

/* ----------- FLAGS ---------- */

// NO need of round brackets
ANY_FLAG 					: ANY ;           				

SOLO_FLAG 					: AND | OR | COMMA ;           				

INTERSECTIONOF_FLAG        : THAT | WHICH | WHO | WHOSE ;

PRE_COMPLEMENT_FLAG         : DOES_NOT1 | DOES_NOT2 | DO_NOT1 | DO_NOT2 | DID_NOT1 | DID_NOT2;
POST_COMPLEMENT_FLAG        : NOT | NO ;

UNIVERSAL_FLAG              : EXCLUSIVELY | NOTHING_BUT | NOTHING_EXCEPT | ONLY ;

EXISTENTIAL_FLAG            : A | AN | ALL | ANY | FEW | MANY | SOME | SEVERAL ;

EXACT_CARDINALITY_FLAG      : EXACTLY| JUST | MAY_BE | ONLY ;
AMBI_EXACT_CARDINALITY_FLAG : ABOUT | ALMOST | APPROXIMATELY | AROUND | CLOSE_TO ;

PRE_MIN_CARDINALITY_FLAG    : ATLEAST | LEAST | MORE_THAN | NOT_LESS_THAN ;
POST_MIN_CARDINALITY_FLAG   : OR_MORE ;

PRE_MAX_CARDINALITY_FLAG    : ATMOST | MOST | LESS_THAN | NOT_MORE_THAN | WITHIN ;
POST_MAX_CARDINALITY_FLAG   : OR_LESS ;
 
SELF_FLAG   				: MYSELF   | OURSELVES          		     // first person, singular and plural
		    				| YOURSELF | YOURSELVES                      // second person, singular and plural
	       				    | HIMSELF  | HERSELF  | ITSELF | THEMSELVES  // third person, singular and plural
            				;
            				

/* --------- SCHEDULED RULES ------- */

MYSELF 			: 'myself' ;
OURSELVES 		: 'ourselves' ;
YOURSELF 		: 'yourself' ;
YOURSELVES 		: 'yourselves' ;
HIMSELF 		: 'himself' ;
HERSELF 		: 'herself' ;
ITSELF 			: 'itself' ;
THEMSELVES 		: 'themselves' ;

AND   			: 'and' | ',and' | ', and';
OR    			: 'or' | ',or' | ', or';
COMMA 			: ',' ;

THAT  			: 'that' ;
WHICH  			: 'which' ;
WHO 			: 'who' ;
WHOSE  			: 'whose' ;

ABOUT 			: 'about' ;
ALMOST 			: 'almost' ;
APPROXIMATELY 	: 'approximately' ;
AROUND   		: 'around' ;
CLOSE_TO 		: 'close to' ;
            
ATLEAST			: 'at least' | 'atleast' ;
LEAST 			: 'least' ;
MORE_THAN 		: 'more than' ;
NOT_LESS_THAN 	: 'not less than' ;
OR_MORE 		: 'or more' ;

ATMOST			: 'at most' | 'atmost' ;
MOST 			: 'most';
LESS_THAN 		: 'less than';
NOT_MORE_THAN 	: 'not more than' ;
WITHIN 			: 'within' ;
OR_LESS 		: 'or less' ;

NOT 			: 'not' ;
NO 				: 'no' ;

DOES_NOT1 		: 'does not' ;
DOES_NOT2		: 'doesn\'t' ;
DO_NOT1   		: 'do not' ;
DO_NOT2   		: 'don\'t' ;
DID_NOT1  		: 'did not' ;
DID_NOT2  		: 'didn\'t' ;

EXCLUSIVELY		: 'exclusively' ;
NOTHING_BUT 	: 'nothing but' ;
NOTHING_EXCEPT 	: 'nothing except' ;
ONLY			: 'only';

A 				: 'a' ;
AN 				: 'an' ;
ALL 			: 'all' ;
ANY 			: 'any' ;
FEW 			: 'few' ;
MANY 			: 'many' ;
SOME 			: 'some' ;
SEVERAL 		: 'several';

EXACTLY 		: 'exactly' ;
JUST 			: 'just' ;
MAY_BE			: 'maybe'|'may be' ;

NUM         	: [0-9]+ ;
FULLSTOP    	: '.'  ;
WS          	: [ \t\r\n]+ -> skip ; // skip spaces, tabs, newlines
