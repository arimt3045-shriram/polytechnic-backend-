# Polytechnic & Engineering Admission Portal — Backend API

Node.js + Express.js backend server integrated with PostgreSQL (Supabase) and Razorpay payment gateway.

## 🚀 Render.com Deployment Steps:
1. Create a GitHub Repository named `polytechnic-admission-backend`.
2. Upload all files (`server.js`, `package.json`, `schema.sql`, `routes/`, `config/`, `services/`) to GitHub.
3. In Supabase, run `schema.sql` in the **SQL Editor** to create database tables.
4. Log into [Render.com](https://render.com), click **New + > Web Service**, and connect `polytechnic-admission-backend`.
5. Add Environment Variables:
   - `PORT`: `5000`
   - `DATABASE_URL`: Your Supabase Connection String (`postgresql://...`)
6. Click **Create Web Service**. Your backend API will be live!
