# Admiral for Meteor

Admiral for Meteor makes it easy to build and deploy Meteor applications.

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

To see a list of available commands, on the command line enter:

    $ admiral meteor help

Make sure your bundle bin is in your PATH.

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

## Setup

The recommended setup is to add the `admiral-meteor` gem to your Meteor project, then add the environment variable values specific to your application (see below).

## Environment Variables

Admiral will look for configuration options in your environment variables that either should not be committed to your source tree (like access credentials), are specific to development machines, or span environment configurations. The following variables must be set to configure S3 deployments:

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

A convenient approach for isolating configuration on a per project basis is to use [rbenv](http://rbenv.org) and store these in a `.rbenv-vars` file in your repository root. Another common approach is to add these values via `export` to a shell script used to start your app.

## Deploying Builds

One of the easier ways to deploy to OpsWorks is by uploading archives to S3. Admiral takes this approach when you use the `push` command. Once a new build has been pushed, you can use the [Admiral for OpsWorks](https://github.com/flippyhead/admiral-opsworks) command `deploy` to tell OpsWorks to extract the build, deploy it, and restart Meteor. So, a typical deploy would simply be:

```sh
admiral meteor push --tag v0.0.1
admiral ow deploy myapp
```

## Meteor on OpsWorks

To get NPM packages installed correctly on OpsWorks you can use [Chef deploy hooks](http://docs.aws.amazon.com/opsworks/latest/userguide/workingcookbook-extend-hooks.html) to run commands after each deploy. For most projects you can simply create a `deploy` directory in the root of your Meteor project and add a `after_deploy.rb` file with this content:

```ruby
run "cd #{release_path}/programs/server && npm i"
```

This will correctly install any needed NPM modules required by standard Meteor builds.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
