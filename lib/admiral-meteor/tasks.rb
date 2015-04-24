require 'aws-sdk-v1'
require 'thor'
require 'git'
require 'json'

module Admiral
  module Tasks
    class Deploy < Thor

      NAME = 'deploy'
      USAGE = 'deploy <command> <options>'
      DESCRIPTION = 'Commands for deploying.'

      namespace :deploy

      default_command :deploy

      class_option :name,
        desc: 'Name of build file. Set in env with ADMIRAL_DEPLOY_NAME',
        type: :string,
        default: ENV['ADMIRAL_DEPLOY_NAME'] || 'build'

      class_option :branch,
        desc: 'The branch to build',
        type: :string,
        default: 'master'

      class_option :repo,
        desc: "The git repo with your app source code. Defaults to the current working directory.",
        type: :string

      class_option :architecture,
        desc: 'The architecture to target for this build.',
        default: 'os.linux.x86_64'

      desc 'build', 'Build the Meteor app specifically for opsworks'

      def build
        puts "Creating new build"

        Dir.mktmpdir do |tmpdir|
          build_dir = "#{tmpdir}/admiral-build"
          repo = options[:repo] || Dir.pwd

          git = Git.clone(repo, "#{tmpdir}/admiral-checkout")
          branch = git.branches[options[:branch]]
          raise "Branch doesn't exist" unless branch
          branch.checkout
          git.chdir do
            `meteor build #{build_dir} --directory --architecture=#{options[:architecture]}`
          end

          `cp -a ./deploy #{build_dir}/bundle`
          `mv #{build_dir}/bundle/main.js #{build_dir}/bundle/server.js`
          `tar -C #{build_dir}/bundle/ -zcvf ./#{options[:name]}.tar.gz .`
        end
      end


      desc "push", "Push a build to S3"

      option :bucket,
        desc: 'S3 bucket name to hold builds. Set in env with ADMIRAL_DEPLOY_BUCKET.',
        type: :string,
        default: ENV['ADMIRAL_DEPLOY_BUCKET'] || 'builds'

      def push
        invoke :build

        puts "Pushing build to S3"
        s3 = AWS::S3.new
        name = "#{options[:name]}.tar.gz"
        build = s3.buckets[options[:bucket]].objects[name]
        build.write(:file => "./#{name}")
      end

    end
  end
end