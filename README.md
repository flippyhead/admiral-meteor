# Admiral for Meteor

An Admiral module for building and deploying Meteor applications to AWS OpsWorks EC2 instances.

For additional modules, see the [Admiral base prjoect](https://github.com/flippyhead/admiral).

Developed in Seattle at [Fetching](http://fetching.io).

## Installation

Add this line to your application's Gemfile (recommended):

    gem 'admiral-meteor'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install admiral-meteor

## Usage

On your command line type:

    $ admiral meteor help

To see a list of available commands. Make sure your bundle bin is in your PATH.

The following commands are available:

```
Commands:
  admiral meteor build           # Build the Meteor app specifically for opsworks
  admiral meteor help [COMMAND]  # Describe subcommands or one specific subcommand
  admiral meteor push            # Push a build to S3

Options:
  [--name=NAME]                  # Name of build file. Set in env with ADMIRAL_DEPLOY_NAME
                                 # Default: fetching-app
  [--branch=BRANCH]              # The branch to build
                                 # Default: master
  [--tag=TAG]                    # Create a tag for this commit. e.g. v1.0.1
  [--repo=REPO]                  # The git repo with your app source code. Defaults to the current working directory.
  [--architecture=ARCHITECTURE]  # The architecture to target for this build.
                                 # Default: os.linux.x86_64
```
