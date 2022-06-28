library(yaml)
library(tidyverse)
library(lubridate)
library(glue)


score_submission <- function(submission_filename) {
  answers <- yaml.load_file(submission_filename)
  
  gene_fast <- answers$gene_fast
  gene_slow <- answers$gene_slow
  reason_slow <- answers$reason_slow
  reason_fast <- answers$reason_fast
  
  answers["gene_fast"] <- gene_fast
  answers["gene_slow"] <- gene_slow
  answers["reason_slow"] <- reason_slow
  answers["reason_fast"] <- reason_fast

  answers
}