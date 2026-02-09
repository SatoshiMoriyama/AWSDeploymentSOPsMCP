---
sop_name: deploy-frontend-app
repo_name: nextjsapp-deployment
app_name: NextJSApp
app_type: Frontend Application (Next.js)
branch: deploy-to-aws
created: 2026-02-10T15:30:00+09:00
last_updated: 2026-02-10T15:45:00+09:00
---

# Deployment Plan: NextJSApp

Coding Agents should follow this Deployment Plan, and validate previous progress if picking up the Deployment in a new coding session.

**IMPORTANT**: Update this plan after EACH step completes. Mark the step `[x]` and update `last_updated` timestamp.

## Phase 1: Gather Context and Configure
- [x] Step 0: Inform User of Execution Flow
- [x] Step 1: Create Deployment Plan
- [x] Step 2: Create Deploy Branch
- [x] Step 3: Detect Build Configuration
- [x] Step 4: Validate Prerequisites
- [ ] Step 5: Revisit Deployment Plan

### Build Configuration Detected
- Package Manager: pnpm v10.20.0
- Framework: Next.js 16.1.6 (App Router)
- Build Command: `pnpm --filter nextjsapp run build`
- Output Directory: `packages/nextjsapp/out/`
- Base Path: `/` (root)
- CloudFront Config: SPA (error responses to /index.html)

## Phase 2: Build CDK Infrastructure
- [ ] Step 6: Initialize CDK Foundation
- [ ] Step 7: Generate CDK Stack
- [ ] Step 8: Create Deployment Script
- [ ] Step 9: Validate CDK Synth

## Phase 3: Deploy and Validate
- [ ] Step 10: Execute CDK Deployment
- [ ] Step 11: Validate CloudFormation Stack

## Phase 4: Update Documentation
- [ ] Step 12: Finalize Deployment Plan
- [ ] Step 13: Update README.md

## Deployment Info

- Deployment URL: [after completion]
- Stack name: [after creation]
- Distribution ID: [after creation]
- S3 Bucket: [after creation]
- CloudFront Log Bucket: [after creation]
- S3 Log Bucket: [after creation]

## Recovery Guide

```bash
# Rollback
cd infra && npx cdk destroy "<StackName>"

# Redeploy
./scripts/deploy.sh
```

## Issues Encountered

None.

## Session Log

### Session 1 - 2026-02-10T15:30:00+09:00
Agent: Auto
Progress: Created deployment plan
Next: Create deploy branch
