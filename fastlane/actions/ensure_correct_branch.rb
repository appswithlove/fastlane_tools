module Fastlane
  module Actions
    module SharedValues
    end

    class EnsureCorrectBranchAction < Action
      def self.run(params)
        branch = Actions.git_branch.to_s
        commit = Actions.last_git_commit_message.to_s

        unless UI.confirm("You are currently on branch " + branch + "\nThe last commit message was \"" + commit + "\"\n Is this ok?")
            Fastlane::Actions::EnsureGitStatusCleanAction.run(show_uncommitted_changes: false)

            UI.important("Ok. Here is a list of branches.")
            FastlaneCore::CommandExecutor.execute(
              command: "git branch --list",
              print_all: true
              )
            desired_branch = UI.input("Please enter the name of the branch you want to switch to, or press Ctrl+C to abort.")

            UI.important("Switching Branch... Please run the script again to continue.")

            FastlaneCore::CommandExecutor.execute(
              command: "git checkout " + desired_branch,
              print_all: true
              )
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Asks you to confirm that you are on the correct branch and up-to-date."
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
