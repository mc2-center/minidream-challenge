import os

# Use rpy2 if you have R scoring functions
import rpy2.robjects as robjects

##-----------------------------------------------------------------------------
##
## challenge specific code and configuration
##
##-----------------------------------------------------------------------------


## A Synapse project will hold the assetts for your challenge. Put its
## synapse ID here, for example
## CHALLENGE_SYN_ID = "syn1234567"
CHALLENGE_SYN_ID = "syn51197448"


## Name of your challenge, defaults to the name of the challenge's project
CHALLENGE_NAME = "2023 miniDREAM Challenge"

## Synapse user IDs of the challenge admins who will be notified by email
## about errors in the scoring script
ADMIN_USER_IDS = [
    3423548,  # Pierette
    3393723,  # Verena
]


def score(submission):
    fileName = os.path.basename(submission.filePath)
    fileNameSplit = fileName.split("_")
    moduleName = fileNameSplit[-1]
    moduleNo = module_by_name[moduleName]["module"]
    userName = fileNameSplit[0]
    filePath = os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        f"../modules/module{moduleNo}/.eval/eval_fxn.R"
    )
    robjects.r(f"source('{filePath}')")
    scoring_func = robjects.r('score_submission')
    results = scoring_func(submission.filePath)
    annotations = {}
    for key, value in zip(results.names, results):
        if key and value:
            annotations[key]=value[0]

    annotations['module'] = f"Module {moduleNo}"
    annotations['userName'] = userName
    return(annotations)


def score_submission(evaluation, submission):
    """
    Find the right scoring function and score the submission

    :returns: (score, message) where score is a dict of stats and message
              is text for display to user
    """
    config = evaluation_queue_by_id[int(evaluation.id)]
    score = config['scoring_func'](submission)
    return (score, "You did fine!")


## Each question in your challenge should have an evaluation queue through
## which participants can submit their predictions or models. Here we link
## the challenge queues to the correct scoring/validation functions.
evaluation_queues = [
    {
        'id': 9615336,
        'scoring_func': score,
    }
]
evaluation_queue_by_id = {q['id']:q for q in evaluation_queues}

module_config = [
    {
        "fileName":"activity-0.yml",
        "module": 0
    },
    {
        "fileName": "activity-1.yml",
        "module": 1
    },
    {
        "fileName": "activity-2.yml",
        "module": 2
    },
    {
        "fileName": "activity-3.yml",
        "module": 3
    },
    {
        "fileName": "activity-4.yml",
        "module": 4
    },
    {
        "fileName": "activity-5.yml",
        "module": 5
    },
    {
        "fileName": "activity-6.yml",
        "module": 6
    },
    {
        "fileName": "activity-7.yml",
        "module": 7
    },
]
module_by_name = {q['fileName']:q for q in module_config}


# def validate_submission(evaluation, submission):
#     """
#     Find the right validation function and validate the submission.
#     :returns: (True, message) if validated, (False, message) if
#               validation fails or throws exception
#     """
#     config = evaluation_queue_by_id[int(evaluation.id)]
#     validated, validation_message = config['validation_func'](submission, config['goldstandard_path'])
#     return True, validation_message
