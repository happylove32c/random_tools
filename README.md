# random_tools

A small collection of practical Windows batch utilities for everyday development and media workflows.

These tools are intentionally simple: **drop the `.bat` file where you need it, double-click it, and let the script handle the repetitive work.**

---

## Tools

### `zipcat.bat`

`zipcat.bat` is a utility for preparing a project/codebase as context for AI coding assistants.

It is particularly useful when working with models or platforms that don't allow you to directly upload an entire project ZIP. Instead of manually copying files one by one, the script packages the relevant project contents into a single text file that can be provided as context to models such as Claude, DeepSeek, and other AI assistants.

### What it does

The script follows this general workflow:

1. **Provide a folder path**

   Paste the path of the project or folder you want to process.

2. **Create a temporary ZIP**

   The script creates a ZIP archive of the selected folder.

   Common generated/dependency directories that are not useful as AI context are excluded:

   * `node_modules`
   * `.git`
   * `.next`
   * `dist`
   * `build`

   This keeps the temporary archive smaller and prevents large dependency/build directories from being unnecessarily processed.

3. **Concatenate the project files**

   The script then reads the relevant files in the project and combines their contents into a single text output.

   This makes it possible to provide an AI model with the structure and source code of a project as one piece of context rather than having to upload or paste hundreds of individual files.

4. **Choose an output location**

   The script asks where the generated text file should be saved.

5. **Save the result**

   The final file is saved using the project's folder name:

   ```text
   foldername_cat.txt
   ```

### Why use it?

This is useful when you want to give an AI model a relatively complete picture of a codebase without uploading the original project itself.

For example:

```text
my-project/
├── app/
├── components/
├── public/
├── package.json
├── next.config.js
└── ...
```

can be turned into something like:

```text
my-project_cat.txt
```

which can then be supplied as context to an AI coding assistant.

### Temporary ZIP

The ZIP created during the process is treated as a **temporary working file**.

You don't need to keep the ZIP after the script finishes. The purpose of the ZIP is to assist the processing workflow; the useful final output is the generated `_cat.txt` file.

### Current status

> **Stable for now**

The cat/concatenation process previously had a bug involving the loop used to process the files. That issue has been fixed, and the current version has been tested enough to be considered stable for the time being.

Further improvements may be made later if additional edge cases are discovered.

---

## `convert.bat`

`convert.bat` is a simple batch audio-conversion utility.

Its purpose is to make it easy to convert multiple `.aac` audio files into `.wav` files without having to convert each file individually.

### How to use it

1. Copy `convert.bat` into the folder containing your `.aac` files.

2. Make sure the `.aac` files you want to convert are in that same folder.

3. Double-click `convert.bat`.

4. The script processes the `.aac` files in the folder and converts them to `.wav`.

For example:

```text
audio/
├── convert.bat
├── recording_01.aac
├── recording_02.aac
├── recording_03.aac
└── recording_04.aac
```

After running the script, the folder will contain the converted WAV files alongside the original AAC files.

### Intended use

The script is designed for quick, repetitive conversions where manually opening an audio application for every file would be unnecessary overhead.

Instead:

**Copy → Double-click → Convert.**

---

## Notes

These scripts are intentionally lightweight and are intended to solve specific repetitive tasks rather than function as a full-featured application.

The goal of `random_tools` is simple:

> **Small scripts for annoying little jobs.**

More utilities can be added to this collection over time as new repetitive tasks come up.
