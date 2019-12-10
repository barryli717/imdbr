#' get_id
#'
#' This funtion gets the imdb id for a certain title.
#'
#' @import httr stringr
#' @param name Name of the title, fuzzy name is supported.
#' @return The id of the title.
#' @author Yunong Li
#' @export
#' @examples
#'
#' # Gets the id of "game of thrones".
#' get_id("game of thrones")
#'


get_id <- function(name){
  query <- list("q" = name)
  endpoint = "https://imdb8.p.rapidapi.com/title/find"
  response = httr::GET(url = endpoint,
                       add_headers('x-rapidapi-host' = Sys.getenv("RAPID_API_HOST"),
                                   'x-rapidapi-key' = Sys.getenv("RAPID_API_KEY")),
                       query = query)
  content = httr::content(response)
  id = stringr::str_sub(content$results[[1]]$id, start = 8L, end = -2L)
  return(id)
}
