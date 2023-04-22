#!/usr/bin/env Rscript
suppressPackageStartupMessages(library(argparse))
suppressPackageStartupMessages(library(jsonlite))
suppressPackageStartupMessages(library(rprojroot))

parser <- ArgumentParser(description = 'Score submission')
parser$add_argument('-f', '--submission_file',  type = "character", required = T,
                    help = 'Submission path')
parser$add_argument('-r', '--results',  type = "character", required = T,
                    help = 'Results file')
args <- parser$parse_args()

root_dir <- find_root(is_rstudio_project, thisfile())

module_map = c(
  "activity-0.yml"=0, "activity-1.yml"=1,
  "activity-2.yml"=2, "activity-3.yml"=3,
  "activity-4.yml"=1, "activity-4.yml"=4,
  "activity-5.yml"=1, "activity-6.yml"=1,
  "activity-7.yml"
)

compute_scores <- function(submission_path) {
  filename = basename(submission_path)
  filename_split = unlist(strsplit(filename, "_"))
  module_name = filename_split[2]
  module_no = module_map[module_name]
  username = filename_split[1]
  # Path on docker container
  eval_path = glue::glue('/modules/module{module_no}/.eval/eval_fxn.R')
  source(eval_path)
  # TODO: add in module 6 later
  # if moduleNo == 6:
  #   entity_annots = submission.entity['annotations']
  #   with open(submission.filePath, 'w') as f:
  #     f.write(entity_annots['yaml'][0])

  annotations = score_submission(submission_path)
  annotations$module = glue::glue("Module {module_no}")
  annotations$userName = username
  return(annotations)
}

# Mapping of scores
scores = compute_scores(args$submission_file)
scores$submission_status = "SCORED"

export_json <- toJSON(scores, auto_unbox = TRUE, pretty=T)
write(export_json, args$results)
