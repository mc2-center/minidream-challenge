library(yaml)
# library(tidyverse)
# library(lubridate)
# library(glue)

check_answer <- function(pred, key) {
  diff <- as.integer(pred) - as.integer(key)
  if (diff < -0.5) {
    return("Your mean expression level is too low.")
  } else if (diff > 0.5) {
    return("Your mean expression level is too high.")
  } else {
    return("Nailed it!")
  }
}

score_submission <- function(submission_filename) {
  answers <- yaml.load_file(submission_filename)
  
  esr1_msg <- check_answer(answers$esr1, key=10509)
  erbb2_msg <- check_answer(answers$erbb2, key=18198)
  skew_msg <- ifelse(answers$skew == "positive", "Yes, ", "No, ")
  
  answers["esr1_comment"] <- esr1_msg
  answers["erbb2_comment"] <- erbb2_msg
  answers["skew_comment"] <- paste0(skew_msg, "the data is positively skewed.")

  answers
}