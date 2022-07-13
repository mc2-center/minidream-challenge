# library(yaml)
# library(tidyverse)
# library(glue)
# library(rprojroot)


# root_dir <- find_root(is_rstudio_project, thisfile())
# data_dir <- file.path(root_dir, "data")

# score_submission <- function(submission_filename) {
#   load(file.path(data_dir, "metabric_val_clin_df.RData"))
#   load(file.path(data_dir, "metabric_val_expr_df.RData"))
  
#   answers <- yaml.load_file(submission_filename)
  
#   goldstandard_df <- select(metabric_val_clin_df, metabric_id, T)
#   submission_df <- as.tibble(answers$prediction) %>% 
#     mutate(T = as.integer(T))

#   check_df <- left_join(submission_df, goldstandard_df, by = "metabric_id")
#   print(plot(check_df$T.x, check_df$T.y))
#   s <- summary(lm(T.y ~ T.x, data = check_df))
#   answers$r_squared <- sprintf("%0.4f", s$r.squared)
#   answers$rmse <- sprintf("%0.3f", sqrt(mean(s$residuals^2)))
#   answers$prediction <- NULL
#   answers
# }

library(yaml)
library(tidyverse)
library(lubridate)
library(glue)


score_submission <- function(submission_filename) {
  answers <- yaml.load_file(submission_filename)
  
  distance_metric <- answers$distance_metric
  cluster_method <- answers$cluster_method
  num_clusters <- answers$num_clusters
  p_value <- answers$p_value
  
  answers["distance_metric"] <- distance_metric
  answers["cluster_method"] <- cluster_method
  answers["num_clusters"] <- num_clusters
  answers["p_value"] <- p_value

  answers
}
