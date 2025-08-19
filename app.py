#!/usr/bin/env python3
import aws_cdk as cdknfrom lib.config import AWS_ACCOUNTS

from lib.stages import NewProjectStage


app = cdk.App()

# Local stage removed - focusing on Dev environment deployment

# Dev stage
NewProjectStage(
    app,
    "Dev",
    environment_name="dev",
    env=cdk.Environment(account=AWS_ACCOUNTS["dev"], region="us-east-1"),
)

# Staging stage - same account as dev but with staging environment names
NewProjectStage(
    app,
    "Staging",
    environment_name="staging",
    env=cdk.Environment(account=AWS_ACCOUNTS["staging"], region="us-east-1"),
)

# Prod stage (account to be provided later)
# NewProjectStage(
#     app,
#     "Prod",
#     environment_name="prod",
#     env=cdk.Environment(account="", region="us-east-1"),
# )

app.synth()