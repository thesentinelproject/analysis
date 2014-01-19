
command.arguments <- commandArgs(trailingOnly = TRUE);
hatebase.api.key  <- command.arguments[1];
output.directory  <- command.arguments[2];
tmp.directory     <- command.arguments[3];

####################################################################################################
library(sentinelR);

####################################################################################################
launch.directory <- getwd();

setwd(tmp.directory);
downloadHatebase(api.key = hatebase.api.key);

setwd(launch.directory);
setwd(output.directory);
DF.Hatebase <- Hatebase.json.to.data.frame(
	path     = tmp.directory,
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

