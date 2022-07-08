library(yaml)
library(jsonlite)
library(getPass)
library(synapser)

create_module0_submission <- function() {
  submission_filename <- paste(Sys.getenv("USER"), "activity-0.yml", sep = "_")
  
  bday <<- my_bday_guess
  age <<- my_age_guess

  answers <- list(
    bday = bday, 
    age = age 
  )
  write_yaml(answers, submission_filename)
  submission_filename
}

create_module1_submission <- function() {
  submission_filename <- paste(Sys.getenv("USER"), "activity-1.yml", sep = "_")
  
  N_lobular_guess <<- N_lobular
  N_tumor_free_guess <<- N_tumor_free
  
  answers <- list(
    N_lobular = N_lobular_guess, 
    N_tumor_free = N_tumor_free_guess 
  )
  write_yaml(answers, submission_filename)
  submission_filename
}

create_module2_submission <- function() {
  submission_filename <- paste(Sys.getenv("USER"), "activity-2.yml", sep = "_")
  
  gene_fast <<- my_gene_fast
  gene_slow <<- my_gene_slow
  reason_slow <<- my_reason_slow
  reason_fast <<- my_reason_fast
  
  answers <- list(
    gene_fast = gene_fast, 
    gene_slow = gene_slow, 
    reason_slow = reason_slow, 
    reason_fast = reason_fast
  )

  write_yaml(answers, submission_filename)
  submission_filename
}

create_module3_submission <- function() {
  submission_filename <- paste(Sys.getenv("USER"), "activity-3.yml", sep = "_")
  
  determinant_n <<- my_determinant
  dist_euclidean <<- my_dist_eucl
  dist_canberra <<- my_dist_canb
  cluster1<<- my_cluster1
  cluster2<<- my_cluster2
  cluster3<<- my_cluster3
  
  answers <- list(
    determinant_n = determinant_n, 
    dist_euclidean = dist_euclidean, 
    dist_canberra = dist_canberra, 
    cluster1 = cluster1,
    cluster2 = cluster2,
    cluster3 = cluster3
  )

  write_yaml(answers, submission_filename)
  submission_filename
}


# create_module3_old_submission <- function() {
#   submission_filename <- paste(Sys.getenv("USER"), "activity-3-old.yml", sep = "_")
  
#   pc1_receptor <<- my_pc1_receptor
#   tripleneg_met_association <<- my_tripleneg_met_association
#   hpa_gene <<- my_hpa_gene
#   hpa_is_enchanced <<- my_hpa_is_enchanced
#   hpa_is_prognostic <<- my_hpa_is_prognostic
  
#   answers <- list(
#     pc1_receptor = pc1_receptor, 
#     tripleneg_met_association = tripleneg_met_association, 
#     hpa_gene = hpa_gene, 
#     hpa_is_enchanced = hpa_is_enchanced,
#     hpa_is_prognostic = hpa_is_prognostic
#   )
  
#   write_yaml(answers, submission_filename)
#   submission_filename
# }

create_module4_submission <- function() {
  submission_filename <- paste(Sys.getenv("USER"), "activity-4.yml", sep = "_")
  
  model_gene <<- my_model_gene
  gene_relationship <<- my_gene_relationship
  gene_significance <<- my_gene_significance
  model_judgement <<- my_model_judgement
  prediction <<- my_prediction
  
  answers <- list(
    model_gene = model_gene, 
    gene_relationship = gene_relationship,
    gene_significance = gene_significance,
    model_judgement = model_judgement,
    prediction = prediction
  )
  
  write_yaml(answers, submission_filename)
  submission_filename
}

create_module5_submission <- function() {
  submission_filename <- paste(Sys.getenv("USER"), "activity-5.yml", sep = "_")
  
  gene_count <<- my_gene_count
  go_subontology <<- my_go_subontology
  top_go_id <<- my_top_go_id
  go_description <<- my_go_description
  fav_go_term <<- my_fav_go_term
  rationale <<- my_rationale
  
  answers <- list(
    gene_count = gene_count, 
    go_subontology = go_subontology,
    top_go_id = top_go_id, 
    go_description = go_description, 
    fav_go_term = fav_go_term,
    rationale = rationale
  )
  
  write_yaml(answers, submission_filename)
  submission_filename
}

create_module6_submission <- function() {
  submission_filename <- paste(Sys.getenv("USER"), "activity-6.yml", sep = "_")

  nc_bound_final_sub <<- nc_bound_final
  time_half_sub <<- time_half
  unbound_freq_sub <<- unbound_freq
  mforce_mean_sub <<- mforce_mean
  unbound_freq_deform_sub <<- unbound_freq_deform
  mforce_mean_deform_sub <<- mforce_mean_deform
  Equation_SubDeform_MForce_sub <<- Equation_SubDeform_MForce
  
  answers <- list(
    nc_bound_final = nc_bound_final_sub,
    time_half = time_half_sub,
    unbound_freq = unbound_freq_sub,
    mforce_mean = mforce_mean_sub,
    unbound_freq_deform = unbound_freq_deform_sub,
    mforce_mean_deform = mforce_mean_deform_sub,
    Equation_SubDeform_MForce = Equation_SubDeform_MForce_sub
  )
  
  write_yaml(answers, submission_filename)
  submission_filename
}

# create_module7_old_submission <- function() {
#   submission_filename <- paste(Sys.getenv("USER"), "activity-7-old.yml", sep = "_")
  
#   celladhesion_count <<- my_celladhesion_count
#   myosin_count <<- my_myosin_count
#   high_cellline <<- my_high_cellline
#   cms_match <<- my_cms_match
#   explanation <<- my_explanation
#   pathway_count <<- my_pathway_count
#   takeaway <<- my_takeaway
  
#   answers <- list(
#     celladhesion_count = celladhesion_count, 
#     myosin_count = myosin_count,
#     high_cellline = high_cellline,
#     cms_match = cms_match,
#     explanation = explanation,
#     pathway_count  = pathway_count,
#     takeaway = takeaway
#   )
  
#   write_yaml(answers, submission_filename)
#   submission_filename
# }

submit_module_answers <- function(module, local = FALSE) {
  if (is.numeric(module)) {
    module <- as.character(module)
  }
  submission_filename <- switch(
    module,
    "0" = create_module0_submission(),    
    "1" = create_module1_submission(),
    "2" = create_module2_submission(),
    "3" = create_module3_submission(),
    "4" = create_module4_submission(),
    "5" = create_module5_submission(),
    "6" = create_module6_submission(),
    "7" = create_module7_submission()
  )
  submission_folder <- switch(
    module,
    "0" = "syn29616351",
    "1" = "syn29616391",
    "2" = "syn29616395",
    "3" = "syn29616416",
    "4" = "syn29616438",
    "5" = "syn29616450",
    "6" = "syn29616513",
    "7" = "syn29616560"
  )
  
  if (!local) {
    
    activity_submission <- synStore(
      File(path = submission_filename, parentId = submission_folder)
    )
    submission <- synSubmit(evaluation = "9615035", 
                            entity = activity_submission)
    
    message("")
    message(paste0("Successfully submitted file: '", submission_filename, "'"))
    message(paste0("... stored as '", 
                   fromJSON(submission$entityBundleJSON)$entity$id, "'"))
    message(paste0("Submission ID: '", submission$id))
    
    return(submission)
  } else {
    print(paste0("modules/module", module, "/.eval/eval_fxn.R"))
    source(paste0("modules/module", module, "/.eval/eval_fxn.R"))
    return(as.data.frame(score_submission(submission_filename)))
  }
  

}

create_dummy_files <- function(module, submission_folder) {
  minidream_roster_df %>% 
    filter(!is.na(SynapseUserName)) %>% 
    pluck("SynapseUserName") %>% 
    walk(
      function(x) { 
        text <- str_glue("this is a placeholder file for {s}", s = x)
        filename <- str_glue("module{m}_submissions/{s}_activity-{m}.yml", 
                             m = module, s = x) 
        write_yaml(text, filename)
        syn_id = synStore(File(path = filename, parentId = submission_folder))
        print(syn_id) 
      }
    )
}

synLoginSecure <- function() {
  tryCatch({
    synLogin(silent = TRUE)
    message("Logging into Synapse using remembered credentials...")
  }, error = function(e) {
    username <- getPass("Your Synapse Username")
    password <- getPass("Your Synapse Password")
    tryCatch({
      synLogin(username, password, rememberMe = TRUE, silent = TRUE)
      message("Remembering Synapse credentials for future logins...")
    }, error = function(e) {
      if (grepl("You are not logged in", e)) {
        message(paste(
          "You might have made a typo in your username or password.",
          "Try logging in again by re-running synLoginSecure(). Note that",
          "your Synapse account is separate from your RStudio account."
        ))
      } else {
        print(paste(e))
      }
    })
  })
}
