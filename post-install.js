// post-install.js

/**
 * Script to run after npm install
 *
 * Copy selected files to user's directory
 */

'use strict'
const gentlyCopy = require('gently-copy');
const fs = require('fs');

const filesToCopy = ['src/hooks/prepare-commit-msg.sh'];
//  local directory
const copyPath = '.git/hooks/prepare-commit-msg';
// Moving files to user's local directory
gentlyCopy(filesToCopy, copyPath, {overwrite: false})


function addCustomScript(script, command) {
    const packageJsonPath = './package.json';
    fs.readFile(packageJsonPath, 'utf8', (err, data) => {
        if (err) {
            throw err;
        }

        const packageJson = JSON.parse(data);
        packageJson.scripts[scriptName] = scriptCommand;

        fs.writeFile(packageJsonPath, JSON.stringify(packageJson, null, 2), (err) => {
            if (err) {
                throw err;
            }

            console.log(`Added script '${scriptName}' with command '${scriptCommand}' to package.json`);
        });
    });
}

// add pause command
const pause_script_name = 'pause-smart-commit';
const pause_script_command = 'mv .git/hooks/pre-commit-msg .git/hooks/pre-commit-msg.sample';
addCustomScript(pause_script_name, pause_script_command);

// add restart command
const restart_script_name = 'restart-smart-commit';
const restart_script_command = 'mv .git/hooks/pre-commit-msg.sample .git/hooks/pre-commit-msg';
addCustomScript(restart_script_name, restart_script_command);

// add uninstall command
const uninstall_script_name = 'uninstall-smart-commit';
const uninstall_script_command = 'rm .git/hooks/pre-commit-msg';
addCustomScript(uninstall_script_name, uninstall_script_command);
