module metrics::unittest::UnitTest
/*
	Intuition: The target project

*/
import helpers::Normalizer;
import metrics::volume::Volume;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;
import List;
import String;
import IO;
import Set;

//public loc file = |project://smallsql0.21_src/src/smallsql/database/Column.java|;
public loc file = |project://smallsql0.21_src/src/smallsql/junit/TestAlterTable2.java|;

public loc proj = |project://smallsql0.21_src|;
public M3 model = createM3FromEclipseProject(proj);
public M3 modelFile = createM3FromFile(file);
public set[loc] sources = files(model);
public str source = readFile(file);

public list[int] UnitTest(set[loc] projectMethods) {
	return ([UnitTest(readFile(m)) | m <- projectMethods]);
}

public lrel[loc, int] UnitTestDebug(set[loc] projectMethods) {
	return [<m, UnitTest(readFile(m))> | m <- projectMethods];
}

public int UnitTest(str source) {
	return countAsserts(source);
}

public int countAsserts(str source) {
	list[str] asrt = [];
	asrt = for(/<as:assert[\w]*\b>/ := source) append(as);
	return size(asrt);
}
