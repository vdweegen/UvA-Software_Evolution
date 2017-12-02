module Main

import IO;
import vis::Figure;
import vis::Render;
import lang::java::m3::AST;
import lang::java::\syntax::Java15;

public loc littleClass = |project://TestProject/src/Small.java|;
public Declaration littleClassAst = createAstFromFile(littleClass, false);


public void hello() {
	println("Hello Rascal <littleClass>");
}

public Figure visAST(Declaration name) = 
	box(text("<name>"), gap(2), fillColor("lightyellow")); 
	
public Figure visAST(\method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions, Statement impl)) = 
	box(text("<name>"), gap(2), fillColor("lightyellow")); 
	
public Figure visAST(compilationUnit(_, list[Declaration] d)) = 
	visNode(d) ;               


// Nodes of less importance are just shown as names or types

public Figure visAST(class(str name, list[Type] extends, list[Type] implements, list[Declaration] body)) = 
	visNode(name, body) ;    
	  
public Figure visNode(list[Declaration] declarations) = tree(ellipse(fillColor("green")), [visAST(x) | x <- declarations]);
public Figure visNode(str name, list[Declaration] body) = tree(ellipse(text("<name>"),fillColor("red")), [visAST(x) | x <- body]);
	
public Figure visNode(str name) =     
	tree(ellipse(fillColor(name)), []);

public void explore(Declaration d) {
	
	visit(d) {
		
		case x:\method(_, str name, _, _, _): println("<name>");
		
	}

}