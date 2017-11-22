module metrics::unitsize::NOM


import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

import Set;

/*
 * NOM : number of methods per class	
 */
public list[int] NOM(set[loc] projectClasses) {
	return ([NOM(c) | c <- projectClasses]);
}

public int NOM(loc l) {
	M3 model = createM3FromFile(l);
	return size(methods(model));
}

