module \tests::helpers::Normalizer

import helpers::Normalizer;

public str example1 = "
/**/
";

public str example2 = "
/** 
This  
is  
documentation  
comment 
*/
public Class Calculator () {
	public Calculator
}
";

public str example3 = "/** The Calculator class provides methods to get addition and subtraction of given 2 numbers.*/  
public class Calculator {  
/** The add() method returns addition of given numbers.*/  
public static int add(int a, int b){return a+b;}  
/** The sub() method returns subtraction of given numbers.*/  
public static int sub(int a, int b){return a-b;}  
}

";

public str example4 = "
/* This is a single-line comment:

    // a single-line comment

 */
";

public str example5 = "
// /* this is

//    a multi-line
public static void main () {

}
//    comment */
";

public str example6 = "
x = 1;   /* set x to 1 */

y = 2;   /* set y to 2 */

f(x, y); /* call f with x and y */
";


public str example7 = "
// x = 1;   /* set x to 1 */

// y = 2;   /* set y to 2 */

// f(x, y); /* call f with x and y */
";

test bool comment0() = comments("") == [];
test bool comment1() = comments(example1) == ["/**/"];
test bool comment2() = comments(example2) == [
"/** 
This  
is  
documentation  
comment 
*/"];

test bool comment3() = comments(example3) == [
"/** The Calculator class provides methods to get addition and subtraction of given 2 numbers.*/",
"/** The add() method returns addition of given numbers.*/",
"/** The sub() method returns subtraction of given numbers.*/"
];

test bool comment4() = comments(example4) == ["/* This is a single-line comment:

    // a single-line comment

 */"];
 
test bool comment5() = comments(example5) == [
"// /* this is",
"//    a multi-line",
"//    comment */"
];

test bool nestedComments() = comments(example6) == [
"/* set x to 1 */",
"/* set y to 2 */",
"/* call f with x and y */"
];
 
test bool singleMulti() = comments(example7) == [
"// x = 1;   /* set x to 1 */",
"// y = 2;   /* set y to 2 */",
"// f(x, y); /* call f with x and y */"
];