library(yaml)
library(tidyverse)
library(lubridate)
library(glue)


score_submission <- function(submission_filename) {
  answers <- yaml.load_file(submission_filename)
  
  nc_bound_final_guess <- answers$nc_bound_final
  time_half_guess <- answers$time_half
  unbound_freq_guess <- answers$unbound_freq
  mforce_mean_guess <- answers$mforce_mean



  if (nc_bound_final_guess > 65 && nc_bound_final_guess < 70){
    nc_bound_mesg <- "Nailed it!"
  } else {
    nc_bound_mesg <- "Your answer was not correct."
  }


  if (time_half_guess > 0.6 && time_half_guess < 0.7){
    time_half_mesg <- "Nailed it!"
  } else {
    time_half_mesg <- "Your answer was not correct."
  }

  if (unbound_freq_guess > 5 && unbound_freq_guess < 10){
    unbound_freq_mesg <- "Nailed it"
  } else {
    unbound_freq_mesg <- "Your answer was not correct"
  }

  if (mforce_mean_guess > 20 && mforce_mean_guess < 22){
    mforce_mean_mesg <- "Nailed it"
  } else {
    mforce_mean_mesg <- "Your answer was not correct"
  }




  answers["nc_bound_mesg"] <- nc_bound_mesg
  answers["time_half_mesg"] <- time_half_mesg
  answers["unbound_freq_mesg"] <- unbound_freq_mesg
  answers["mforce_mean_mesg"] <- mforce_mean_mesg

  answers
}