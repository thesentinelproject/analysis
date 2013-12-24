
read.table.Hatebase <- function(filename = NULL) {

	#DF.output <- read.table(
	#	file             = filename,
	#	as.is            = TRUE,
	#	header           = TRUE,
	#	sep              = '\t',
	#	quote            = "\"'",
	#	allowEscapes     = TRUE,
	#	stringsAsFactors = FALSE
	#	);

	DF.output <- read.csv(
		as.is            = TRUE,
		file             = filename,
		header           = TRUE,
		sep              = '\t',
		stringsAsFactors = FALSE
		);

	### re-casting the columns of DF.output to desired data types
	DF.output[,'sighting.id'] <- as.integer(  DF.output[,'sighting.id']);
	DF.output[,'date']        <- as.Date(     DF.output[,'date']);

	DF.output[,'country']             <- as.character(DF.output[,'country']);
	DF.output[,'city.or.community']   <- as.character(DF.output[,'city.or.community']);
	DF.output[,'type']                <- as.character(DF.output[,'type']);
	DF.output[,'human.readable.type'] <- as.character(DF.output[,'human.readable.type']);


	DF.output[,'latitude']  <- as.numeric(DF.output[,'latitude']);
	DF.output[,'longitude'] <- as.numeric(DF.output[,'longitude']);

	DF.output[,'vocabulary']    <- as.character(DF.output[,'vocabulary']);
	DF.output[,'variant.of']    <- as.character(DF.output[,'variant.of']);
	DF.output[,'pronunciation'] <- as.character(DF.output[,'pronunciation']);
	DF.output[,'meaning']       <- as.character(DF.output[,'meaning']);
	DF.output[,'language']      <- as.character(DF.output[,'language']);
	
	DF.output[,'about.ethnicity']          <- as.logical(DF.output[,'about.ethnicity']);
	DF.output[,'about.nationality']        <- as.logical(DF.output[,'about.nationality']);
	DF.output[,'about.religion']           <- as.logical(DF.output[,'about.religion']);
	DF.output[,'about.gender']             <- as.logical(DF.output[,'about.gender']);
	DF.output[,'about.sexual.orientation'] <- as.logical(DF.output[,'about.sexual.orientation']);
	DF.output[,'about.disability']         <- as.logical(DF.output[,'about.disability']);
	DF.output[,'about.class']              <- as.logical(DF.output[,'about.class']);
	DF.output[,'archaic']                  <- as.logical(DF.output[,'archaic']);

	DF.output[,'offensiveness'] <- as.character(DF.output[,'offensiveness']);
	DF.output[,'variants']      <- as.character(DF.output[,'variants']);
	DF.output[,'last.sighting'] <- as.character(DF.output[,'last.sighting']);

	DF.output[,'number.of.revisions'] <- as.integer(  DF.output[,'number.of.revisions']);
	DF.output[,'number.of.variants']  <- as.integer(  DF.output[,'number.of.variants']);
	DF.output[,'number.of.sightings'] <- as.integer(  DF.output[,'number.of.sightings']);
	DF.output[,'number.of.citations'] <- as.integer(  DF.output[,'number.of.citations']);


	### The country code of Namibia is: NA
	### Hence, 'NA' appearing in DF.output[,'country'] is NOT 'NA' in R ("Not Available")
	DF.output[is.na(DF.output[,'country']),'country'] <- "NA";

	return(DF.output);

	}

