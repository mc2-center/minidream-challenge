library(yaml)
# library(tidyverse)
# library(lubridate)
# library(glue)

check_str_type <- function(term) {
  return (ifelse(
    assertthat::is.string(term),
    "Nice choice!",
    "Term chosen should be a string/text."
  ))
}
check_number_type <- function(n) {
  return (ifelse(
    assertthat::is.number(n),
    "",
    "Fold enrichment value should be a number."
  ))
}

score_submission <- function(submission_filename) {
  answers <- yaml.load_file(submission_filename)
  
  term1_msg <- check_str_type(answers$term1)
  term2_msg <- check_str_type(answers$term2)
  FE1_msg <- check_number_type(answers$FE1)
  FE2_msg <- check_number_type(answers$FE2)
  
  answers["term1_comment"] <- term1_msg
  answers["term2_comment"] <- term2_msg
  answers["FE1_comment"] <- FE1_msg
  answers["FE2_comment"] <- FE2_msg

  answers
}
