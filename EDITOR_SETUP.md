# Editor Setup for OmniFocus Plugins

This guide covers setting up your editor to properly handle `.omnifocusjs` files with JavaScript syntax highlighting.

## Neovim

Your Neovim configuration has been updated to treat `.omnifocusjs` files as JavaScript.

### What Was Changed

File: `~/.config/nvim/lua/options.lua`

Added:
```lua
-- Treat .omnifocusjs files as JavaScript
vim.filetype.add({
  extension = {
    omnifocusjs = "javascript",
  },
})
```

### How to Use

1. **Open any `.omnifocusjs` file in Neovim**:
   ```bash
   nvim AI-Task-Clarifier.omnifocusjs
   ```

2. **Syntax highlighting will automatically work** - no need to set filetype manually

3. **All JavaScript features will work**:
   - Syntax highlighting
   - LSP (if you have a JavaScript language server configured)
   - Treesitter (if configured)
   - Indentation
   - Code folding
   - Auto-completion

### Verify It's Working

Open a plugin file and check the filetype:
```vim
:set filetype?
```

Should show: `filetype=javascript`

### Reload Configuration

If Neovim is already running, reload the configuration:
```vim
:source ~/.config/nvim/lua/options.lua
```

Or restart Neovim.

## VS Code

To add JavaScript syntax highlighting for `.omnifocusjs` files in VS Code:

### Method 1: User Settings (Recommended)

1. Open VS Code Settings (Cmd+, on Mac, Ctrl+, on Windows/Linux)
2. Click the "Open Settings (JSON)" icon in the top-right
3. Add this to your `settings.json`:

```json
{
  "files.associations": {
    "*.omnifocusjs": "javascript"
  }
}
```

### Method 2: Workspace Settings

If you only want this for the current workspace:

1. Create `.vscode/settings.json` in your project root
2. Add:

```json
{
  "files.associations": {
    "*.omnifocusjs": "javascript"
  }
}
```

### Verify It's Working

1. Open any `.omnifocusjs` file
2. Look at the bottom-right corner of VS Code
3. Should show "JavaScript" as the language

## Sublime Text

Add to your user settings (`Preferences > Settings`):

```json
{
  "file_extensions": {
    "omnifocusjs": "JavaScript"
  }
}
```

Or create a syntax-specific settings file:
1. Open any `.omnifocusjs` file
2. Go to `View > Syntax > Open all with current extension as... > JavaScript`

## Vim (Classic)

Add to your `~/.vimrc`:

```vim
" Treat .omnifocusjs files as JavaScript
au BufRead,BufNewFile *.omnifocusjs set filetype=javascript
```

## Emacs

Add to your `~/.emacs` or `~/.emacs.d/init.el`:

```elisp
;; Treat .omnifocusjs files as JavaScript
(add-to-list 'auto-mode-alist '("\\.omnifocusjs\\'" . js-mode))
```

## IntelliJ IDEA / WebStorm

1. Go to `Settings/Preferences > Editor > File Types`
2. Find "JavaScript" in the list
3. Click the `+` button under "File name patterns"
4. Add: `*.omnifocusjs`
5. Click OK

## Atom

Add to your `config.cson`:

```cson
"*":
  core:
    customFileTypes:
      "source.js": [
        "omnifocusjs"
      ]
```

## TextMate

Create a file at:
`~/Library/Application Support/TextMate/Bundles/JavaScript.tmbundle/Syntaxes/JavaScript.tmLanguage`

Add `.omnifocusjs` to the file patterns.

Or use the GUI:
1. Bundles > Edit Bundles
2. Select JavaScript
3. Add `*.omnifocusjs` to file types

## BBEdit

1. Open BBEdit Preferences
2. Go to Languages
3. Select JavaScript
4. Add `.omnifocusjs` to the file extensions list

## Zed

Add to your settings:

```json
{
  "file_types": {
    "JavaScript": ["omnifocusjs"]
  }
}
```

## GitHub / GitLab

To get syntax highlighting on GitHub/GitLab, add a `.gitattributes` file to your repository:

```
*.omnifocusjs linguist-language=JavaScript
```

This has been added to the repository for you.

## LSP Configuration

If you're using a Language Server Protocol (LSP) setup, you may need to configure it to recognize `.omnifocusjs` files.

### For Neovim with nvim-lspconfig

If you have `tsserver` or another JavaScript LSP configured, it should automatically work with the filetype association.

If not, you can explicitly add it:

```lua
require('lspconfig').tsserver.setup({
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  -- Add this if needed:
  on_attach = function(client, bufnr)
    -- Your on_attach config
  end,
})
```

### For VS Code

VS Code's JavaScript language server should automatically work once you've set the file association.

## Prettier / ESLint

If you use Prettier or ESLint, you may want to configure them to format `.omnifocusjs` files.

### Prettier

Add to `.prettierrc` or `package.json`:

```json
{
  "overrides": [
    {
      "files": "*.omnifocusjs",
      "options": {
        "parser": "babel"
      }
    }
  ]
}
```

### ESLint

Add to `.eslintrc.js`:

```javascript
module.exports = {
  overrides: [
    {
      files: ['*.omnifocusjs'],
      parser: '@babel/eslint-parser',
      // Your JavaScript rules
    }
  ]
}
```

## EditorConfig

Add to `.editorconfig`:

```ini
[*.omnifocusjs]
indent_style = space
indent_size = 4
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true
```

## Tips

### Syntax Checking

Most editors will now provide:
- ✅ Syntax highlighting
- ✅ Error detection
- ✅ Auto-completion
- ✅ Code navigation (go to definition, etc.)
- ✅ Refactoring tools

### Code Snippets

You can create custom snippets for OmniFocus plugin development.

**Example Neovim snippet** (using LuaSnip):

```lua
s("ofplugin", {
  t({
    '/*{',
    '    "type": "action",',
    '    "targets": ["omnifocus"],',
    '    "author": "Your Name",',
    '    "identifier": "com.omnifocus.',
  }),
  i(1, "plugin-name"),
  t({
    '",',
    '    "version": "1.0",',
    '    "description": "',
  }),
  i(2, "Description"),
  t({
    '",',
    '    "label": "',
  }),
  i(3, "Label"),
  t({
    '",',
    '    "shortLabel": "',
  }),
  i(4, "Short"),
  t({
    '",',
    '    "paletteLabel": "',
  }),
  i(5, "Palette Label"),
  t({
    '",',
    '    "image": "gear"',
    '}*/',
    '(() => {',
    '    const action = new PlugIn.Action(async function(selection, sender) {',
    '        try {',
    '            ',
  }),
  i(0),
  t({
    '',
    '        } catch (error) {',
    '            new Alert("Error", error.message).show();',
    '            console.error("Error:", error);',
    '        }',
    '    });',
    '    ',
    '    action.validate = function(selection, sender) {',
    '        return true;',
    '    };',
    '    ',
    '    return action;',
    '})();',
  }),
})
```

### Linting

Consider adding a `.eslintrc.js` to your project:

```javascript
module.exports = {
  env: {
    es2021: true,
  },
  extends: 'eslint:recommended',
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
  },
  globals: {
    // OmniFocus globals
    PlugIn: 'readonly',
    Alert: 'readonly',
    Form: 'readonly',
    Credentials: 'readonly',
    URL: 'readonly',
    Data: 'readonly',
    database: 'readonly',
    library: 'readonly',
    inbox: 'readonly',
    tags: 'readonly',
    flattenedTasks: 'readonly',
    Task: 'readonly',
    Project: 'readonly',
    Folder: 'readonly',
    Tag: 'readonly',
    console: 'readonly',
  },
  rules: {
    // Your rules
  },
};
```

## Troubleshooting

### Syntax highlighting not working

1. **Check filetype**: In your editor, verify the file is recognized as JavaScript
2. **Reload configuration**: Restart your editor or reload the config
3. **Check for conflicts**: Make sure no other plugin is overriding the filetype

### LSP not working

1. **Verify LSP is installed**: Check your JavaScript language server is installed
2. **Check LSP logs**: Look for errors in your editor's LSP logs
3. **Restart LSP**: Try restarting the language server

### Auto-completion not working

1. **Verify filetype**: Make sure file is recognized as JavaScript
2. **Check LSP**: Ensure language server is running
3. **Add globals**: You may need to add OmniFocus globals to your LSP config

## Summary

Your Neovim is now configured to treat `.omnifocusjs` files as JavaScript, giving you:
- ✅ Full syntax highlighting
- ✅ LSP support (if configured)
- ✅ All JavaScript editor features
- ✅ Automatic detection (no manual filetype setting needed)

For other editors, follow the instructions above to get the same functionality.

Happy coding! 🚀

