module Fastlane
  module Actions
    module SharedValues
    end

    class PostBuildNotificationAction < Action
      def self.run(params)
        app_name = ENV["APP_NAME"].nil? ? "Unknown App" : ENV["APP_NAME"]

        unless ENV["CI"]
          other_action.notification(
            subtitle: "Build finished",
            message: app_name,
            sound: "Ping",
            )
        end
        
        unless ENV["SLACK_URL"].nil?
          other_action.slack(
            message: "#{app_name} – Success! :tada:",
            success: true,
            )
        else
          UI.header("Step: Slack")
          UI.error("Tried posting a notification to Slack but SLACK_URL could not be found in environment
            or you did not specify any environment. Set an environment by adding a .env file and passing it to fastlane: \n
            fastlane your_lane --env your_environment")
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Send local and Slack notification for uploaded builds"
      end


      def self.available_options        
        [
          FastlaneCore::ConfigItem.new(key: :slack_url,
            env_name: "SLACK_URL",
            description: "Slack WebHook URL for posting message"
            )
        ]
      end

      def self.authors
        ["@astulz"]
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
