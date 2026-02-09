# Deployment Summary

Your app is deployed to AWS! Preview URL: https://d1thetn4gk5512.cloudfront.net

**Next Step: Automate Deployments**

You're currently using manual deployment. To automate deployments from GitHub, ask your coding agent to set up AWS CodePipeline using an agent SOP for pipeline creation. Try: "create a pipeline using AWS SOPs"

Services used: CloudFront, S3, CloudFormation, IAM

Questions? Ask your Coding Agent:
 - What resources were deployed to AWS?
 - How do I update my deployment?

## Quick Commands

```bash
# View deployment status
aws cloudformation describe-stacks --stack-name "NextJSAppFrontend-preview-mori" --query 'Stacks[0].StackStatus' --output text --profile work

# Invalidate CloudFront cache
aws cloudfront create-invalidation --distribution-id "E1BL2H0W4UZW0R" --paths "/*" --profile work

# View CloudFront access logs (last hour)
aws s3 ls "s3://nextjsappfrontend-preview-cftos3cloudfrontloggingb-1xogatnadyxq/" --recursive --profile work | tail -20

# Redeploy
./scripts/deploy.sh
```

## Production Readiness

For production deployments, consider:
- WAF Protection: Add AWS WAF with managed rules (Core Rule Set, Known Bad Inputs) and rate limiting
- CSP Headers: Configure Content Security Policy in CloudFront response headers (`script-src 'self'`, `frame-ancestors 'none'`)
- Custom Domain: Set up Route 53 and ACM certificate
- Monitoring: CloudWatch alarms for 4xx/5xx errors and CloudFront metrics
- Auth Redirect URLs: If using an auth provider (Auth0, Supabase, Firebase, Lovable, etc.), add your CloudFront URL to allowed redirect URLs

---


---
sop_name: deploy-frontend-app
repo_name: nextjsapp-deployment
app_name: NextJSApp
app_type: Frontend Application (Next.js)
branch: deploy-to-aws
created: 2026-02-10T15:30:00+09:00
last_updated: 2026-02-10T04:49:00+09:00
---

# Deployment Plan: NextJSApp

**IMPORTANT**: Update this plan after EACH step completes. Mark the step `[x]` and update `last_updated` timestamp.

## Phase 1: Gather Context and Configure
- [x] Step 0: Inform User of Execution Flow
- [x] Step 1: Create Deployment Plan
- [x] Step 2: Create Deploy Branch
- [x] Step 3: Detect Build Configuration
- [x] Step 4: Validate Prerequisites
- [x] Step 5: Revisit Deployment Plan

### Build Configuration Detected
- Package Manager: pnpm v10.20.0
- Framework: Next.js 16.1.6 (App Router)
- Build Command: `pnpm --filter nextjsapp run build`
- Output Directory: `packages/nextjsapp/out/`
- Base Path: `/` (root)
- CloudFront Config: SPA (error responses to /index.html)

## Phase 2: Build CDK Infrastructure
- [x] Step 6: Initialize CDK Foundation
- [x] Step 7: Generate CDK Stack
- [x] Step 8: Create Deployment Script
- [x] Step 9: Validate CDK Synth

## Phase 3: Deploy and Validate
- [x] Step 10: Execute CDK Deployment
- [x] Step 11: Validate CloudFormation Stack

## Phase 4: Update Documentation
- [x] Step 12: Finalize Deployment Plan
- [x] Step 13: Update README.md

## Deployment Info

- Deployment URL: https://d1thetn4gk5512.cloudfront.net
- Stack name: NextJSAppFrontend-preview-mori
- Distribution ID: E1BL2H0W4UZW0R
- S3 Bucket: nextjsappfrontend-preview-m-cftos3s3bucketcae9f2be-nweitdzndqtx
- CloudFront Log Bucket: nextjsappfrontend-preview-cftos3cloudfrontloggingb-1xogatnadyxq
- S3 Log Bucket: nextjsappfrontend-preview-cftos3s3loggingbucket64b-gl1kpaxixz2f

## Recovery Guide

```bash
# Rollback
cd packages/cdk && npx cdk destroy "NextJSAppFrontend-preview-mori" --profile work

# Redeploy
./scripts/deploy.sh
```

## Issues Encountered

None.

## Session Log

### Session 1 - 2026-02-10T15:30:00+09:00
Agent: Auto
Progress: Created deployment plan, configured CDK infrastructure, deployed to AWS
Next: Documentation complete
