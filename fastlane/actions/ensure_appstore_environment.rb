module Fastlane
  module Actions
    module SharedValues
    end

    class EnsureAppstoreEnvironmentAction < Action
      def self.run(params)
        unless ENV["MATCH_TYPE"].to_s.eql? "appstore"
          UI.user_error!([
            "The environment you chose does not use App Store values.",
            "Choose the environment by appending \"--env YOUR_ENVIRONMENT\" to your fastlane command."
          ].join("\n"))
        end
        UI.success("Using App Store environment.")
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Checks whether the environment is suitable for App Store uploads. (That is, `match` provisiong method is set to appstore). If not, halts the script with a user error."
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
