library(yaml)
library(tidyverse)
library(lubridate)
library(glue)


score_submission <- function(submission_filename) {
  answers <- yaml.load_file(submission_filename)
  
  N_lobular_guess <- as.integer(answers$N_lobular)
  N_lobular_actual <- as.integer(201)
  N_lobular_diff <- N_lobular_guess - N_lobular_actual
  if (N_lobular_diff < 0) {
    N_lobular_msg <- "Your guess was too small."
  } else if (N_lobular_diff > 0) {
    N_lobular_msg <- "Your guess was too big."
  } else {
    N_lobular_msg <- "Nailed it!"
  }
  
  N_tumor_free_guess <- as.integer(answers$N_tumor_free)
  N_tumor_free_actual <- as.integer(923)
  N_tumor_free_diff <- N_tumor_free_guess - N_tumor_free_actual
  if (N_tumor_free_diff < 0) {
    N_tumor_free_msg <- "Your guess was too small."
  } else if (N_tumor_free_diff > 0) {
    N_tumor_free_msg <- "Your guess was too big."
  } else {
    N_tumor_free_msg <- "Nailed it!"
  }
  
  answers["N_lobular_comment"] <- N_lobular_msg
  answers["N_tumor_free_comment"] <- N_tumor_free_msg
  answers
}
