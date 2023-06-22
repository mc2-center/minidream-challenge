library(yaml)
# library(tidyverse)
# library(lubridate)
# library(glue)

check_answer <- function(pred, key) {
  if (is.na(pred)) {
    return ("Your guess is missing or NA.")
  }
  diff <- as.integer(pred) - as.integer(key)
  if (diff < 0) {
    return("Your guess was too small.")
  } else if (diff > 0) {
    return("Your guess was too big.")
  } else {
    return("Nailed it!")
  }
}


score_submission <- function(submission_filename) {
  answers <- yaml.load_file(submission_filename)

  PRpos_msg <- check_answer(answers$PRpos, key=177)
  PRneg_msg <- check_answer(answers$PRneg, key=81)
  PR_ER_neg_overlap_msg <- ifelse(
    answers$PR_ER_neg_overlap == "YES",
    "You're right, ",
    "Not quite, "
  )
  PR_ER_pos_overlap_msg <- ifelse(
    answers$PR_ER_pos_overlap == "YES",
    "You're right, ",
    "Not quite, "
  )
  cluster_msg <- check_answer(answers$cluster_number, key=3)

  answers["PRpos_comment"] <- PRpos_msg
  answers["PRneg_comment"] <- PRneg_msg
  answers["PR_ER_neg_overlap_comment"] <- paste0(
    PR_ER_neg_overlap_msg,
    "there is an overlap in the clusters for ER- and PR-."
  )
  answers["PR_ER_pos_overlap_comment"] <- paste0(
    PR_ER_pos_overlap_msg,
    "there is an overlap in the clusters for ER+ and PR+."
  )
  answers["clusters_comment"] <- cluster_msg

  answers
}