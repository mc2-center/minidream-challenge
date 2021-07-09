library(yaml)
library(tidyverse)
library(glue)
library(rprojroot)


score_submission <- function(submission_filename) {
  
  answers <- 
  	yaml.load_file(submission_filename) %>% 
    map(str_trim)
  
  get_comment <- function(answer, expected, lower_bound, upper_bound) {
    actual <- as.numeric(answer)
    if (isTRUE(all.equal(actual, expected))) {
      comment <- "Nailed it!"
    } else if (actual >= lower_bound & actual <= upper_bound) {
      comment <- "Close enough!"
    } else if (actual < lower_bound) {
      comment <- glue("Hmm, {actual} is an underestimate")
    } else if (actual > upper_bound) {
      comment <- glue("Hmm, {actual} is an overestimate")
    } else {
      comment <- "Something unexpected happened"
    }
    comment
  }
  
  answers["nc_bound_final_comment"] <- 
    get_comment(answers$nc_bound_final, 68.2, 65, 70)
  
  answers["time_half_comment"] <- 
    get_comment(answers$time_half, 0.63, 0.6, 0.7)
  
  answers["unbound_freq_comment"] <- 
    get_comment(answers$unbound_freq, 6.7, 5, 10)
  
  answers["mforce_mean_comment"] <- 
    get_comment(answers$mforce_mean, 21, 20, 22)
  
  answers["unbound_freq_deform_comment"] <- 
    get_comment(answers$unbound_freq_deform, 0.085, 0.07, 0.1)
  
  answers["mforce_mean_deform_comment"] <- 
    get_comment(answers$mforce_mean_deform, 80.8, 75, 85)

  answers
}

