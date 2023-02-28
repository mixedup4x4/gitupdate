import os
import sys
import subprocess
import logging
import datetime

# Set up log file
logging.basicConfig(filename='log.txt', level=logging.INFO)
logging.info('Script launched on %s', str(datetime.datetime.now()))

# Read configuration information from config file
if os.path.exists('config.txt'):
    with open('config.txt', 'r') as f:
        numFolders = int(f.readline().strip())
        folderLocations = [f.readline().strip() for i in range(numFolders)]
else:
    # If config file does not exist, prompt user for input and save to file
    numFolders = int(
        input('How many master GitHub folders do you want to update? '))
    folderLocations = [input(
        f'Enter the location of master GitHub folder #{i+1}: ') for i in range(numFolders)]
    with open('config.txt', 'w') as f:
        f.write(str(numFolders) + '\n')
        for folderLocation in folderLocations:
            f.write(folderLocation + '\n')

# Check for command line argument to update config file
if '-c' in sys.argv or '--config' in sys.argv:
    numFolders = int(
        input('How many master GitHub folders do you want to update? '))
    folderLocations = [input(
        f'Enter the location of master GitHub folder #{i+1}: ') for i in range(numFolders)]
    with open('config.txt', 'w') as f:
        f.write(str(numFolders) + '\n')
        for folderLocation in folderLocations:
            f.write(folderLocation + '\n')

# Loop through all directories under the specified master GitHub folders
for folderLocation in folderLocations:
    for subFolder in os.listdir(folderLocation):
        subFolder = os.path.join(folderLocation, subFolder)
        if os.path.isdir(subFolder):
            # Change current directory to the subfolder
            os.chdir(subFolder)

            # Run "git pull" and record output to log file
            output = subprocess.run(
                ['git', 'pull'], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True).stdout
            logging.info('%s - Updated repository %s',
                         str(datetime.datetime.now()), subFolder)

# Notify user that the script has completed
print('All repositories have been updated.')
