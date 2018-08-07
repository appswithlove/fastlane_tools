# You can use this to have a one-click build process,
# for example if your PM wants to be able to build, but can't
# be bothered to use the Terminal.
# 
# Customize the lane and environment below. 
# (You can have multiple .command files for different lanes and environments.)
# 
# To make the file executable by clicking, open Terminal and use the following command:
# 
# chmod +x <path_to_this_file>

here="`dirname \"$0\"`"
echo "Changing directory to $here/fastlane"
cd "$here/fastlane"
fastlane your_lane --env your_environment