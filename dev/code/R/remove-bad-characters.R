
.remove.bad.characters <- function(input.string = NULL) {

	output.string <- input.string;

	# For the datapoint with sighting_id 18798, the "city_or_community" field is as follows:
	#
	#    "city_or_community":"Cape Town SA /\/&macr;&macr;&macr;\/\"
	#
	# Note that it ends with '\"', where the escape character immediately preceding the
	# right-delimiting double-quotation mark causes a parsing error in R.
	# The following gsub statement removes the above offending escape character.
	output.string <- gsub(x = output.string, pattern = '\\\\\",\\"', replacement = '","');

	return(output.string);

	}

