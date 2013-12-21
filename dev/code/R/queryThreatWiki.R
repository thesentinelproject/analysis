
queryThreatWiki <- function(
	api.url = 'http://threatwiki.thesentinelproject.org/api'
	) {

	require(RCurl);
	require(rjson);

	my.json.string <- RCurl::getURL(paste0(api.url,"/datapoint"));
	my.json        <- rjson::fromJSON(json_str = my.json.string);
	DF.ThreatWiki  <- .convert.ThreatWiki.json.to.data.frame(LIST.json = my.json);

	}

### AUXILIARY FUNCTIONS ############################################################################
.convert.ThreatWiki.json.to.data.frame <- function(LIST.json = NULL) {

	n.rows <- length(LIST.json);
	n.cols <- 15;
	DF.output <- data.frame(
		matrix(character(length = n.rows * n.cols), nrow = n.rows, ncol = 15),
		stringsAsFactors = FALSE
		);
	colnames(DF.output) <- c(
		'event.date',
		'created',
		'modified',
		'latitude',
		'longitude',
		'soc',
		'stage',
		'created.by',
		'modified.by',
		'location.title',
		'source.url',
		'source.type',
		'serial.number',
		'event.title',
		'description'
		);

	for (i in 1:length(LIST.json)) {
		print(paste0("i = ",i));
		DF.output[i,'event.title']   <- LIST.json[[i]][['title']];
		DF.output[i,'description']   <- LIST.json[[i]][['description']];
		DF.output[i,'soc']           <- LIST.json[[i]][['soc']];
		DF.output[i,'stage']         <- ifelse(is.null(LIST.json[[i]][['stage']]),NA,LIST.json[[i]][['stage']]);
		DF.output[i,'created']       <- LIST.json[[i]][['created']];
		DF.output[i,'modified']      <- LIST.json[[i]][['modified']];
		DF.output[i,'event.date']    <- LIST.json[[i]][['event_date']];
		DF.output[i,'serial.number'] <- LIST.json[[i]][['serialNumber']];
		DF.output[i,'created.by']    <- LIST.json[[i]][['createdBy']][['name']];
		DF.output[i,'modified.by']   <- LIST.json[[i]][['modifiedBy']][['name']];
		if (0 < length(LIST.json[[i]][['sources']])) {
			DF.output[i,'source.url']  <- LIST.json[[i]][['sources']][[1]][['url']];
			DF.output[i,'source.type'] <- LIST.json[[i]][['sources']][[1]][['sourcetype']];
			} else {
			DF.output[i,'source.url']  <- NA;
			DF.output[i,'source.type'] <- NA;
			}
		DF.output[i,'location.title'] <- LIST.json[[i]][['Location']][['title']];
		DF.output[i,'latitude']       <- LIST.json[[i]][['Location']][['latitude']];
		DF.output[i,'longitude']      <- LIST.json[[i]][['Location']][['longitude']];
		}

	# remove carriage-return and new-line characters in the event.title and description fields
	DF.output[,'event.title'] <- gsub(x = DF.output[,'event.title'], pattern = '(\n|\r)+', replacement = ' ');
	DF.output[,'description'] <- gsub(x = DF.output[,'description'], pattern = '(\n|\r)+', replacement = ' ');

	DF.output[,'stage']         <- as.factor(DF.output[,'stage']);
	DF.output[,'created']       <- as.Date(DF.output[,'created']);
	DF.output[,'modified']      <- as.Date(DF.output[,'modified']);
	DF.output[,'event.date']    <- as.Date(DF.output[,'event.date']);
	DF.output[,'serial.number'] <- as.integer(DF.output[,'serial.number']);
	DF.output[,'latitude']      <- as.numeric(DF.output[,'latitude']);
	DF.output[,'longitude']     <- as.numeric(DF.output[,'longitude']);

	return(DF.output);

	}

