# random_tools

A small collection of simple Windows `.bat` utilities for repetitive tasks.

---

## `zipcat.bat`

Turns a project folder into a single `.txt` file that can be used as context for AI coding assistants like Claude, DeepSeek, and others that don't support codebase ZIP uploads.

### How it works

1. Paste the folder path.
2. The script temporarily zips the folder.
3. Excludes:

   * `node_modules`
   * `.git`
   * `.next`
   * `dist`
   * `build`
4. Cats the remaining files into one text file.
5. Choose where to save it.
6. Saves as:

```text
foldername_cat.txt
```

The ZIP is only used temporarily, so there's no need to keep it afterward.

> **Status:** Stable for now. A bug in the file-processing loop was fixed in the current version.

---

## `convert.bat`

Converts `.aac` files to `.wav` in bulk.

### How to use

1. Put `convert.bat` in the same folder as your `.aac` files.
2. Double-click it.
3. Every `.aac` file in that folder is converted to `.wav`.

That's it.

---

**Small tools. Less repetitive work.**
