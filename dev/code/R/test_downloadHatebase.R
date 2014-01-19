
command.arguments <- commandArgs(trailingOnly = TRUE);
hatebase.api.key <- command.arguments[1];
output.directory <- command.arguments[2];
tmp.directory    <- command.arguments[3];

####################################################################################################
library(sentinelR);

####################################################################################################
DF.Hatebase <- downloadHatebase(
	api.key         = hatebase.api.key,
	convert.to.csv  = TRUE,
	json.directory  = tmp.directory,
	csv.directory   = tmp.directory,
	csv.output.file = paste0(output.directory,'/Hatebase.csv')
	);
str(DF.Hatebase);

write.table(
	file      = paste0(output.directory,'/test-Hatebase.csv'),
	x         = DF.Hatebase,
	quote     = FALSE,
	sep       = '\t',
	row.names = FALSE,
	col.names = TRUE
	)

####################################################################################################

q();

