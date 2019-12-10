#' top_crew
#'
#' This function gets the names of directors and writers of a movie/TV show.
#'
#' @import httr dplyr stringr jsonlite
#' @param name Name of the title, fuzzy name is supported. Default as `FALSE`.
#' @param id The id of your inquiry title. Default as `FALSE`.
#' @return Names of top crew, as a dataframe.
#' @author Yunong Li
#' @export
#' @examples
#'
#' # Gets the overview of "game of thrones".
#' top_crew(name = "game of thrones")
#'
#' # Gets the overview of id="tt0944947".
#' top_crew(id = "tt0944947")



top_crew <- function(name=FALSE, id=FALSE){
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

  endpoint = "https://imdb8.p.rapidapi.com/title/get-top-crew"
  response = httr::GET(url = endpoint,
                       add_headers('x-rapidapi-host' = Sys.getenv("RAPID_API_HOST"),
                                   'x-rapidapi-key' = Sys.getenv("RAPID_API_KEY")),
                       query = query)
  text = suppressMessages(httr::content(response, as = "text"))
  content = jsonlite::fromJSON(text)

  directors = dplyr::tibble(Name = content$directors$name, Category = content$directors$category)
  writers = dplyr::tibble(Name = content$writers$name, Category = content$writers$category)

  data = rbind(directors, writers)
  return(data)
}
