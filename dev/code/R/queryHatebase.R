
queryHatebase <- function(
	api.url       = 'http://api.hatebase.org/',
	increment     = 3,
	sub.increment = 0,
	query.type    = 'sightings',
	format        = 'json',
	api.key       = NULL
	) {

	require(RCurl);
	require(RJSONIO);

	URL.hatebase <- paste0(
		api.url,
		'/v',increment,'-',sub.increment,'/',
		api.key,'/',
		query.type,'/',
		format
		);

	temp.json.string <- RCurl::getURL(URL.hatebase);
	temp.json.string <- .remove.bad.characters(input.string = temp.json.string);
	JSON.temp <- RJSONIO::fromJSON(content = temp.json.string);

	num.of.results <- as.numeric(JSON.temp[['number_of_results']]);
	num.of.results.this.page <- as.numeric(JSON.temp[['number_of_results_on_this_page']]);
	num.of.pages <- as.integer(ceiling(num.of.results / num.of.results.this.page));

	DF.output <- data.frame(
		matrix(character(28*num.of.results),nrow=num.of.results,ncol=28),
		stringsAsFactors = FALSE
		);
	colnames(DF.output) <- .get.Hatebase.colnames();

	DF.temp <- .convert.Hatebase.json.to.data.frame(LIST.json = JSON.temp);
	DF.output[1:num.of.results.this.page,] <- DF.temp;

	print('str(DF.output)');
	print( str(DF.output) );

	write.table(
		append    = FALSE,
		col.names = TRUE,
		file      = 'Hatebase.csv',
		x         = DF.temp,
		quote     = FALSE,
		sep       = '\t',
		row.names = FALSE
		);

	num.of.rows.filled <- num.of.results.this.page;
	for (page in 2:num.of.pages) {
		print(paste0("page = ",page));
		temp.url <- paste0(URL.hatebase,'/page%3D',page);
		temp.json.string <- RCurl::getURL(temp.url);
		JSON.temp <- try(RJSONIO::fromJSON(
			content = .remove.bad.characters(input.string = temp.json.string);
			));
		if ("try-error" == class(JSON.temp)) {
			write(x = temp.json.string, file = paste0('json-string-',page,'.txt'));
			} else {
			num.of.results.this.page <- as.integer(JSON.temp[['number_of_results_on_this_page']]);
			old.num.of.rows.filled <- num.of.rows.filled;
			num.of.rows.filled <- old.num.of.rows.filled + num.of.results.this.page;
			DF.temp <- .convert.Hatebase.json.to.data.frame(LIST.json = JSON.temp);
			rows.to.filled <- (1+old.num.of.rows.filled):(num.of.rows.filled);
			DF.output[rows.to.filled,] <- DF.temp;
			write.table(
				append    = TRUE,
				col.names = FALSE,
				file      = 'Hatebase.csv',
				x         = DF.temp,
				quote     = FALSE,
				sep       = '\t',
				row.names = FALSE
				);
			print('str(DF.output)');
			print( str(DF.output) );
			}
		}

	return(DF.output);

	}

### AUXILIARY FUNCTIONS ############################################################################
.remove.bad.characters <- function(input.string = NULL) {
	output.string <- input.string;
	#output.string <- gsub(x = output.string, pattern = '\\\\m',   replacement = '' );
	#output.string <- gsub(x = output.string, pattern = '\\\\o',   replacement = 'o');
	#output.string <- gsub(x = output.string, pattern = '\\\\[:space:]+', replacement = '' );
	return(output.string);
	}

.convert.Hatebase.json.to.data.frame <- function(LIST.json = NULL) {

	n.rows <- as.integer(LIST.json[['number_of_results_on_this_page']]);
	#print('str(n.rows)');
	#print( str(n.rows) );
	#print('n.rows');
	#print( n.rows );

	n.cols <- 28;
	DF.output <- data.frame(
		matrix(character(length = n.rows * n.cols), nrow = n.rows, ncol = n.cols),
		stringsAsFactors = FALSE
		);
	colnames(DF.output) <- .get.Hatebase.colnames();

	for (i in 1:n.rows) {
		#print(paste0("row = ",i));
		for (field in names(LIST.json[['data']][[1]][[i]])) {
			DF.column.name <- gsub(x = field, pattern = '_', replacement = '.');
			DF.output[i,DF.column.name] <- .get.field(
				LIST.json   = LIST.json,
				i           = i,
				column.name = field
				);
			}
		}

	# remove carriage-return and new-line characters in the event.title and description fields
	#DF.output[,'event.title'] <- gsub(x = DF.output[,'event.title'], pattern = '(\n|\r)+', replacement = ' ');
	#DF.output[,'description'] <- gsub(x = DF.output[,'description'], pattern = '(\n|\r)+', replacement = ' ');

	#DF.output[,'stage']         <- as.factor(DF.output[,'stage']);
	#DF.output[,'created']       <- as.Date(DF.output[,'created']);
	#DF.output[,'modified']      <- as.Date(DF.output[,'modified']);
	#DF.output[,'event.date']    <- as.Date(DF.output[,'event.date']);
	#DF.output[,'serial.number'] <- as.integer(DF.output[,'serial.number']);
	#DF.output[,'latitude']      <- as.numeric(DF.output[,'latitude']);
	#DF.output[,'longitude']     <- as.numeric(DF.output[,'longitude']);

	return(DF.output);

	}

.get.field <- function(LIST.json = NULL, i = NULL, column.name = NULL) {
	if (0 < length(LIST.json[['data']][[1]][[i]][[column.name]])) {
		return(LIST.json[['data']][[1]][[i]][[column.name]]);
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

