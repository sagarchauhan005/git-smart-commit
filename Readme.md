# Git Smart Commit

This tool generates smart TODO comments for Git changes to nudge users to document them before commit.

# Installation

- Run `npm install git-smart-commit` into your app and then follow the steps.

# Working

Click below to watch the video

[![Git Smart Commit](https://img.youtube.com/vi/DFulKPJfwtk/0.jpg)](https://www.youtube.com/watch?v=DFulKPJfwtk)

- Make changes to your code
- Do `git add .`
- Do `git commit -m "your message"`
- The script will catch your message, run its own inspection to ask you to document the changes you have made.
- It won't commit your changes until all the changes have been documented in this git commit.
- If all goes well, script checks your message format and proceed to commit.

![Imgur](https://i.imgur.com/aywkurY.png)

- This is how the script appends the smart comment at the line where changes were made.
- All you have to do is replace `TODO` with `FIX|DEBUG|INFO` and enter your message to match the allowed format.

![Imgur](https://i.imgur.com/ZCQdoTK.png)

# Dependency

Make sure that your system has all these installed pre-hand.

1. Git
2. Sed
3. Node

# Post Installation Steps

1. Make any small change in any of your file
2. ```git add .```
3. ```git commit -m "your message"```
4. Notice the changes you have made in your files and document them
5. That's it! Push the changes to your branch.

# Author

[Sagar Chauhan](https://twitter.com/sagarchauhan005) works as a Senior Product Manager - Technology at [Greenhonchos](https://www.greenhonchos.com).
In his spare time, he hunts bug as a Bug Bounty Hunter.
Follow him at [Instagram](https://www.instagram.com/sagarchauhan005/), [Twitter](https://twitter.com/sagarchauhan005),  [Facebook](https://facebook.com/sagar.chauhan3),
[Github](https://github.com/sagarchauhan005)

# License
MIT
