# Deploying FlexLite PLM to Vercel

## Prerequisites

1. GitHub account with the MyFlexPLM repository
2. Vercel account (sign up at https://vercel.com)
3. Supabase project is already set up and running

## Deployment Steps

### 1. Connect to Vercel

1. Go to [Vercel Dashboard](https://vercel.com/dashboard)
2. Click "Add New..." → "Project"
3. Import your GitHub repository: `qyang118766/MyFlexPLM`
4. Vercel will auto-detect Next.js

### 2. Configure Build Settings

Vercel should auto-detect the configuration, but verify:

- **Framework Preset**: Next.js
- **Root Directory**: `app` (IMPORTANT!)
- **Build Command**: `npm run build` (or leave default)
- **Output Directory**: `.next` (or leave default)
- **Install Command**: `npm install` (or leave default)

### 3. Environment Variables

Add the following environment variables in Vercel project settings:

```bash
# Supabase Configuration
NEXT_PUBLIC_SUPABASE_URL=https://qpfhhwsodawiserpqmdz.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFwZmhod3NvZGF3aXNlcnBxbWR6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI2OTM4MjgsImV4cCI6MjA3ODI2OTgyOH0.4NNryFxvMJblfbbVrYwmj0W9pTO_UXEpVTvJQKhQdWs

# Node Environment
NODE_ENV=production
```

**IMPORTANT**: The Supabase credentials above are from your current setup.
If you created a new Supabase project, update these values.

### 4. Deploy

1. Click "Deploy"
2. Vercel will:
   - Clone your repository
   - Install dependencies
   - Build the Next.js app
   - Deploy to a production URL

### 5. Custom Domain (Optional)

1. Go to your project settings
2. Navigate to "Domains"
3. Add your custom domain
4. Follow DNS configuration instructions

## Vercel Configuration Files

The following files have been created to optimize the deployment:

- **`vercel.json`**: Build and output configuration
- **`.vercelignore`**: Files to exclude from deployment

## Post-Deployment Checklist

- [ ] Verify the app loads at the Vercel URL
- [ ] Test login with `admin@example.com`
- [ ] Check that all pages load correctly
- [ ] Verify Supabase connection is working
- [ ] Test permissions with different user accounts
- [ ] Check that attribute permissions work correctly

## Troubleshooting

### Build Fails

1. Check build logs in Vercel dashboard
2. Verify all environment variables are set
3. Ensure `app/package.json` dependencies are correct

### App Doesn't Connect to Supabase

1. Verify `NEXT_PUBLIC_SUPABASE_URL` is correct
2. Verify `NEXT_PUBLIC_SUPABASE_ANON_KEY` is correct
3. Check Supabase project is active and accessible

### 404 Errors

1. Verify root directory is set to `app`
2. Check that pages are in `app/app/` directory
3. Clear Vercel cache and redeploy

## Continuous Deployment

Vercel automatically deploys when you push to GitHub:

- **Push to `master`**: Deploys to production
- **Push to other branches**: Creates preview deployments

## Useful Commands

```bash
# Install Vercel CLI (optional)
npm i -g vercel

# Login to Vercel
vercel login

# Deploy manually
vercel

# Deploy to production
vercel --prod
```

## Support

- Vercel Docs: https://vercel.com/docs
- Next.js Deployment: https://nextjs.org/docs/deployment
- Supabase Integration: https://supabase.com/docs/guides/getting-started/quickstarts/nextjs
