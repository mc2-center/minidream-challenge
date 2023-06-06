library(yaml)
# library(tidyverse)
# library(lubridate)
# library(glue)

check_answer <- function(pred, key) {
  diff <- as.integer(pred) - as.integer(key)
  if (diff < 0) {
    return "Your guess was too small."
  } else if (diff > 0) {
    return "Your guess was too big."
  } else {
    return "Nailed it!"
  }
}

score_submission <- function(submission_filename) {
  answers <- yaml.load_file(submission_filename)
  
  N_stage2_msg <- check_answer(answers$N_stage2, key=615)
  N_tumor_msg <- check_answer(answers$N_tumor, key=123)
  N_tumor_II_msg <- check_answer(answers$N_stage_II, key=64)
  
  answers["N_stage2_comment"] <- N_stage2_msg
  answers["N_tumor_comment"] <- N_tumor_msg
  answers["N_tumor_II_comment"] <- N_tumor_II_msg
  answers
}
