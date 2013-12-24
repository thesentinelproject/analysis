
command.arguments <- commandArgs(trailingOnly = TRUE);
hatebase.api.key <- command.arguments[1];
output.directory <- command.arguments[2];
code.directory   <- command.arguments[3];
tmp.directory    <- command.arguments[4];

####################################################################################################
library(RCurl);
library(XML);
library(RJSONIO);

setwd(output.directory);

####################################################################################################
source(paste0(code.directory,"/queryHatebase.R"));
source(paste0(code.directory,"/remove-bad-characters.R"));
DF.Hatebase <- queryHatebase(api.key = hatebase.api.key);
str(DF.Hatebase);

q();

write.table(
	file      = 'Hatebase.csv',
	x         = DF.Hatebase,
	quote     = FALSE,
	sep       = '\t',
	row.names = FALSE,
	col.names = TRUE
	)

####################################################################################################

q();

