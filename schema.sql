-- PostgreSQL Database Schema for Polytechnic & Engineering Admission Portal 2026-27

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Applications Table
CREATE TABLE IF NOT EXISTS applications (
    application_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    application_number VARCHAR(32) UNIQUE NOT NULL,
    candidate_name VARCHAR(128) NOT NULL,
    email VARCHAR(128) NOT NULL,
    mobile_number VARCHAR(15) NOT NULL,
    academic_track VARCHAR(32) NOT NULL CHECK (academic_track IN ('DIPLOMA_REGULAR', 'DIPLOMA_LATERAL', 'BTECH_REGULAR', 'BTECH_LATERAL')),
    preferred_branch VARCHAR(64) NOT NULL CHECK (preferred_branch IN ('COMPUTER_SCIENCE', 'MECHANICAL', 'CIVIL', 'ELECTRICAL', 'ECE')),
    category VARCHAR(16) NOT NULL CHECK (category IN ('GENERAL', 'OBC', 'SC', 'ST', 'EWS')),
    preferred_language VARCHAR(8) DEFAULT 'en' CHECK (preferred_language IN ('en', 'hi')),
    status VARCHAR(32) DEFAULT 'DRAFT' CHECK (status IN ('DRAFT', 'DOCUMENTS_UPLOADED', 'FEE_PENDING', 'PAID', 'ADMITTED')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Entrance Exam Records
CREATE TABLE IF NOT EXISTS entrance_exam_records (
    exam_record_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    application_id UUID NOT NULL REFERENCES applications(application_id) ON DELETE CASCADE,
    pathway_type VARCHAR(32) NOT NULL CHECK (pathway_type IN ('JEE_MAIN', 'UPTAC_RANK', 'CUET_UG', 'DIRECT_10PLUS2', 'JEECUP_APPEARED', 'JEECUP_NON_APPEARED')),
    roll_number VARCHAR(64),
    score_or_rank NUMERIC(8,2),
    scorecard_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. JEECUP Registrations Table (Non-Appeared applicants)
CREATE TABLE IF NOT EXISTS jeecup_new_registrations (
    jeecup_reg_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    application_id UUID NOT NULL REFERENCES applications(application_id) ON DELETE CASCADE,
    father_name VARCHAR(128) NOT NULL,
    mother_name VARCHAR(128) NOT NULL,
    dob DATE NOT NULL,
    gender VARCHAR(16) NOT NULL,
    exam_center_choice_1 VARCHAR(64) NOT NULL,
    exam_center_choice_2 VARCHAR(64) NOT NULL,
    exam_center_choice_3 VARCHAR(64) NOT NULL,
    jeecup_fee_amount NUMERIC(10,2) NOT NULL DEFAULT 500.00,
    registration_status VARCHAR(32) DEFAULT 'REGISTERED',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Applicant Documents Table
CREATE TABLE IF NOT EXISTS applicant_documents (
    document_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    application_id UUID NOT NULL REFERENCES applications(application_id) ON DELETE CASCADE,
    photo_url TEXT NOT NULL,
    signature_url TEXT NOT NULL,
    income_certificate_no VARCHAR(64) NOT NULL,
    annual_family_income NUMERIC(12,2) NOT NULL,
    caste_certificate_no VARCHAR(64),
    domicile_certificate_no VARCHAR(64) NOT NULL,
    income_cert_url TEXT NOT NULL,
    caste_cert_url TEXT,
    domicile_cert_url TEXT NOT NULL,
    uploaded_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. Fee Schedules Table
CREATE TABLE IF NOT EXISTS fee_schedules (
    fee_schedule_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    application_id UUID NOT NULL REFERENCES applications(application_id) ON DELETE CASCADE,
    enrollment_fee NUMERIC(10,2) NOT NULL DEFAULT 1200.00,
    tuition_fee NUMERIC(10,2) NOT NULL,
    jeecup_exam_fee NUMERIC(10,2) DEFAULT 0.00,
    total_payable NUMERIC(10,2) NOT NULL,
    razorpay_order_id VARCHAR(64),
    razorpay_payment_id VARCHAR(64),
    payment_status VARCHAR(32) DEFAULT 'PENDING' CHECK (payment_status IN ('PENDING', 'SUCCESS', 'FAILED')),
    paid_at TIMESTAMPTZ
);

-- Indexes for Fast Query Lookup
CREATE INDEX idx_applications_app_num ON applications(application_number);
CREATE INDEX idx_applications_status ON applications(status);
CREATE INDEX idx_fee_schedules_order_id ON fee_schedules(razorpay_order_id);
