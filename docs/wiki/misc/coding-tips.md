---
title: Coding Tips
layout: default
parent: Miscellaneous
nav_order: 1
---

# Coding Tips
## Code Folding
ISSM uses code folding using `vim` markers throughout the code. Here are the steps to allow for code folding using VS Code if you don't want to use `vim`:
1. Search for and install the 'Explicit Folding' extension in the extension marketplace.
2. This is also mentioned in the description of the extension, but to summarize,
  - Go into 'Settings'
  - Search for 'showFoldingControls'
  - Set it to 'always' if it is not already
  - Then check 'foldingStrategy' that is not as defined “indentation”
3. Search for 'explicitFolding.rules' and press 'Edit in settings.json' or simply open your `settings.json` and add,
```json
"explicitFolding.rules": {
    "*": {
        "begin": "{{{",
        "end": "}}}"
    }
}
```
