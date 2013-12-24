
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

#page.number <- 68;
page.number <- 51;
my.json.string <- .read.json.file(filename = paste0(data.directory,'/hatebase-json-',page.number,'.txt'));
str(my.json.string);
nchar(my.json.string);

DF.Hatebase <- Hatebase.json.to.data.frame(json.string = my.json.string);
str(DF.Hatebase);
sum(is.na(DF.Hatebase[,'country']));

FILE.Hatebase <- paste0('Hatebase-',page.number,'.csv');
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
sum(is.na(DF.retrieved[,'country']));

all.equal(DF.Hatebase,DF.retrieved);

unequal <- DF.Hatebase[,'meaning'] != DF.retrieved[,'meaning'];
cbind(DF.Hatebase[unequal,'meaning'],DF.retrieved[unequal,'meaning']);

####################################################################################################

q();

