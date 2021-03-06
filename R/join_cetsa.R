#' join_cetsa
#'
#' Function to join a list of data frame from CETSA experiment and renamed the column.
#' (Allow to avoid the adding of ".x" or ".y" at the end of the column names)
#'
#' @param list_data A list of data frames. Usually the data frames are the output from the ms_2D_caldiff function.
#' @param new_names The new character element you want to add at the end of the columns name.
#'
#' @import plyr
#' @import mineCETSA
#'
#' @return The joined data frame (by 'id' and 'description')
#'
#' @export
#'
#' @examples
#' test <- mineCETSA::K562InCell
#' test <- test[1:10,]
#' test2 <- test[1:5,]
#' join_cetsa(list(test, test2))

join_cetsa <- function(list_data, new_names = c("1h", "6h")){
  if(sum(str_detect(new_names, "_|/")) > 0){
    stop("Please enter a valid suffix. The character '_' and '/' are not allowed.")
  }
  if(sum(class(list_data) == "data.frame") >= 1){
    list_data <- list(list_data)
  }
  n <- length(list_data)

  if(length(new_names) != n){
    stop("You need to provide as many new_names as you have data.frame in your list !")
  }

  list_data <- mapply(function(x,y){ colnames(x)[!(colnames(x) %in% c("id", "description"))] <-
                                       paste0(colnames(x)[!(colnames(x) %in% c("id", "description"))], y); x},
                      list_data, new_names, SIMPLIFY = FALSE)

  df <- plyr::join_all(list_data, by = c("id", "description"), type = "full")

  return(df)
}




