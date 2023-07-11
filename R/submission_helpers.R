library(yaml)
library(jsonlite)
library(getPass)

reticulate::use_condaenv("base")
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
  
  N_stage2_guess <<- N_stage2
  N_tumor_guess <<- N_tumor
  N_tumor_II_guess <<- N_tumor_II 
  
  answers <- list(
    N_stage2 = N_stage2_guess, 
    N_tumor = N_tumor_guess,
    N_tumor_II = N_tumor_II_guess
  )
  write_yaml(answers, submission_filename)
  submission_filename
}

create_module2_submission <- function() {
  submission_filename <- paste(Sys.getenv("USER"), "activity-2.yml", sep = "_")
  
  esr1_guess <<- esr1
  erbb2_guess <<- erbb2
  skew_guess <<- skew
  
  answers <- list(
    esr1 = format(esr1_guess, scientific=FALSE), 
    erbb2 = format(erbb2_guess, scientific=FALSE), 
    skew = skew_guess
  )
  write_yaml(answers, submission_filename)
  submission_filename
}

create_module3_submission <- function() {
  submission_filename <- paste(Sys.getenv("USER"), "activity-3.yml", sep = "_")
  
  PRpos_guess <<- PRpos
  PRneg_guess <<- PRneg
  PR_ER_neg_overlap_guess <<- trimws(toupper(PR_ER_neg_overlap))
  PR_ER_pos_overlap_guess <<- trimws(toupper(PR_ER_pos_overlap))
  cluster_guess <<- cluster_number
  
  answers <- list(
    PRpos = PRpos_guess, 
    PRneg = PRneg_guess, 
    PR_ER_neg_overlap = PR_ER_neg_overlap_guess, 
    PR_ER_pos_overlap = PR_ER_pos_overlap_guess,
    cluster_number = cluster_guess
  )
  write_yaml(answers, submission_filename)
  submission_filename
}

create_module4_submission <- function() {
  submission_filename <- paste(Sys.getenv("USER"), "activity-4.yml", sep = "_")
  
  term1_chosen <<- term1
  term2_chosen <<- term2
  FE1_chosen <<- FE1
  FE2_chosen <<- FE2
  
  answers <- list(
    term1 = term1_chosen, 
    term2 = term2_chosen,
    FE1 = FE1_chosen,
    FE2 = FE2_chosen
  )
  write_yaml(answers, submission_filename)
  submission_filename
}


create_module5_submission <- function() {
  submission_filename <- paste(Sys.getenv("USER"), "activity-5.yml", sep = "_")
  
  nc_bound_final_guess <<- nc_bound_final
  time_half_guess <<- time_half
  unbound_freq_guess <<- unbound_freq
  mforce_mean_guess <<- mforce_mean
  unbound_freq_deform_guess <<- unbound_freq_deform
  mforce_mean_deform_guess <<- mforce_mean_deform
  Equation_SubDeform_MForce_guess <<- Equation_SubDeform_MForce

  answers <- list(
    nc_bound_final = nc_bound_final_guess,
    time_half = time_half_guess, 
    unbound_freq = unbound_freq_guess,
    mforce_mean = mforce_mean_guess,
    unbound_freq_deform = unbound_freq_deform_guess,
    mforce_mean_deform = mforce_mean_deform_guess,
    Equation_SubDeform_MForce = trimws(tolower(Equation_SubDeform_MForce_guess))
  )
  write_yaml(answers, submission_filename)
  submission_filename
}

create_module6_submission <- function() {
  submission_filename <- paste(Sys.getenv("USER"), "activity-6.yml", sep = "_")

  unbound_freq_deform <<- unbound_freq_deform
  mforce_mean_deform <<- mforce_mean_deform
  optimal_stiffness <<- optimal_stiffness
  traction_ratio <<- traction_ratio
  
  answers <- list(
    unbound_freq_deform = unbound_freq_deform,
    mforce_mean_deform = mforce_mean_deform,
    optimal_stiffness = optimal_stiffness,
    traction_ratio = traction_ratio
  )
  write_yaml(answers, submission_filename)
  submission_filename
}

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
    "0" = "syn51381271",
    "1" = "syn51381272",
    "2" = "syn51381273",
    "3" = "syn51381274",
    "4" = "syn51381275",
    "5" = "syn51381276",
    "6" = "syn51381277",
    "7" = "syn51381278"
  )
  
  if (!local) {
    activity_submission <- synStore(
      File(path = submission_filename, parentId = submission_folder)
    )
    submission <- synSubmit(evaluation = "9615336", 
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
    pat <- getPass("Your Synapse PAT")
    tryCatch({
      synLogin(authToken = pat, rememberMe = TRUE, silent = TRUE)
      message("Remembering Synapse credentials for future logins...")
    }, error = function(e) {
      if (grepl("You are not logged in", e)) {
        message(paste(
          "Something went wrong while trying to log in with your PAT. Try ",
          "logging in again by re-running synLoginSecure(). If the error ",
          "persists, try generating a new token."
        ))
      } else {
        print(paste(e))
      }
    })
  })
}
