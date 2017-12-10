module app

import util::UUID;
import util::Math;
import String;
import detectors::AST;

// set output folder
public loc output =  |project://Series2/src/sessions/| + "<abs(uuidi())>";
// set input project
public loc input = |project://TestProject/src/Small.java|;
// set settings
public set[node] asts = loadAst(input);
// run

public void main() = run(asts);