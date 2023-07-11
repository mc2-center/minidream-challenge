library(yaml)
# library(tidyverse)
# library(lubridate)
# library(glue)

check_answer <- function(pred, lower, upper) {
  if (is.na(pred)) {
    return ("Your guess is NA (missing).")
  }
  if (pred >= lower && pred <= upper)
    return("Nailed it!")
  } else {
    return("Your answer was not correct.")
  }
}

score_submission <- function(submission_filename) {
  answers <- yaml.load_file(submission_filename)
  
  nc_bound_final_msg <- check_answer(answers$nc_bound_final, lower=65, upper=70)
  time_half_msg <- check_answer(answers$time_half, lower=0.6, upper=0.7)
  unbound_freq_msg <- check_answer(answers$unbound_freq, lower=5, upper=10)
  mforce_mean_msg <- check_answer(answers$mforce_mean, lower=20, upper=22)
  unbound_freq_deform_msg <- check_answer(answers$unbound_freq_deform, lower=0.07, upper=0.1)
  mforce_mean_deform_msg <- check_answer(answers$mforce_mean_deform, lower=75, upper=85)
  Equation_SubDeform_MForce_msg <- ifelse(
    answers$Equation_SubDeform_MForce == "yes",
    "Nailed it!",
    "Your answer was not correct."
  )

  answers["nc_bound_comment"] <- nc_bound_msg
  answers["time_half_comment"] <- time_half_msg
  answers["unbound_freq_comment"] <- unbound_freq_msg
  answers["mforce_mean_comment"] <- mforce_mean_msg
  answers["unbound_freq_deform_comment"] <- unbound_freq_deform_msg
  answers["mforce_mean_deform_comment"] <- mforce_mean_deform_msg
  answers["Equation_SubDeform_MForce_comment"] <- Equation_SubDeform_MForce_msg

  answers
}