module metrics::unitsize::UnitSize

import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

import helpers::Normalizer;
import metrics::volume::Volume;

import List;
import String;
import IO;
import Set;

/*
 * Unit size uses the model to extract the methods and the source	
 */
public list[int] UnitSize(set[loc] projectMethods) {
	return ([UnitSize(readFile(m)) | m <- projectMethods]);
}

public int UnitSize(str source) {
	return linesExtract(source);
}

public int linesExtract(str x) = volume(x)["total_lines"];

