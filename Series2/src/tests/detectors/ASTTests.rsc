module tests::detectors::ASTTests

extend detectors:: AST;


public loc testClass = |project://TestProject/src/TestClass.java|;
public set[node] testClassAst = loadAst(testClass);
//public list[node] testClassSubTress = preprocess(testClassAst, 0);



test bool TestTreeMass1() = treeMass("A"("V")) == 1;
test bool TestTreeMass12() = treeMass("A"("V"())) == 2;
test bool TestTreeMass13() = treeMass("A"("V"(), "W")) == 2;
test bool TestTreeMass14() = treeMass("A"("V"(), "W"())) == 3;
test bool TestTreeMass15() = treeMass("A"("V"("C"()))) == 3;

test bool TestTreeMass1() = fastCount("A"("V")) == 1;
test bool TestTreeMass12() = treeMass("A"("V"())) == fastCount("A"("V"()));
test bool TestTreeMass13() = treeMass("A"("V"(), "W")) == fastCount("A"("V"(), "W"));
test bool TestTreeMass14() = treeMass("A"("V"(), "W"())) == fastCount("A"("V"(), "W"()));
test bool TestTreeMass15() = treeMass("A"("V"("C"()))) == fastCount("A"("V"("C"())));

test bool TestUnsetNodes1() = unsetNodes("A"("V"("C"()))) == unsetRec("A"("V"("C"())));
test bool TestUnsetNodes2() = unsetNodes("A"(A="C")) == unsetRec("A"(A="C"));
test bool TestUnsetNodes3() = unsetNodes("A"(A="C")) == "A"();


public str functionExample1 = "
public String subTree() {
		
		int a = 0;
		if (a \> 10) {
			System.out.println(\"This is a text\");
		}
		return null;
	}
";

test bool testHash1() = hashFast(\simpleName("Jordan"), ("notNull": 0,  "apples":1)) == [2];

public node A1 = "A1"()[@hash = [1]];
public node A2 = "A2"()[@hash = [2]];
public node A3 = "A3"()[@hash = [3]];

test bool TestExtractClones1() = size(extractClones([ A1, A1 ])[[1]]) == 2;
test bool TestExtractClones2() = size(extractClones([ A2,  A2,  A1 ])[[2]]) == 2;
test bool TestExtractClones3() = extractClones([ A1,  A2,  A3 ]) == ();
test bool TestExtractClones4() = extractClones([ A1, A1,  A2,  A3, A3 ]) == ([1]:[A1, A1], [3]:[A3, A3]);

test bool TestIsSubTree1() = isSubTree(A1, "B1"(A1))  == true;
test bool TestIsSubTree2() = isSubTree(A1, "B1"("C1"(A1), A2, A3))  == true;
test bool TestIsSubTree3() = isSubTree(A2, "B1"(A1))  == false;


test bool TestVarIndex1 () = varIndex("name", ()) == <0,("name":0)>;
test bool TestVarIndex2 () = varIndex("name", ("name":0)) == <0,("name":0)>;
test bool TestVarIndex3 () = varIndex("second", ("name":0)) == <1,("name":0, "second": 1)>;
test bool TestVarIndex4 () = varIndex("fourth", ("name":0, "second": 1, "third": 2, "fourth":3, "fifth": 4)) == <3,("name":0, "second": 1, "third": 2, "fourth":3, "fifth": 4)>;
test bool TestVarIndex5 () = varIndex("fifth", ("name":0, "second": 1, "third": 2, "fourth":3)) == <4,("name":0, "second": 1, "third": 2, "fourth":3, "fifth": 4)>;


test bool TestNormalizeAST() = normalizeAST((\newObject(lang::java::jdt::m3::AST::\int(), [\simpleName("Jordan"), \simpleName("Erika"), \simpleName("Jordan"), simpleName("Shawn")])), true) ==  (\newObject(lang::java::jdt::m3::AST::\int(), [\simpleName("id0"), \simpleName("id1"), \simpleName("id0"), simpleName("id2")]));
test bool TestNormalizeAST() = normalizeAST((\newObject(lang::java::jdt::m3::AST::\int(), [\simpleName("Jordan"), \simpleName("Erika"), \simpleName("Jordan"), simpleName("Shawn")])), false) ==  (\newObject(lang::java::jdt::m3::AST::\int(), [\simpleName("Jordan"), \simpleName("Erika"), \simpleName("Jordan"), simpleName("Shawn")]));

test bool TestSubTree() = subTrees(\simpleName("AAA")[src=|file:///|], 0) == [\simpleName("AAA")];
test bool TestSubTree() = subTrees(\simpleName("AAA")[src=|file:///|], 0) == [\simpleName("AAA")];
test bool TestSubTree() = subTrees(\newObject(lang::java::jdt::m3::AST::\int(), [\simpleName("Jordan"), \simpleName("Erika"), \simpleName("Jordan")])[src=|file:///|], 0) == [\newObject(lang::java::jdt::m3::AST::\int(), [\simpleName("Jordan"), \simpleName("Erika"), \simpleName("Jordan")])];
test bool TestSubTree() = subTrees(\newObject(lang::java::jdt::m3::AST::\int(), [\simpleName("Jordan")[src=|file:///|], \simpleName("Erika"), \simpleName("Jordan")])[src=|file:///|], 0) == [ \newObject(lang::java::jdt::m3::AST::\int(), [\simpleName("Jordan"), \simpleName("Erika"), \simpleName("Jordan")]), \simpleName("Jordan")];


