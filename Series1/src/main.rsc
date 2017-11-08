module main

import IO;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

import metrics::duplication;
import metrics::unitcomplexity;
import metrics::unitsize;
import metrics::unittests;
import metrics::volume;

import aspects::analysability;
import aspects::changeability;
import aspects::stability;
import aspects::testability;

public loc smallProject = |project://Series1/data/smallsql0.21_src|;
public loc largeProject = |project://Series1/data/hsqldb-2.3.1|;
