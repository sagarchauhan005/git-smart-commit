// post-install.js

/**
 * Script to run after npm install
 *
 * Copy selected files to user's directory and perform action
 */

'use strict'
const gentlyCopy = require('gently-copy');
const fs = require('fs');

const filesToCopy = ['src/hooks/prepare-commit-msg.sh'];
//  local directory
const copyPath = '../../.git/hooks/prepare-commit-msg';
// Moving files to user's local directory
gentlyCopy(filesToCopy, copyPath, {overwrite: true})


async function addCustomScripts(scripts) {
    const packageJsonPath = '../../package.json';

    try {
        const packageJson = JSON.parse(fs.readFileSync(packageJsonPath));
        Object.assign(packageJson.scripts, scripts);
        fs.writeFileSync(packageJsonPath, JSON.stringify(packageJson, null, 2));
        console.log('Added custom scripts to package.json');
    } catch (err) {
        console.error('Error adding custom scripts to package.json:', err);
    }
}

// Define the scripts to add
const scripts = {
    'pause-smart-commit': 'mv .git/hooks/prepare-commit-msg .git/hooks/prepare-commit-msg.sample',
    'restart-smart-commit': 'mv .git/hooks/prepare-commit-msg.sample .git/hooks/prepare-commit-msg',
    'install-smart-commit': 'mv node_modules/git-smart-commit/src/hooks/prepare-commit-msg.sh .git/hooks/prepare-commit-msg',
    'uninstall-smart-commit': 'rm .git/hooks/prepare-commit-msg',
};

// Add the scripts to package.json
(async () => {
    await addCustomScripts(scripts);
})();
