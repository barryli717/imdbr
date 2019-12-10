#' more
#'
#' This function gets more similar movies/TV shows of the input.
#'
#' @import httr dplyr stringr jsonlite
#' @param name Name of the title, fuzzy name is supported. Default as `FALSE`.
#' @param id The id of your inquiry title. Default as `FALSE`.
#' @return Basic information of similar titles, as a dataframe.
#' @author Yunong Li
#' @export
#' @examples
#'
#' # Gets the characters of "game of thrones".
#' more(name = "game of thrones")
#'
#' # Gets the characters of id="tt0944947".
#' more(id = "tt0944947")


more <- function(name=FALSE, id=FALSE){
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

  # get similar titles' id
  query1= list("tconst"= id)

  endpoint1 = "https://imdb8.p.rapidapi.com/title/get-more-like-this"
  response1 = httr::GET(url = endpoint1,
                       add_headers('x-rapidapi-host' = Sys.getenv("RAPID_API_HOST"),
                                   'x-rapidapi-key' = Sys.getenv("RAPID_API_KEY")),
                       query = query1)
  text1 = suppressMessages(httr::content(response1, as = "text"))
  content1 = jsonlite::fromJSON(text1)

  if(length(content1)>=5){
    querynum = 5
  }else{
    querynum = length(content1)
  }

  ids = c()
  for (i in 1:querynum) {
    ids[i] = stringr::str_sub(content1[i], start = 8L, end = -2L)
  }

  # query titles' info with ids
  data = dplyr::tibble(TitleName=character(),
                       TitleId=character(),
                       Type=character(),
                       Rating=numeric())

  for (i in 1:querynum) {
    info = imdbr::overview(id = ids[i])
    data[i,1] = info[1,2]
    data[i,2] = ids[i]
    data[i,3] = info[2,2]
    data[i,4] = info[3,2]
  }


  return(data)
}
