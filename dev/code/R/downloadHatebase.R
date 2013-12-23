
downloadHatebase <- function(
	api.url         = 'http://api.hatebase.org/',
	increment       = 3,
	sub.increment   = 0,
	query.type      = 'sightings',
	download.format = 'json',
	api.key         = NULL
	) {

	require(RCurl);
	require(rjson);

	URL.hatebase <- paste0(
		api.url,
		'/v',increment,'-',sub.increment,'/',
		api.key,'/',
		query.type,'/',
		download.format
		);

	filename.prefix <- paste0('hatebase-',download.format);

	temp.json.string <- RCurl::getURL(URL.hatebase);
	write(
		x    = temp.json.string,
		file = paste0(filename.prefix,'-01.txt')
		);

	JSON.temp <- rjson::fromJSON(
		json_str = temp.json.string,
		unexpected.escape = "keep"
		);

	num.of.results <- as.numeric(JSON.temp[['number_of_results']]);
	num.of.results.this.page <- as.numeric(JSON.temp[['number_of_results_on_this_page']]);
	num.of.pages <- as.integer(ceiling(num.of.results / num.of.results.this.page));

	num.of.rows.filled <- num.of.results.this.page;
	for (page in 2:num.of.pages) {
		print(paste0("page = ",page));
		write(
			x    = RCurl::getURL(paste0(URL.hatebase,'/page%3D',page)),
			file = paste0(filename.prefix,'-',formatC(page,width=2,format="d",flag="0"),'.txt')
			);
		}

	return(DF.output);

	}

### AUXILIARY FUNCTIONS ############################################################################

