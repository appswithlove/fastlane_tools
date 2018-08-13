fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

## Choose your installation method:

<table width="100%" >
<tr>
<th width="33%"><a href="http://brew.sh">Homebrew</a></td>
<th width="33%">Installer Script</td>
<th width="33%">Rubygems</td>
</tr>
<tr>
<td width="33%" align="center">macOS</td>
<td width="33%" align="center">macOS</td>
<td width="33%" align="center">macOS or Linux with Ruby 2.0.0 or above</td>
</tr>
<tr>
<td width="33%"><code>brew cask install fastlane</code></td>
<td width="33%"><a href="https://download.fastlane.tools">Download the zip file</a>. Then double click on the <code>install</code> script (or run it in a terminal window).</td>
<td width="33%"><code>sudo gem install fastlane -NV</code></td>
</tr>
</table>

## Importing Actions

Once you have set up Fastlane for your project, Import the available actions into your Fastfile by adding 
`import_from_git(url: "https://github.com/appswithlove/fastlane_tools.git", version: "~>1.0.0")`
to the top of your existing Fastfile.

# Configuration

Store all your configuration values in  `.env` files. These files can be named to suit your needs, e.g. `.env.appstore`
Then call fastlane with the env parameter, e.g. `fastlane deploy_appstore --env appstore`

# Available Actions
### ensure_appstore_environment
```
fastlane ensure_appstore_environment
```
Makes sure the current environment values match the necessary values for an App Store build
### ensure_correct_branch
```
fastlane ensure_correct_branch
```
Ensure the user is on the correct git branch, otherwise prompt to change it
### ensure_correct_version
```
fastlane ensure_correct_version
```
Ensure the version number is correct, otherwise prompt the user and change it
### updraft
```
fastlane updraft
```
Upload a release produced by Gym to Updraft for testing
### post_build_notification
```
fastlane post_build_notification
```
Send local and Slack notification for uploaded builds
### finish_release
```
fastlane finish_release
```
Prompts the user to tag and push the release accordingly

----
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).

