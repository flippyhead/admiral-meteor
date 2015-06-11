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

```sh
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
## Environment Variables

Admiral will look for certain configuration options in your environment variables. The following variables must be set to configure S3 deployments:

```sh
ADMIRAL_DEPLOY_BUCKET=your-app-builds   # an existing S3 bucket in which to store builds
ADMIRAL_DEPLOY_NAME=your-app            # the name of your app builds
```

And just like the AWS client, your access keys and other settings must also be set:


```sh
AWS_ACCESS_KEY_ID=ABC123ABC123ABC123
AWS_SECRET_ACCESS_KEY=abc123xyz456abc123xyz456abc123xyz456
AWS_REGION=us-west-2
```

A convenient approach for isolating configuration on a per project basis is to use [rbenv](http://rbenv.org) and store these in a `.rbenv-vars` file in your project root.

## Deploying Builds

One of the easier ways to deploy to OpsWorks is by uploading archives to S3. Admiral takes this approach when you use the `push` command. Once a new build has been pushed, you can use the [Admiral for OpsWorks](https://github.com/flippyhead/admiral-cloudformation) command `deploy` to tell OpsWorks to extract the build, deploy it, and restart Meteor.

The best approach is to include Admiral for Meteor in the Gemfile for your actual Meteor project.
