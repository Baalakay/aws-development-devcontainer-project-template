#!/usr/bin/env python3
import aws_cdk as cdk

from lib.stages import LossRegisterStage


app = cdk.App()

# Local stage removed - focusing on Dev environment deployment

# Dev stage
LossRegisterStage(
    app,
    "Dev",
    environment_name="dev",
    env=cdk.Environment(account="750389970429", region="us-east-1"),
)

# Staging stage - same account as dev but with staging environment names
LossRegisterStage(
    app,
    "Staging",
    environment_name="staging",
    env=cdk.Environment(account="750389970429", region="us-east-1"),
)

# Prod stage (account to be provided later)
# LossRegisterStage(
#     app,
#     "Prod",
#     environment_name="prod",
#     env=cdk.Environment(account="", region="us-east-1"),
# )

app.synth()