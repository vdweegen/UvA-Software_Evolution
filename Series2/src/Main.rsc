module Main

import IO;
import vis::Figure;
import vis::Render;
//import lang::java::m3::AST;
import lang::java::jdt::m3::AST;
import lang::java::\syntax::Java15;

public loc littleClass = |project://smallsql0.21_src/src/smallsql/tools/CommandLine.java|;
public loc smallProject = |project://smallsql0.21_src|;
public Declaration littleClassAst = createAstFromFile(littleClass, false);
public set[node] smast = createAstsFromEclipseProject(smallProject, false);


public Figure visAST(compilationUnit(_, list[Declaration] d)) = 
	visNode(d) ;            

public Figure visAST(Declaration name) = 
	box(text("<name>"), gap(2), fillColor("lightyellow")); 
	
public Figure visAST(Statement name) = 
	box(text("<name>"), gap(2), fillColor("lightyellow")); 

public Figure visAST(list[Declaration] parameters) = 
	tree(ellipse(fillColor("blue")), [visAST(x) |x <-  parameters]);
	
		
public Figure visAST(\method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions, Statement impl)) = visNode(name, parameters, impl);

	//box(text("<name>"), gap(2), fillColor("lightyellow")); 
	
   


// Nodes of less importance are just shown as names or types

public Figure visAST(class(str name, list[Type] extends, list[Type] implements, list[Declaration] body)) = 
	visNode(name, body) ;    
	  
public Figure visNode(list[Declaration] declarations) = tree(ellipse(fillColor("green")), [visAST(x) | x <- declarations]);
public Figure visNode(str name, list[Declaration] body) = tree(ellipse(text("<name>"),fillColor("red")), [visAST(x) | x <- body]);

public Figure visNode(str name, list[Declaration] parameters, Statement impl) = tree(ellipse(text("<name>"),fillColor("red")), [tree(ellipse(text("Parameters"),fillColor("blue")), [visAST(parameters)]), tree(ellipse(text("Body"),fillColor("yellow")), [visAST(impl)])]);

public Figure visNode(str name) =     
	tree(ellipse(fillColor(name)), []);

public void explore(Declaration d) {
	
	visit(d) {
		
		case x:\method(_, str name, _, _, _): println("<name>");
		
	}

}