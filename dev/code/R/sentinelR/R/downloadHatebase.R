
downloadHatebase <- function(
	api.url         = 'http://api.hatebase.org/',
	api.key         = NULL,
	increment       = 3,
	sub.increment   = 0,
	query.type      = 'sightings',
	download.format = 'json',
	filename.prefix = 'hatebase',
	file.extension  = download.format
	) {

	URL.hatebase <- paste0(
		api.url,
		'/v',increment,'-',sub.increment,'/',
		api.key,'/',
		query.type,'/',
		download.format
		);

	json.string <- RCurl::getURL(URL.hatebase);
	write(
		x    = json.string,
		file = paste0(filename.prefix,'-01.',file.extension)
		);

	JSON.temp <- RJSONIO::fromJSON(content = .remove.bad.characters(input.string = json.string));

	num.of.results <- as.numeric(JSON.temp[['number_of_results']]);
	num.of.results.this.page <- as.numeric(JSON.temp[['number_of_results_on_this_page']]);
	num.of.pages <- as.integer(ceiling(num.of.results / num.of.results.this.page));

	num.of.rows.filled <- num.of.results.this.page;
	for (page in 2:num.of.pages) {
		print(paste0("page = ",page));
		write(
			x    = RCurl::getURL(paste0(URL.hatebase,'/page%3D',page)),
			file = paste0(filename.prefix,'-',formatC(page,width=2,format="d",flag="0"),'.',file.extension)
			);
		}

	return(1);

	}

### AUXILIARY FUNCTIONS ############################################################################

