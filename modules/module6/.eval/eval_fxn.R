library(yaml)
library(tidyverse)
library(glue)
library(rprojroot)


score_submission <- function(submission_filename) {
  
  answers <- 
  	yaml.load_file(submission_filename) %>% 
    map(str_trim)

  optimal_stiffness_guess <- answers$optimal_stiffness

  optimal_stiffness_actual <- as.integer(1)

  if (optimal_stiffness_guess == optimal_stiffness_actual){
    optimal_stiffness_mesg <- "Nailed it!"
  } else {
    optimal_stiffness_mesg <- "Hmm, your answer was not correct."
  }

  answers["optimal_stiffness_mesg"] <- optimal_stiffness_mesg
  
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
      comment <- "Hmm, something unexepected happened"
    }
    comment
  }
  
  answers["unbound_freq_deform_mesg"] <- 
    get_comment(answers$unbound_freq_deform, 0.076, 0.05, 0.1)
  
  answers["mforce_mean_deform_mesg"] <- 
    get_comment(answers$mforce_mean_deform, 76.6, 70, 85)
  
  answers["traction_ratio_mesg"] <- 
    get_comment(answers$traction_ratio, 16, 10, 20)

  

  answers
}

