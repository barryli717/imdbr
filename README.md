# imdbr



## 1. Description

This package contains functions to query infomation of movies/TV shows on IMDb (https://www.imdb.com/).


## 2. Before Installation

- Make sure you subscribe for the **imdb8** API on https://rapidapi.com/apidojo/api/imdb8/details 

- Modify your `Renviron` file under the directory: `/Library/Frameworks/R.framework/Versions/3.6/Resources/etc` (on MacOS)

Add following lines:

```
# API Token for RAPID_API
RAPID_API_HOST = imdb8.p.rapidapi.com
RAPID_API_KEY = YOUR API KEY
```

## 3. Installation

### Install from GitHub
```R
devtools::install_github("barryli717/imdbr")
```

### Load
```R
library("imdbr")
```

## 4. Functions
- `get_id()`: return the imdb id of a certain movie or show;

```R
get_id(name = "sherlock")
#> [1] "tt1475582"
```

- `overview()`: get overview of a title;

```R
overview(name = "game of thrones")
#> # A tibble: 8 x 2
#>   Overview       Results                                            
#>   <chr>          <chr>                                              
#> 1 Title          Game of Thrones                                    
#> 2 TitleType      tvSeries                                           
#> 3 Rating         9.4                                                
#> 4 NumberOfEpiso… 73                                                 
#> 5 SeriesStartYe… 2011                                               
#> 6 SeriesEndYear  2019                                               
#> 7 RatingCount    1612242                                            
#> 8 PlotSummary    In the mythical continent of Westeros, several pow…
```

- `top_crew()`: get information about top crews;

```R
top_crew(name = "inception")
#> # A tibble: 2 x 2
#>   Name              Category
#>   <chr>             <chr>   
#> 1 Christopher Nolan director
#> 2 Christopher Nolan writer  
```

- `characters()`: get character information;

```R
characters(name = "interstellar")
#> # A tibble: 10 x 2
#>    CharecterName       RoleName        
#>  * <chr>               <chr>           
#>  1 Matthew McConaughey Cooper          
#>  2 Anne Hathaway       Brand           
#>  3 Jessica Chastain    Murph           
#>  4 Mackenzie Foy       Murph (10 Yrs.) 
#>  5 Ellen Burstyn       Murph (Older)   
#>  6 John Lithgow        Donald          
#>  7 Timothée Chalamet   Tom (15 Yrs.)   
#>  8 David Oyelowo       School Principal
#>  9 Collette Wolfe      Ms. Hanley      
#> 10 Francis X. McCarthy Boots   
```
- `more()`: get more titles like this;

```R
more(name = "2012")
#> # A tibble: 5 x 4
#>   TitleName              TitleId   Type  Rating
#> * <chr>                  <chr>     <chr> <chr> 
#> 1 The Day After Tomorrow tt0319262 movie 6.4   
#> 2 Independence Day       tt0116629 movie 7     
#> 3 Armageddon             tt0120591 movie 6.7   
#> 4 World War Z            tt0816711 movie 7     
#> 5 I, Robot               tt0343818 movie 7.1   
```

