require 'aws-sdk-v1'
require 'thor'
require 'git'
require 'json'

module Admiral
  module Tasks
    class Deploy < Thor

      NAME = 'meteor'
      USAGE = 'meteor <command> <options>'
      DESCRIPTION = 'Commands for building meteor apps.'

      namespace :meteor

      class_option :name,
        desc: 'Name of build file. Set in env with ADMIRAL_DEPLOY_NAME',
        type: :string,
        default: ENV['ADMIRAL_DEPLOY_NAME'] || 'build'

      class_option :branch,
        desc: 'The branch to build',
        type: :string,
        default: 'master'

      class_option :tag,
        desc: 'Create a tag for this commit. e.g. v1.0.1',
        type: :string

      class_option :repo,
        desc: "The git repo with your app source code. Defaults to the current working directory.",
        type: :string

      class_option :architecture,
        desc: 'The architecture to target for this build.',
        default: 'os.linux.x86_64'

      desc 'build', 'Build the Meteor app specifically for opsworks'

      def build
        Dir.mktmpdir do |tmpdir|
          build_dir = "#{tmpdir}/admiral-build"
          repo = options[:repo] || Dir.pwd

          if options[:tag]
            git = Git.open(repo)
            puts "[admiral] Tagging release #{options[:tag]}."
            git.add_tag(options[:tag], m: 'tagging release')
          end

          puts "[admiral] Creating new meteor build."
          _git = Git.clone(repo, "#{tmpdir}/admiral-checkout")
          branch = _git.branches[options[:branch]]
          raise "Branch doesn't exist" unless branch
          branch.checkout

          _git.chdir do
            `meteor build #{build_dir} --directory --architecture=#{options[:architecture]}`
          end

          `cp -a ./deploy #{build_dir}/bundle`
          `mv #{build_dir}/bundle/main.js #{build_dir}/bundle/server.js`
          `tar -C #{build_dir}/bundle/ -zcf ./#{options[:name]}.tar.gz .`
        end
      end


      desc "push", "Build then push a build to S3"

      option :bucket,
        desc: 'S3 bucket name to hold builds. Set in env with ADMIRAL_DEPLOY_BUCKET.',
        type: :string,
        default: ENV['ADMIRAL_DEPLOY_BUCKET'] || 'builds'

      def push
        invoke :build

        puts "[admiral] Pushing meteor build to S3."
        s3 = AWS::S3.new
        name = "#{options[:name]}.tar.gz"
        build = s3.buckets[options[:bucket]].objects[name]
        build.write(:file => "./#{name}")
      end

    end
  end
end