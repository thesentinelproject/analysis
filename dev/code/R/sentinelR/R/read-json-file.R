
.read.json.file <- function(filename = NULL) {
	return(paste(readLines(con = filename),collapse = ""));
	}

