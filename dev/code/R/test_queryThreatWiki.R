
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory <- command.arguments[1];
code.directory   <- command.arguments[2];
tmp.directory    <- command.arguments[3];

####################################################################################################
library(RCurl);
library(XML);
library(rjson);

setwd(output.directory);

####################################################################################################
source(paste0(code.directory,"/queryThreatWiki.R"));
DF.ThreatWiki <- queryThreatWiki();
str(DF.ThreatWiki);
write.table(
	file      = 'ThreatWiki.csv',
	x         = DF.ThreatWiki,
	quote     = FALSE,
	sep       = '\t',
	row.names = FALSE,
	col.names = TRUE
	)

####################################################################################################

q();

