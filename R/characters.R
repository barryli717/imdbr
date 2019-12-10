#' characters
#'
#' This function gets the names of roles and actors/actresses of a movie/TV show.
#'
#' @import httr dplyr stringr jsonlite
#' @param name Name of the title, fuzzy name is supported. Default as `FALSE`.
#' @param id The id of your inquiry title. Default as `FALSE`.
#' @return Names of characters, as a dataframe.
#' @author Yunong Li
#' @export
#' @examples
#'
#' # Gets the characters of "game of thrones".
#' top_crew(name = "game of thrones")
#'
#' # Gets the characters of id="tt0944947".
#' top_crew(id = "tt0944947")


characters <- function(name=FALSE, id=FALSE){
  # get the id of the title
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

  # query name_id with id, limit 10 results
  query1 = list("tconst"= id)

  endpoint1 = "https://imdb8.p.rapidapi.com/title/get-top-cast"
  response1 = httr::GET(url = endpoint1,
                        add_headers('x-rapidapi-host' = Sys.getenv("RAPID_API_HOST"),
                                    'x-rapidapi-key' = Sys.getenv("RAPID_API_KEY")),
                        query = query1)
  text1 = suppressMessages(httr::content(response1, as = "text"))
  content1 = jsonlite::fromJSON(text1)

  if(length(content1)>=10){
    querynum = 10
  }else{
    querynum = length(content1)
  }

  name_id = c()
  for (i in 1:querynum) {
    name_id[i] = stringr::str_sub(content1[i], start = 7L, end = -2L)
  }

  # query characters with name_id and id

  data = dplyr::tibble(CharecterName=character(), RoleName=character())

  for (i in 1:querynum) {
    query2 = list("id"=name_id[i],"tconst"=id)

    endpoint2 = "https://imdb8.p.rapidapi.com/title/get-charname-list"
    response2 = httr::GET(url = endpoint2,
                          add_headers('x-rapidapi-host' = Sys.getenv("RAPID_API_HOST"),
                                      'x-rapidapi-key' = Sys.getenv("RAPID_API_KEY")),
                          query = query2)
    content2 = suppressMessages(jsonlite::fromJSON(httr::content(response2, as = "text")))

    data[i,1] = content2[[1]]$name$name
    data[i,2] = content2[[1]]$charname$characters[[1]][1]

  }

  return(data)

}
