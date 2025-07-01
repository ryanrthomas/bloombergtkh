-- AlterTable
ALTER TABLE "Conversations" ALTER COLUMN "deleted_at" DROP NOT NULL;

-- AlterTable
ALTER TABLE "Files" ALTER COLUMN "deleted_at" DROP NOT NULL;

-- AlterTable
ALTER TABLE "Messages" ALTER COLUMN "deleted_at" DROP NOT NULL;

-- CreateTable
CREATE TABLE "StudentFullProfile" (
    "student_id" TEXT NOT NULL,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "personality_type" TEXT,
    "timezone" TEXT,
    "gpa" DECIMAL(65,30),
    "bio" TEXT,
    "avatar" TEXT,
    "subject_experience_levels" JSONB,
    "student_availability" TEXT[],
    "preferred_study_times" TEXT[],
    "preferred_study_styles" TEXT[],
    "preferred_subjects" TEXT[],
    "preferred_languages" TEXT[],
    "student_courses" TEXT[],
    "student_lessons" TEXT[],

    CONSTRAINT "StudentFullProfile_pkey" PRIMARY KEY ("student_id")
);
