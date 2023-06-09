module Fastlane
  module Actions
    module SharedValues
    end

    class UpdraftAction < Action
      def self.run(config)
        begin
        UI.important("Collecting the necessary data to upload...")

        path = config[:ipa] if File.exist?(config[:ipa]) || config[:apk] if File.exist?(config[:apk])
        UI.user_error!("Please provide ipa or apk") unless path

        git_url = Helper.backticks("git remote get-url origin").to_s
        git_branch = Actions.git_branch.to_s
        git_tag = Helper.backticks("git tag -l --points-at HEAD").to_s
        git_commit_hash = Helper.backticks("git rev-parse HEAD").to_s

        whats_new = config[:changelog]

        bundle_version = Fastlane::Actions::GetIpaInfoPlistValueAction.run(ipa: config[:ipa], key: "CFBundleVersion").to_s

        build_type = other_action.is_ci? ? "CI" : "Fastlane"

        curl_command = "curl -X PUT"
        curl_command << " -F 'app=@%s'" % path
        curl_command << " -F 'custom_git_url=%s'"           % git_url
        curl_command << " -F 'custom_git_branch=%s'"        % git_branch
        curl_command << " -F 'custom_git_tag=%s'"           % git_tag
        curl_command << " -F 'custom_git_commit_hash=%s'"   % git_commit_hash
        curl_command << " -F 'whats_new=%s'"                % whats_new
        curl_command << " -F 'custom_bundle_version=%s'"    % bundle_version
        curl_command << " -F 'build_type=%s'"               % build_type
        curl_command << " " << config[:upload_url]
        curl_command << " --http1.1"

        UI.important("Uploading build to Updraft. This might take a while...")

        FastlaneCore::CommandExecutor.execute(
          command: curl_command,
          print_all: false,
          error: proc do |error_output|
            UI.crash!("Uploading to Updraft failed!")
          end
          )

        UI.success("Successfully uploaded build to Updraft!")
      end
    end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Upload a release to getupdraft.com for testing"
      end

      def self.details
        [
          "You can run this directly after Gym to upload the build that was created, or set your own .ipa path.",
          "In all cases, you will need to provide a URL for uploading to. You can get this in your Updraft Project Settings"
          ].join("\n")
        end

        def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :upload_url,
            optional: false,
            env_name: "UPDRAFT_URL",
            description: "Project Specific API Upload URL. You can get this in your Updraft Project Settings",
            sensitive: true,
            verify_block: proc do |value|
              UI.user_error!("No URL for Updraft given, pass using `upload_url: 'url'`") unless value.to_s.length > 0
            end
          ),
          FastlaneCore::ConfigItem.new(
            key: :ipa,
            optional: true,
            default_value: Actions.lane_context[SharedValues::IPA_OUTPUT_PATH],
            default_value_dynamic: true,
            conflicting_options: [:apk],
            env_name: "UPDRAFT_IPA_PATH",
            description: "Path to your ipa file",
            verify_block: proc do |value|
              UI.user_error!("Could not find ipa file at path '#{File.expand_path(value)}'") unless File.exist?(value)
              UI.user_error("'#{value}' doesn't seem to be an ipa file") unless value.end_with?(".ipa")
            end
          ),
          FastlaneCore::ConfigItem.new(
            key: :apk,
            optional: true,
            default_value: Actions.lane_context[SharedValues::APK_OUTPUT_PATH],
            default_value_dynamic: true,
            conflicting_options: [:ipa],
            env_name: "UPDRAFT_APK_PATH",
            description: "Path to your apk file",
            verify_block: proc do |value|
              UI.user_error!("Could not find apk file at path '#{File.expand_path(value)}'") unless File.exist?(value)
              UI.user_error("'#{value}' doesn't seem to be an apk file") unless value.end_with?(".apk")
            end
          ),
          FastlaneCore::ConfigItem.new(
            key: :changelog,
            optional: true,
            default_value: Helper.backticks("git log -1 --pretty=%B").to_s,
            default_value_dynamic: true,
            env_name: "CHANGE_LOG",
            description: "Write version changes",
          )
        ]
      end

      def self.example_code
        [
          'updraft(
            upload_url: "...",
            ipa: "./ipa_file.ipa",
            changelog: "...",
          )',
          'updraft(
            upload_url: "...",
            apk: "../build/app/outputs/apk/qa/release/app-qa-release.apk",
            changelog: "...",
           )'
        ]
      end

      def self.authors
        ["@astulz"]
      end

      def self.is_supported?(platform)
        [:ios, :android].include?(platform)
      end
    end
  end
end
