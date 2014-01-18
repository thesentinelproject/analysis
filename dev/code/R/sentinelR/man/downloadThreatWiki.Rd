\name{downloadThreatWiki}
\alias{downloadThreatWiki}
\title{
	Something
	}
\description{
	Something
	%%  ~~ A concise (1-5 lines) description of what the function does. ~~
	}
\usage{
	downloadThreatWiki(api.url = "http://threatwiki.thesentinelproject.org/api")
	}
\arguments{
	\item{api.url}{
		%%     ~~Describe \code{api.url} here~~
		}
	}
\details{
	Something
	%%  ~~ If necessary, more details than the description above ~~
	}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (api.url = "http://threatwiki.thesentinelproject.org/api") 
{
    require(RCurl)
    require(RJSONIO)
    my.json <- RJSONIO::fromJSON(content = .remove.bad.characters(input.string = RCurl::getURL(paste0(api.url, 
        "/datapoint"))))
    DF.ThreatWiki <- .convert.ThreatWiki.json.to.data.frame(LIST.json = my.json)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
