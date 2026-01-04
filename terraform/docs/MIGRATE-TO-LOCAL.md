# Migrating Terraform State from Remote to Local

This guide explains how to migrate your Terraform state from Azure remote backend to local backend.

## Option 1: Start Fresh (No Existing State to Preserve)

If you don't need to preserve your existing state:

1. **Reinitialize Terraform:**
   ```bash
   cd envs/dev
   terraform init -migrate-state
   ```
   
   When prompted, type `yes` to confirm migration.

2. **Verify:**
   ```bash
   terraform plan
   ```

## Option 2: Migrate Existing State (Preserve Current State)

If you want to keep your existing state from Azure:

1. **Pull the current state from Azure:**
   ```bash
   cd envs/dev
   terraform init -reconfigure
   terraform state pull > terraform.tfstate.backup
   ```

2. **Update backend configuration** (already done - backend.tf now uses local)

3. **Reinitialize with migration:**
   ```bash
   terraform init -migrate-state
   ```
   
   When prompted:
   - Type `yes` to confirm copying existing state to the new backend
   - Type `yes` to confirm migration

4. **Verify the state was migrated:**
   ```bash
   terraform state list
   terraform plan
   ```

5. **Clean up (optional):**
   ```bash
   # Remove the backup file if migration was successful
   rm terraform.tfstate.backup
   ```

## Option 3: Manual State Migration

If automatic migration doesn't work:

1. **Pull state from Azure:**
   ```bash
   # First, temporarily revert backend.tf to azurerm
   terraform init
   terraform state pull > state-from-azure.json
   ```

2. **Switch to local backend:**
   ```bash
   # Restore backend.tf to local (already done)
   terraform init -migrate-state
   ```

3. **Push state to local (if needed):**
   ```bash
   terraform state push state-from-azure.json
   ```

## Important Notes

⚠️ **State File Location:**
- Local state will be stored as `terraform.tfstate` in each environment directory
- This file is already in `.gitignore` and will NOT be committed to git
- **Make sure to back up your state files regularly!**

⚠️ **Team Collaboration:**
- With local state, each team member will have their own state file
- This can lead to state drift and conflicts
- Consider using version control for state files or switching back to remote backend for team environments

⚠️ **State Backup:**
- Always keep backups of your state files
- State files contain sensitive information (resource IDs, etc.)
- Never commit state files to git (already configured in .gitignore)

## Verifying the Migration

After migration, verify everything works:

```bash
# Check state list
terraform state list

# Run a plan to ensure no unexpected changes
terraform plan

# If everything looks good, you can remove the Azure backend state
# (Only after confirming local state works correctly)
```

## Troubleshooting

### Error: "Backend configuration changed"
- Run `terraform init -migrate-state` to migrate
- Or use `terraform init -reconfigure` to start fresh

### Error: "State file not found"
- If you migrated, check that `terraform.tfstate` exists in the directory
- If starting fresh, this is normal - Terraform will create it on first apply

### Want to switch back to remote?
- Restore the `backend "azurerm"` configuration in `backend.tf`
- Run `terraform init -migrate-state` to migrate back

