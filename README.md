README: GitHub Update Script

This script is used to update all repositories within one or more master GitHub folders. It does this by using the Git command "git pull" to update each repository.

Using the script is easy. When you run it, it will prompt you to enter the number of master GitHub folders you want to update, and the location of each folder. You can also update the configuration file by running the script with the command line argument "-c" or "-config". When the script runs, it will loop through all directories under the specified master GitHub folders, and update each repository by running "git pull".

When the script is finished, a message box will appear to let you know that all repositories have been updated. You can find a log of the script's actions in the file "log.txt".

