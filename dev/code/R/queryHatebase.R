
queryHatebase <- function(
	api.url       = 'http://api.hatebase.org/',
	increment     = 3,
	sub.increment = 0,
	query.type    = 'sightings',
	format        = 'json',
	api.key       = NULL
	) {

	require(RCurl);
	require(rjson);

	URL.hatebase <- paste0(
		api.url,
		'/v',increment,'-',sub.increment,'/',
		api.key,'/',
		query.type,'/',
		format
		);

	print('URL.hatebase');
	print( URL.hatebase );

	temp.json.string <- RCurl::getURL(URL.hatebase);
	temp.json.string <- .remove.bad.characters(input.string = temp.json.string);
	JSON.temp <- rjson::fromJSON(json_str = temp.json.string, unexpected.escape = "keep");
	save(JSON.temp, file = 'Hatebase.RData');

	print('length(JSON.temp)');
	print( length(JSON.temp) );
	print('names(JSON.temp)');
	print( names(JSON.temp) );

	num.of.results <- as.numeric(JSON.temp[['number_of_results']]);
	num.of.results.this.page <- as.numeric(JSON.temp[['number_of_results_on_this_page']]);
	num.of.pages <- as.integer(ceiling(num.of.results / num.of.results.this.page));

	print("YYY");
	DF.output <- data.frame(matrix(character(28*num.of.results),nrow=num.of.results,ncol=28));
	print("ZZZ");
	colnames(DF.output) <- .get.Hatebase.colnames();

	DF.temp <- .convert.Hatebase.json.to.data.frame(LIST.json = JSON.temp);
	DF.output[1:num.of.results.this.page,] <- DF.temp;

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
		print('temp.url');
		print( temp.url );
		temp.json.string <- RCurl::getURL(temp.url);
		print('length(temp.json.string)');
		print( length(temp.json.string) );
		print('str(temp.json.string)');
		print( str(temp.json.string) );
		print('nchar(temp.json.string)');
		print( nchar(temp.json.string) );
		write(x = temp.json.string, file = 'json-string.txt');
		temp.json.string <- .remove.bad.characters(input.string = temp.json.string);
		JSON.temp <- rjson::fromJSON(json_str = temp.json.string, unexpected.escape = "keep");
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
		}

	return(DF.output);

	}

### AUXILIARY FUNCTIONS ############################################################################
.remove.bad.characters <- function(input.string = NULL) {
	output.string <- input.string;
	output.string <- gsub(x = output.string, pattern = '\\\\m',   replacement = '' );
	output.string <- gsub(x = output.string, pattern = '\\\\o',   replacement = 'o');
	output.string <- gsub(x = output.string, pattern = '\\\\[:space:]+', replacement = '' );
	return(output.string);
	}

.convert.Hatebase.json.to.data.frame <- function(LIST.json = NULL) {

	n.rows <- as.integer(LIST.json[['number_of_results_on_this_page']]);
	print('str(n.rows)');
	print( str(n.rows) );
	print('n.rows');
	print( n.rows );
	n.cols <- 28;
	DF.output <- data.frame(
		matrix(character(length = n.rows * n.cols), nrow = n.rows, ncol = n.cols),
		stringsAsFactors = FALSE
		);
	colnames(DF.output) <- .get.Hatebase.colnames();

	for (i in 1:n.rows) {
		print(paste0("row = ",i));
		DF.output[i,'sighting.id'] <- LIST.json[['data']][[1]][[i]][['sighting_id']];
		DF.output[i,'date'] <- LIST.json[['data']][[1]][[i]][['date']];
		DF.output[i,'country'] <- LIST.json[['data']][[1]][[i]][['country']];

		if (0 < length(LIST.json[['data']][[1]][[i]][['city_or_community']])) {
			DF.output[i,'city.or.community'] <- LIST.json[['data']][[1]][[i]][['city_or_community']];
			} else {
			DF.output[i,'city.or.community'] <- NA;
			}

		DF.output[i,'type'] <- LIST.json[['data']][[1]][[i]][['type']];

		DF.output[i,'human_readable_type'] <- LIST.json[['data']][[1]][[i]][['human_readable_type']];
		DF.output[i,'latitude'] <- LIST.json[['data']][[1]][[i]][['latitude']];
		DF.output[i,'longitude'] <- LIST.json[['data']][[1]][[i]][['longitude']];
		DF.output[i,'vocabulary'] <- LIST.json[['data']][[1]][[i]][['vocabulary']];

		if (0 < length(LIST.json[['data']][[1]][[i]][['variant_of']])) {
			DF.output[i,'variant_of'] <- LIST.json[['data']][[1]][[i]][['variant_of']];
			} else {
			DF.output[i,'variant_of'] <- NA;
			}

		if (0 < length(LIST.json[['data']][[1]][[i]][['pronunciation']])) {
			DF.output[i,'pronunciation'] <- LIST.json[['data']][[1]][[i]][['pronunciation']];
			} else {
			DF.output[i,'pronunciation'] <- NA;
			}

		print("AAA");

		DF.output[i,'meaning'] <- LIST.json[['data']][[1]][[i]][['meaning']];
		print("AAA-1");

		if (0 < length(LIST.json[['data']][[1]][[i]][['language']])) {
			DF.output[i,'language'] <- LIST.json[['data']][[1]][[i]][['language']];
			} else {
			DF.output[i,'language'] <- NA;
			}

		print("AAA-2");
		DF.output[i,'about.ethnicity'] <- LIST.json[['data']][[1]][[i]][['about_ethnicity']];
		print("AAA-3");
		DF.output[i,'about.nationality'] <- LIST.json[['data']][[1]][[i]][['about_nationality']];
		print("AAA-4");
		DF.output[i,'about.religion'] <- LIST.json[['data']][[1]][[i]][['about_religion']];
		print("AAA-5");
		DF.output[i,'about.gender'] <- LIST.json[['data']][[1]][[i]][['about_gender']];
		print("AAA-6");

		if (0 < length(LIST.json[['data']][[1]][[i]][['about_sexual_orientation']])) {
			DF.output[i,'about.sexual.orientation'] <- LIST.json[['data']][[1]][[i]][['about_sexual_orientation']];
			} else {
			DF.output[i,'about.sexual.orientation'] <- NA;
			}
		print("AAA-7");

		DF.output[i,'about.disability'] <- LIST.json[['data']][[1]][[i]][['about_disability']];
		DF.output[i,'about.class'] <- LIST.json[['data']][[1]][[i]][['about_class']];
		DF.output[i,'archaic'] <- LIST.json[['data']][[1]][[i]][['archaic']];

		print("BBB");

		if (0 < length(LIST.json[['data']][[1]][[i]][['offensiveness']])) {
			DF.output[i,'offensiveness']    <- LIST.json[['data']][[1]][[i]][['offensiveness']];
			} else {
			DF.output[i,'offensiveness'] <- NA;
			}

		print("CCC");

		if (0 < length(LIST.json[['data']][[1]][[i]][['number_of_revisions']])) {
			DF.output[i,'number.of.revisions'] <- LIST.json[['data']][[1]][[i]][['number_of_revisions']];
			} else {
			DF.output[i,'number.of.revisions'] <- NA;
			}

		print("DDD");

		if (0 < length(LIST.json[['data']][[1]][[i]][['number_of_variants']])) {
			DF.output[i,'number.of.variants'] <- LIST.json[['data']][[1]][[i]][['number_of_variants']];
			} else {
			DF.output[i,'number.of.variants'] <- NA;
			}

		print("EEE");

		if (0 < length(LIST.json[['data']][[1]][[i]][['variants']])) {
			DF.output[i,'variants'] <- LIST.json[['data']][[1]][[i]][['variants']];
			} else {
			DF.output[i,'variants'] <- NA;
			}

		print("FFF");

		if (0 < length(LIST.json[['data']][[1]][[i]][['number_of_sightings']])) {
			DF.output[i,'number.of.sightings'] <- LIST.json[['data']][[1]][[i]][['number_of_sightings']];
			} else {
			DF.output[i,'number.of.sightings'] <- NA;
			}

		print("GGG");

		if (0 < length(LIST.json[['data']][[1]][[i]][['last_sighting']])) {
			DF.output[i,'last.sighting'] <- LIST.json[['data']][[1]][[i]][['last_sighting']];
			} else {
			DF.output[i,'last.sighting'] <- NA;
			}

		print("HHH");

		if (0 < length(LIST.json[['data']][[1]][[i]][['number_of_citations']])) {
			DF.outpu.[i,'number.of.citations'] <- LIST.json[['data']][[1]][[i]][['number_of_citations']];
			} else {
			DF.output[i,'number.of.citations'] <- NA;
			}

		print("III");

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

