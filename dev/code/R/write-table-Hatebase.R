
write.table.Hatebase <- function(
	DF.input = NULL,
	filename = NULL,
	append   = FALSE
	) {

	write.table(
		append    = append,
		col.names = TRUE,
		file      = filename,
		x         = DF.input,
		quote     = TRUE,
		sep       = '\t',
		row.names = FALSE
		);

	return(1);

	}

