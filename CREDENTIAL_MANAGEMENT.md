# Credential Management Guide

Both OmniFocus plugins include built-in credential management, making it easy to update or change your API keys and tokens without manually editing the Keychain.

## Overview

When you run a plugin:
1. **First time**: You'll be prompted to enter credentials
2. **Subsequent runs**: You'll be asked if you want to use stored credentials or re-enter them

This makes it easy to:
- Test with different API keys
- Update expired tokens
- Switch between accounts
- Fix incorrect credentials

## AI Task Clarifier

### First Run

When you run the plugin for the first time:

1. Click Automation menu → "AI Task Clarifier"
2. You'll see a form:
   ```
   Enter your OpenAI API key
   (will be stored securely in Keychain)
   
   OpenAI API Key: [password field]
   
   [Continue]
   ```
3. Enter your API key
4. Click "Continue"
5. The key is stored securely in macOS Keychain

### Subsequent Runs

When credentials are already stored:

1. Click Automation menu → "AI Task Clarifier"
2. You'll see an alert:
   ```
   OpenAI Credentials Found
   
   Stored API key found. What would you like to do?
   
   [Use Stored Key]  [Clear & Re-enter Key]  [Cancel]
   ```

**Options:**

- **Use Stored Key**: Continue with the saved API key (normal operation)
- **Clear & Re-enter Key**: Delete stored credentials and enter new ones
- **Cancel**: Exit without running the plugin

### Updating Your API Key

To update your OpenAI API key:

1. Run the plugin
2. Click "Clear & Re-enter Key"
3. Enter your new API key
4. Click "Continue"
5. Done! New key is stored

**Use cases:**
- Your API key expired
- You want to test with a different account
- You entered the wrong key initially
- You're switching between development and production keys

## JIRA Import

### First Run

When you run the plugin for the first time:

1. Click Automation menu → "Import JIRA Issues"
2. You'll see a form:
   ```
   Enter your JIRA credentials
   (will be stored securely)
   
   JIRA Domain: your-company.atlassian.net
   JIRA Email: [text field]
   JIRA API Token: [password field]
   Project Key (optional): Leave empty to import from all projects
   
   [Continue]
   ```
3. Fill in all fields
4. Click "Continue"
5. Credentials are stored securely in macOS Keychain

### Subsequent Runs

When credentials are already stored:

1. Click Automation menu → "Import JIRA Issues"
2. You'll see an alert:
   ```
   JIRA Credentials Found
   
   Stored credentials found for:
   Domain: company.atlassian.net
   Email: user@company.com
   
   What would you like to do?
   
   [Use Stored Credentials]  [Clear & Re-enter Credentials]  [Cancel]
   ```

**Options:**

- **Use Stored Credentials**: Continue with saved credentials (normal operation)
- **Clear & Re-enter Credentials**: Delete stored credentials and enter new ones
- **Cancel**: Exit without running the plugin

### Updating Your JIRA Credentials

To update your JIRA credentials:

1. Run the plugin
2. Click "Clear & Re-enter Credentials"
3. The form will be pre-filled with your previous values (except the API token)
4. Update any fields you want to change
5. Click "Continue"
6. Done! New credentials are stored

**Use cases:**
- Your API token expired
- You want to change the project key filter
- You entered the wrong domain or email
- You're switching between JIRA instances
- You want to test with a different account

## Behind the Scenes

### What Gets Stored

**AI Task Clarifier:**
- Service: `openai`
- User: `api-key`
- Password: Your OpenAI API key

**JIRA Import:**
- Service: `jira`
  - User: Your JIRA email
  - Password: Your JIRA API token
- Service: `jira-settings`
  - User: `config`
  - Password: JSON with domain and project key

### Where It's Stored

All credentials are stored in **macOS Keychain**, which is:
- ✅ Encrypted by the operating system
- ✅ Protected by your Mac login password
- ✅ Sandboxed (only OmniFocus can access)
- ✅ Backed up with Time Machine (encrypted)
- ✅ Synced via iCloud Keychain (if enabled)

### Security

**When you clear credentials:**
- The plugin calls `credentials.remove("service-name")`
- The entry is deleted from Keychain
- No trace remains in memory or disk
- You must re-enter credentials to use the plugin again

**Credential redaction in logs:**
- API keys are never logged in full
- Only first 10 characters shown: `sk-proj-ab...`
- Tokens shown as `[REDACTED]`
- Authorization headers shown as `Bearer [REDACTED]`

## Troubleshooting

### "Credentials not found" after clearing

**This is normal!** After clearing credentials, you need to re-enter them.

1. Run the plugin again
2. Enter your credentials
3. Continue

### Credentials keep getting cleared

Check if:
- You're clicking "Clear & Re-enter" by accident
- Another process is deleting Keychain entries
- Keychain Access is having sync issues

### Can't update credentials

If the "Clear & Re-enter" option doesn't work:

**Manual method:**
1. Open Keychain Access app
2. Search for "openai" or "jira"
3. Delete the entries manually
4. Run the plugin again

### Wrong credentials stored

If you entered wrong credentials:

1. Run the plugin
2. Click "Clear & Re-enter Key/Credentials"
3. Enter correct credentials
4. Test the plugin

The debug logs will show if authentication succeeds.

## Best Practices

### Development vs Production

If you're developing or testing:

1. **Use separate API keys** for development and production
2. **Clear and switch** when needed:
   - Development: Use test API key
   - Production: Use production API key
3. **Label your keys** in the API provider's dashboard

### Security

1. **Never share** your API keys or tokens
2. **Rotate keys regularly** (every 90 days recommended)
3. **Use read-only tokens** when possible (JIRA supports this)
4. **Monitor usage** in your API provider's dashboard
5. **Revoke immediately** if compromised

### Multiple Accounts

If you have multiple JIRA instances or OpenAI accounts:

**Option 1: Switch as needed**
- Clear and re-enter credentials when switching
- Takes 30 seconds per switch

**Option 2: Duplicate plugins**
- Copy the `.omnifocusjs` file
- Rename it (e.g., `JIRA-Import-Production.omnifocusjs`)
- Modify the `identifier` in the metadata
- Each copy stores separate credentials

Example:
```javascript
/*{
    "identifier": "com.omnifocus.jira-import-production",
    ...
}*/
```

## Examples

### Example 1: Testing with Different OpenAI Keys

**Scenario:** You want to test GPT-5 with a different API key.

1. Run AI Task Clarifier
2. Click "Clear & Re-enter Key"
3. Enter test API key
4. Run analysis
5. When done, repeat to switch back to production key

### Example 2: Changing JIRA Project Filter

**Scenario:** You want to import from a different project.

1. Run JIRA Import
2. Click "Clear & Re-enter Credentials"
3. Keep domain, email, and token the same
4. Change project key (e.g., from "PROJ" to "DEV")
5. Click "Continue"
6. Import runs with new filter

### Example 3: Fixing Wrong Domain

**Scenario:** You entered the wrong JIRA domain.

1. Run JIRA Import
2. See error: "JIRA API Error: 404"
3. Run plugin again
4. Click "Clear & Re-enter Credentials"
5. Fix domain (e.g., change "company" to "mycompany")
6. Click "Continue"
7. Import succeeds

### Example 4: Expired API Token

**Scenario:** Your JIRA API token expired.

1. Go to https://id.atlassian.com/manage-profile/security/api-tokens
2. Create new API token
3. Copy the token
4. Run JIRA Import plugin
5. Click "Clear & Re-enter Credentials"
6. Paste new token
7. Click "Continue"
8. Import succeeds

## Keyboard Shortcuts

When the credential prompt appears:

- **Tab**: Move between fields
- **Shift+Tab**: Move backwards
- **Enter**: Submit form (same as clicking "Continue")
- **Escape**: Cancel (same as clicking "Cancel")

When the alert appears:

- **Enter**: Select first option (Use Stored)
- **Escape**: Cancel
- **Arrow keys**: Navigate options (on some systems)

## Advanced: Programmatic Access

If you're modifying the plugins, you can access credentials programmatically:

```javascript
// Read credentials
const creds = credentials.read("openai");
if (creds) {
    const apiKey = creds.password;
    // Use apiKey
}

// Write credentials
credentials.write("openai", "api-key", "sk-proj-...");

// Remove credentials
credentials.remove("openai");

// Check if credentials exist
const hasCredentials = credentials.read("openai") !== null;
```

## FAQ

**Q: Are credentials synced across devices?**
A: Yes, if you have iCloud Keychain enabled, credentials sync to your other Macs and iOS devices.

**Q: What happens if I reinstall OmniFocus?**
A: Credentials remain in Keychain and will be available after reinstalling.

**Q: Can I export my credentials?**
A: You can view them in Keychain Access, but for security reasons, you should regenerate API keys rather than exporting them.

**Q: Do credentials expire?**
A: The plugins don't expire credentials, but the API providers might. OpenAI keys don't expire by default. JIRA tokens can be set to expire.

**Q: Can I use the same credentials on multiple Macs?**
A: Yes, if iCloud Keychain is enabled. Otherwise, you'll need to enter credentials on each Mac.

**Q: What if I forget my API key?**
A: You can't retrieve it from Keychain (it's encrypted). Generate a new key from your API provider's dashboard.

**Q: Is it safe to use "Clear & Re-enter"?**
A: Yes, it's completely safe. The old credentials are securely deleted before new ones are stored.

## Summary

The built-in credential management makes it easy to:
- ✅ Update expired API keys/tokens
- ✅ Switch between accounts
- ✅ Fix incorrect credentials
- ✅ Test with different configurations
- ✅ Manage multiple environments

No need to manually edit Keychain or remember complex commands. Just click "Clear & Re-enter" and you're done!

