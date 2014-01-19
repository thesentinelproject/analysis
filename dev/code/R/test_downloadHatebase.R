
command.arguments <- commandArgs(trailingOnly = TRUE);
hatebase.api.key <- command.arguments[1];
output.directory <- command.arguments[2];
tmp.directory    <- command.arguments[3];

####################################################################################################
library(futile.logger);
library(sentinelR);

####################################################################################################
logger.name = 'logger.downloadHatebase';
logger.file = paste0(output.directory,'/downloadHatebase.log');
futile.logger::flog.appender(appender.file(logger.file), name = logger.name);
futile.logger::flog.threshold(INFO, name = logger.name);

DF.Hatebase <- downloadHatebase(
	api.key         = hatebase.api.key,
	convert.to.csv  = TRUE,
	json.directory  = tmp.directory,
	csv.directory   = tmp.directory,
	csv.output.file = paste0(output.directory,'/Hatebase.csv'),
	logger.name     = logger.name
	);
str(DF.Hatebase);

write.table(
	file      = paste0(output.directory,'/test-Hatebase.csv'),
	x         = DF.Hatebase,
	quote     = TRUE,
	sep       = '\t',
	row.names = FALSE,
	col.names = TRUE
	)

####################################################################################################

q();

