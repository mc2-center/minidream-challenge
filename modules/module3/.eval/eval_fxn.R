library(yaml)
library(tidyverse)
library(lubridate)
library(glue)


score_submission <- function(submission_filename) {
  answers <- yaml.load_file(submission_filename)
  
  determinant_guess <- answers$determinant_n
  dist_euclidean_guess <- answers$dist_euclidean
  dist_canberra_guess <- format(round(answers$dist_canberra, 2), nsmall = 2)
  cluster1_guess <- answers$cluster1
  cluster2_guess <- answers$cluster2
  cluster3_guess <- answers$cluster3


  determinant_actual <- as.integer(0)
  dist_euclidean_actual <- as.integer(294)
  dist_canberra_actual <- as.numeric(1.92)

  cluster1_actual <- as.integer(1)
  cluster2_actual <- as.integer(2)
  cluster3_actual <- as.integer(3)

  if (determinant_guess == determinant_actual){
    determinant_msg <- "Nailed it!"
  } else {
    determinant_msg <- "Your answer is incorrect"
  }

  if (dist_euclidean_guess == dist_euclidean_actual){
    dist_euclidean_msg <- "Nailed it!"
  } else {
    dist_euclidean_msg <- "Your answer is incorrect"
  }

  if (dist_canberra_guess == dist_canberra_actual){
    dist_canberra_msg <- "Nailed it!"
  } else {
    dist_canberra_msg <- "Your answer is incorrect"
  }

  if (cluster1_guess == cluster1_actual){
    cluster1_msg <- "Nailed it!"
  } else {
    cluster1_msg <- "Your answer is incorrect"
  }

  if (cluster2_guess == cluster2_actual){
    cluster2_msg <- "Nailed it!"
  } else {
    cluster2_msg <- "Your answer is incorrect"
  }

  if (cluster3_guess == cluster3_actual){
    cluster3_msg <- "Nailed it!"
  } else {
    cluster3_msg <- "Your answer is incorrect"
  }

  answers["determinant_msg"] <- determinant_msg
  answers["dist_euclidean_msg"] <- dist_euclidean_msg
  answers["dist_canberra_msg"] <- dist_canberra_msg
  answers["cluster1_msg"] <- cluster1_msg
  answers["cluster2_msg"] <- cluster2_msg
  answers["cluster3_msg"] <- cluster3_msg

  answers
}