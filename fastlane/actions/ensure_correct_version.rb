module Fastlane
  module Actions
    module SharedValues
    end

    class EnsureCorrectVersionAction < Action
      def self.run(params)
        # Get the current version number
        version_number = Fastlane::Actions::GetVersionNumberAction.run(params: params).to_s
        
        unless UI.confirm("Is version " + version_number + " correct?")
          version_number = UI.input("Enter correct version number (currently " + version_number + ")")
          Fastlane::Actions::IncrementVersionNumberAction.run(version_number: version_number)
          UI.success("Changed version number to #{version_number}")
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Ensure the version number is correct, otherwise prompt the user and change it"
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
