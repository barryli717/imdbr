#' overview
#'
#' This funtion gets the overview for a certain title.
#'
#' @import httr dplyr stringr
#' @param name Name of the title, fuzzy name is supported. Default as `FALSE`.
#' @param id The id of your inquiry title. Default as `FALSE`.
#' @return The overview of your inquiry title, as a dataframe.
#' @author Yunong Li
#' @export
#' @examples
#'
#' # Gets the overview of "game of thrones".
#' overview(name = "game of thrones")
#'
#' # Gets the overview of id="tt0944947".
#' overview(id = "tt0944947")

overview <- function(name=FALSE, id=FALSE){
  if (id == FALSE) {
    if (name == FALSE) {
      stop("No input for overview, please provide name/id of the title.")
    }
    else{
    id = imdbr::get_id(name)
    if (stringr::str_sub(id, start = 1L, end = 2L) != "tt") {
      stop("Please input a valid name.")
    }
    }
  }

  query = list("tconst"= id)

  endpoint = "https://imdb8.p.rapidapi.com/title/get-overview-details"
  response = httr::GET(url = endpoint,
                       add_headers('x-rapidapi-host' = Sys.getenv("RAPID_API_HOST"),
                                   'x-rapidapi-key' = Sys.getenv("RAPID_API_KEY")),
                       query = query)
  content = httr::content(response)

  if (content$title$titleType == "movie") {
    data <- dplyr::tibble(Title = character(),
                          TitleType = character(),
                          Rating = numeric(),
                          Year = integer(),
                          RatingCount = integer(),
                          PlotSummary = character())

    data[1,1]=as.character(content$title$title)
    data[1,2]=as.character(content$title$titleType)
    data[1,3]=as.numeric(content$ratings$rating)
    data[1,4]=as.integer(content$title$year)
    data[1,5]=as.integer(content$ratings$ratingCount)
    data[1,6]=as.character(content$plotSummary$text)
  }else{
    data<- dplyr::tibble(Title = character(),
                         TitleType = character(),
                         Rating = numeric(),
                         NumberOfEpisode = character(),
                         SeriesStartYear = integer(),
                         SeriesEndYear = integer(),
                         RatingCount = integer(),
                         PlotSummary = character())

    data[1,1]=as.character(content$title$title)
    data[1,2]=as.character(content$title$titleType)
    data[1,3]=as.numeric(content$ratings$rating)
    data[1,4]=as.character(content$title$numberOfEpisodes)
    data[1,5]=as.integer(content$title$seriesStartYear)
    if(is.null(content$title$seriesEndYear) == TRUE){
      data[1,6]="On going"
    }else{
      data[1,6]=as.integer(content$title$seriesEndYear)
    }
    data[1,7]=as.integer(content$ratings$ratingCount)
    data[1,8]=as.character(content$plotSummary$text)
  }

  table = dplyr::as_tibble(cbind(Overview = names(data), t(data)))
  names(table) = c("Overview", "Results")
  return(table)
}
