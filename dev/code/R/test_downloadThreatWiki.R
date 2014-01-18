
command.arguments <- commandArgs(trailingOnly = TRUE);
output.directory <- command.arguments[1];
code.directory   <- command.arguments[2];
tmp.directory    <- command.arguments[3];

####################################################################################################
library(sentinelR);

setwd(output.directory);

####################################################################################################
DF.ThreatWiki <- downloadThreatWiki();
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

