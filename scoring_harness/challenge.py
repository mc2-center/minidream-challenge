#
# Command line tool for scoring and managing Synapse challenges
#
# To use this script, first install the Synapse Python Client
# http://python-docs.synapse.org/
#
# Log in once using your user name and password
#   import synapseclient
#   syn = synapseclient.Synapse()
#   syn.login(<username>, <password>, rememberMe=True)
#
# Your credentials will be saved after which you may run this script with no credentials.
#
# Author: chris.bare
#
###############################################################################

import argparse
from datetime import datetime, timedelta
import sys
import traceback
import lock

import synapseclient
from synapseclient.core.exceptions import *
from synapseclient import Evaluation
import challengeutils.annotations as annots


try:
    from StringIO import StringIO
except ImportError:
    from io import StringIO

try:
    import challenge_config as conf
except Exception as ex1:
    sys.stderr.write("\nPlease configure your challenge. See "
                     "challenge_config.template.py for an example.\n\n")
    raise ex1

import messages


# A module level variable to hold the Synapse connection
syn = None

def get_args():
    """Set up CLI."""
    parser = argparse.ArgumentParser()
    # parser.add_argument("-u", "--user",
    #                     help="UserName", default=None)
    # parser.add_argument("-p", "--password",
    #                     help="Password", default=None)
    parser.add_argument("--notifications",
                        help="Send errors to challenge admins",
                        action="store_true", default=False)
    parser.add_argument("--send-messages",
                        help="Send results to participants",
                        action="store_true", default=False)
    parser.add_argument("--acknowledge-receipt",
                        help="Send validation confirmation to participants",
                        action="store_true", default=False)
    parser.add_argument("--dry-run",
                        help="Perform command without storing to Synapse",
                        action="store_true", default=False)
    parser.add_argument("--debug",
                        help="Show verbose error output",
                        action="store_true", default=False)

    subparsers = parser.add_subparsers(title="subcommand")

    # Validate sub-command
    # parser_validate = subparsers.add_parser("validate",
    #                                         help="Validate RECEIVED submissions to an evaluation")
    # parser_validate.add_argument("evaluation", metavar="EVALUATION-ID",
    #                              nargs="?", default=None)
    # parser_validate.add_argument("--all",
    #                              action="store_true", default=False)
    # parser_validate.add_argument("--canCancel",
    #                              action="store_true", default=False)
    # parser_validate.set_defaults(func=command_validate)

    # Score sub-command
    parser_score = subparsers.add_parser("score",
                                         help="Score RECEIVED submissions")
    parser_score.add_argument("evaluation", metavar="EVALUATION-ID",
                              nargs="?", default=None)
    parser_score.add_argument("--all",
                              action="store_true", default=False)
    parser_score.add_argument("--canCancel",
                              action="store_true", default=False)
    parser_score.set_defaults(func=command_score)

    return parser.parse_args()

def get_user_name(profile):
    """Return full name as saved on Synapse profile."""
    names = []
    if "firstName" in profile and profile["firstName"].strip():
        names.append(profile["firstName"])
    if "lastName" in profile and profile["lastName"].strip():
        names.append(profile["lastName"])
    if len(names)==0:
        names.append(profile["userName"])
    return " ".join(names)


# def validate(evaluation, can_cancel, dry_run=False):
#     """Validate submission."""
#     if not isinstance(evaluation, Evaluation):
#         evaluation = syn.getEvaluation(evaluation)

#     print(f"\n\nValidating: {evaluation.id} - {evaluation.name}")
#     print("-" * 60)
#     sys.stdout.flush()

#     for submission, status in syn.getSubmissionBundles(evaluation, status="RECEIVED"):

#         ## refetch the submission so that we get the file path
#         ## to be later replaced by a "downloadFiles" flag on getSubmissionBundles
#         submission = syn.getSubmission(submission)
#         ex1 = None #Must define ex1 in case there is no error
#         print("validating", submission.id, submission.name)
#         try:
#             is_valid, validation_message = conf.validate_submission(evaluation, submission)
#         except Exception as ex1:
#             is_valid = False
#             print("Exception during validation:", type(ex1), ex1, ex1.message)
#             traceback.print_exc()
#             validation_message = str(ex1)

#         status.status = "VALIDATED" if is_valid else "INVALID"
#         if can_cancel:
#             status.canCancel = True
#         if not is_valid:
#             failure_reason = {"FAILURE_REASON":validation_message}
#         else:
#             failure_reason = {"FAILURE_REASON":""}
#         status.status = annots.annotate_submission(
#                 syn,
#                 submission.id,
#                 failure_reason or {},
#                 status=status.status if not dry_run else None
#             ).status

#         if not dry_run:
#             status = syn.store(status)
#         ## send message AFTER storing status to ensure we don"t get repeat messages
#         profile = syn.getUserProfile(submission.userId)
#         if is_valid:
#             messages.validation_passed(
#                 userIds=[submission.userId],
#                 username=get_user_name(profile),
#                 queue_name=evaluation.name,
#                 submission_id=submission.id,
#                 submission_name=submission.name)
#         else:
#             if isinstance(ex1, AssertionError):
#                 sendTo = [submission.userId]
#                 username = get_user_name(profile)
#             else:
#                 sendTo = conf.ADMIN_USER_IDS
#                 username = "Challenge Administrator"
#             messages.validation_failed(
#                 userIds= sendTo,
#                 username=username,
#                 queue_name=evaluation.name,
#                 submission_id=submission.id,
#                 submission_name=submission.name,
#                 message=validation_message)


def score(evaluation, dry_run=False):
    """Score submission."""
    if not isinstance(evaluation, Evaluation):
        evaluation = syn.getEvaluation(evaluation)

    print(f"\n\nScoring: {evaluation.id} - {evaluation.name}")
    print("-" * 60)
    sys.stdout.flush()

    for submission, status in syn.getSubmissionBundles(evaluation, status="RECEIVED"):
        status.status = "INVALID"

        ## refetch the submission so that we get the file path
        ## to be later replaced by a "downloadFiles" flag on getSubmissionBundles
        submission = syn.getSubmission(submission)

        try:
            score, message = conf.score_submission(evaluation, submission)
            print("scored:", submission.id, submission.name,
                  submission.userId, score)

            ## fill in team in submission status annotations
            if "teamId" in submission:
                team = syn.restGET(f"/team/{submission.teamId}")
                if "name" in team:
                    score["team"] = team["name"]
                else:
                    score["team"] = submission.teamId
            elif "userId" in submission:
                profile = syn.getUserProfile(submission.userId)
                score["team"] = get_user_name(profile)
            else:
                score["team"] = "?"
            score["comment"] = "\n".join([
                f"{k}: {v}" 
                for k, v 
                in score.items() 
                if k not in ["module", "userName", "team"]
            ])
            status.status = annots.annotate_submission(
                syn,
                submission.id,
                score,
                status="SCORED" if not dry_run else None
            ).status

        except Exception:
            sys.stderr.write(f"\n\nError scoring submission {submission.name} "
                             f"({submission.id}):\n")
            st = StringIO()
            traceback.print_exc(file=st)
            sys.stderr.write(st.getvalue())
            sys.stderr.write("\n")
            message = st.getvalue()
            status.status = annots.annotate_submission(
                syn,
                submission.id,
                {},
                status="INVALID"
            ).status

            if conf.ADMIN_USER_IDS:
                submission_info = (
                    f"submission id: {submission.id}\n"
                    f"submission name: {submission.name}\n"
                    f"submitted by user id: {submission.userId}\n\n"
                )
                messages.error_notification(
                    userIds=conf.ADMIN_USER_IDS,
                    message=submission_info + st.getvalue(),
                    queue_name=evaluation.name
                )

        ## send message AFTER storing status to ensure we don"t repeat messages
        profile = syn.getUserProfile(submission.userId)

        if status.status == "SCORED":
            messages.scoring_succeeded(
                userIds=[submission.userId],
                message=message,
                username=get_user_name(profile),
                queue_name=evaluation.name,
                submission_name=submission.name,
                submission_id=submission.id)
        else:
            messages.scoring_error(
                userIds=[submission.userId],
                message=message,
                username=get_user_name(profile),
                queue_name=evaluation.name,
                submission_name=submission.name,
                submission_id=submission.id)
    sys.stdout.write("\n")


## ==================================================
##  Handlers for commands
## ==================================================
# def command_validate(args):
#     """Validate sub-command."""
#     if args.all:
#         for queue_info in conf.evaluation_queues:
#             validate(queue_info["id"], args.canCancel, dry_run=args.dry_run)
#     elif args.evaluation:
#         validate(args.evaluation, args.canCancel, dry_run=args.dry_run)
#     else:
#         sys.stderr.write(
#             "\nValidate command requires either an evaluation ID"
#             " or --all to validate all queues in the challenge")


def command_score(args):
    """Score sub-command."""
    if args.all:
        for queue_info in conf.evaluation_queues:
            score(queue_info["id"], dry_run=args.dry_run)
    elif args.evaluation:
        score(args.evaluation, dry_run=args.dry_run)
    else:
        sys.stderr.write("\nScore command requires either an evaluation ID"
                         " or --all to score all queues in the challenge")


## ==================================================
##  main method
## ==================================================
def main():
    """Main function."""
    if conf.CHALLENGE_SYN_ID == "":
        sys.stderr.write("Please configure your challenge. See "
                         "sample_challenge.py for an example.")
    global syn

    args = get_args()
    print("\n" * 2, "=" * 75)
    print(datetime.utcnow().isoformat())

    ## Acquire lock, don"t run two scoring scripts at once
    try:
        update_lock = lock.acquire_lock_or_fail(
            "challenge",
            max_age=timedelta(hours=4)
        )
    except lock.LockedException:
        print("Is the scoring script already running? Can't acquire lock.")
        # can"t acquire lock, so return error code 75 which is a
        # temporary error according to /usr/include/sysexits.h
        return 75

    try:
        syn = synapseclient.Synapse(debug=args.debug)
        # if not args.user:
        #     args.user = os.environ.get("SYNAPSE_USER", None)
        # if not args.password:
        #     args.password = os.environ.get("SYNAPSE_PASSWORD", None)
        # syn.login(email=args.user, password=args.password)
        syn.login(silent=True)

        ## initialize messages
        messages.syn = syn
        messages.dry_run = args.dry_run
        messages.send_messages = args.send_messages
        messages.send_notifications = args.notifications
        messages.acknowledge_receipt = args.acknowledge_receipt

        args.func(args)

    except Exception:
        sys.stderr.write("Error in evaluation script:\n")
        st = StringIO()
        traceback.print_exc(file=st)
        sys.stderr.write(st.getvalue())
        sys.stderr.write("\n")

        if conf.ADMIN_USER_IDS:
            messages.error_notification(
                userIds=conf.ADMIN_USER_IDS, 
                message=st.getvalue(), 
                queue_name=conf.CHALLENGE_NAME
            )

    finally:
        update_lock.release()

    print("\ndone: ", datetime.utcnow().isoformat())
    print("=" * 75, "\n" * 2)


if __name__ == "__main__":
    main()
