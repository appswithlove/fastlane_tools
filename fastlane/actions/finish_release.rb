module Fastlane
  module Actions
    module SharedValues
    end

    class FinishReleaseAction < Action
      def self.run(params)
        current_directory = File.expand_path(File.dirname(__FILE__))
        current_version = Fastlane::Actions::GetVersionNumberAction.run(params: params)
        UI.success("Congrats! You successfully deployed your release.")
        UI.message("To celebrate, you should tag and push the changes for this version.")
        UI.important("In order to do this, please copy the following command:")
        UI.message("cd #{current_directory} && git add -A && git commit -am 'Release #{current_version.to_s}' && git flow release finish #{current_version.to_s}")
        UI.important("Then press ⌘-T to open a new tab, paste and run the command.")
        UI.confirm("Waiting for you... Press 'y' when done.")
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Prompts the user to tag and push the release"
      end

      def self.authors
        ["@astulz"]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
