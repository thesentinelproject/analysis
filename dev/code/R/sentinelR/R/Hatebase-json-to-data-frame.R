
Hatebase.json.to.data.frame <- function(
	json.directory  = '.',
	csv.directory   = '.',
	pattern         = '^hatebase.+\\.json$',
	csv.output.file = NULL,
	logger.name     = 'ROOT'
	) {

	logger.message <- 'START: converting Hatebase data from JSON to csv';
	futile.logger::flog.info(name = logger.name, msg = logger.message);

	hatebase.files <- list.files(path = json.directory, pattern = pattern);

	logger.message <- paste0("processing: ",hatebase.files[1]);
	futile.logger::flog.info(name = logger.name, msg = logger.message);

	temp.json.string <- .read.json.file(filename = paste0(json.directory,'/',hatebase.files[1]));
	DF.Hatebase <- .json.string.to.data.frame(json.string = temp.json.string);

	write.table.Hatebase(
		DF.input = DF.Hatebase,
		filename = paste0(csv.directory,'/',gsub(x = hatebase.files[1], pattern = '\\.', replacement = '-'),'.csv')
		);

	for (i in 2:length(hatebase.files)) {

		hatebase.file <- hatebase.files[i];

		logger.message <- print(paste0("processing: ",hatebase.file));
		futile.logger::flog.info(name = logger.name, msg = logger.message);

		temp.json.string <- .read.json.file(filename = paste0(json.directory,'/',hatebase.file));
		DF.temp <- .json.string.to.data.frame(json.string = temp.json.string);

		write.table.Hatebase(
			DF.input = DF.temp,
			filename = paste0(csv.directory,'/',gsub(x = hatebase.file, pattern = '\\.', replacement = '-'),'.csv')
			);

		DF.Hatebase <- rbind(DF.Hatebase,DF.temp);

		}

	logger.message <- 'FINISH: converting Hatebase data from JSON to csv';
	futile.logger::flog.info(name = logger.name, msg = logger.message);

	if (!is.null(csv.output.file)) {

		logger.message <- 'START: persisting Hatebase data';
		futile.logger::flog.info(name = logger.name, msg = logger.message);

		write.table.Hatebase(DF.input = DF.Hatebase, filename = csv.output.file);

		logger.message <- 'FINISH: persisting Hatebase data';
		futile.logger::flog.info(name = logger.name, msg = logger.message);

		}

	return(DF.Hatebase);

	}

### AUXILIARY FUNCTIONS ############################################################################
.json.string.to.data.frame <- function(json.string = NULL) {
	JSON.temp <- RJSONIO::fromJSON(content = .remove.bad.characters(input.string = json.string));
	DF.output <- .convert.Hatebase.json.to.data.frame(LIST.json = JSON.temp);
	return(DF.output);
	}

.convert.Hatebase.json.to.data.frame <- function(
	LIST.json = NULL,
	n.cols    = length(.get.Hatebase.colnames())
	) {

	#n.rows <- as.integer(LIST.json[['number_of_results_on_this_page']]);
	n.rows <- length(LIST.json[['data']][['datapoint']]);

	DF.output <- data.frame(
		matrix(character(length = n.rows * n.cols), nrow = n.rows, ncol = n.cols),
		stringsAsFactors = FALSE
		);
	colnames(DF.output) <- .get.Hatebase.colnames();

	for (i in 1:n.rows) {
		for (field in names(LIST.json[['data']][['datapoint']][[i]])) {
			DF.column.name <- gsub(x = field, pattern = '_', replacement = '.');
			DF.output[i,DF.column.name] <- .get.field(
				LIST.json   = LIST.json,
				i           = i,
				column.name = field
				);
			}
		}

	DF.output <- .recast.columns(DF.input = DF.output);

	return(DF.output);

	}

.recast.columns <- function(DF.input = NULL) {

	DF.output <- DF.input;

	DF.output[,'sighting.id'] <- as.integer(DF.output[,'sighting.id']);
	DF.output[,'date']        <- as.Date(DF.output[,'date']);

	DF.output[,'latitude']  <- as.numeric(DF.output[,'latitude']);
	DF.output[,'longitude'] <- as.numeric(DF.output[,'longitude']);

	DF.output[,'about.ethnicity']          <- as.logical(as.integer(DF.output[,'about.ethnicity']));
	DF.output[,'about.nationality']        <- as.logical(as.integer(DF.output[,'about.nationality']));
	DF.output[,'about.religion']           <- as.logical(as.integer(DF.output[,'about.religion']));
	DF.output[,'about.gender']             <- as.logical(as.integer(DF.output[,'about.gender']));
	DF.output[,'about.sexual.orientation'] <- as.logical(as.integer(DF.output[,'about.sexual.orientation']));
	DF.output[,'about.disability']         <- as.logical(as.integer(DF.output[,'about.disability']));
	DF.output[,'about.class']              <- as.logical(as.integer(DF.output[,'about.class']));
	DF.output[,'archaic']                  <- as.logical(as.integer(DF.output[,'archaic']));

	DF.output[,'number.of.revisions'] <- as.integer(DF.output[,'number.of.revisions']);
	DF.output[,'number.of.variants']  <- as.integer(DF.output[,'number.of.variants']);
	DF.output[,'number.of.sightings'] <- as.integer(DF.output[,'number.of.sightings']);
	DF.output[,'number.of.citations'] <- as.integer(DF.output[,'number.of.citations']);

	return(DF.output);

	}

.get.field <- function(LIST.json = NULL, i = NULL, column.name = NULL) {
	if (0 < length(LIST.json[['data']][['datapoint']][[i]][[column.name]])) {
		return(LIST.json[['data']][['datapoint']][[i]][[column.name]]);
		} else {
		return(NA);
		}
	}

.get.Hatebase.colnames <- function() {
	output <- c(
		'sighting.id',
		'date',
		'country',
		'city.or.community',
		'type',
		'human.readable.type',
		'latitude',
		'longitude',
		'vocabulary',
		'variant.of',
		'pronunciation',
		'meaning',
		'language',
		'about.ethnicity',
		'about.nationality',
		'about.religion',
		'about.gender',
		'about.sexual.orientation',
		'about.disability',
		'about.class',
		'archaic',
		'offensiveness',
		'number.of.revisions',
		'number.of.variants',
		'variants',
		'number.of.sightings',
		'last.sighting',
		'number.of.citations'
		);
	return(output);
	}

