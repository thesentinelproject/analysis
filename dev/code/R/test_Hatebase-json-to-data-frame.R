
command.arguments <- commandArgs(trailingOnly = TRUE);
data.directory   <- command.arguments[1];
output.directory <- command.arguments[2];
code.directory   <- command.arguments[3];
tmp.directory    <- command.arguments[4];

####################################################################################################
library(RJSONIO);

####################################################################################################
source(paste0(code.directory,"/Hatebase-json-to-data-frame.R"));
source(paste0(code.directory,"/read-json-file.R"));
source(paste0(code.directory,"/read-table-Hatebase.R"));
source(paste0(code.directory,"/remove-bad-characters.R"));

####################################################################################################
setwd(output.directory);

DF.Hatebase <- Hatebase.json.to.data.frame(
	path     = data.directory,
	filename = 'Hatebase.csv'
	);
str(DF.Hatebase);

FILE.Hatebase <- 'test-Hatebase.csv';
write.table(
	append    = FALSE,
	col.names = TRUE,
	file      = FILE.Hatebase,
	x         = DF.Hatebase,
	quote     = TRUE,
	sep       = '\t',
	row.names = FALSE
	);

DF.retrieved <- read.table.Hatebase(filename = FILE.Hatebase);
str(DF.retrieved);

all.equal(DF.Hatebase,DF.retrieved);

####################################################################################################

q();

