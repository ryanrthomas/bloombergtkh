-- CreateEnum
CREATE TYPE "DaysOfWeek" AS ENUM ('MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY');

-- CreateEnum
CREATE TYPE "TimesOfDay" AS ENUM ('MORNING', 'AFTERNOON', 'EVENING', 'NIGHT');

-- CreateEnum
CREATE TYPE "StudyStyles" AS ENUM ('PAIR', 'GROUP', 'FLEXIBLE');

-- CreateEnum
CREATE TYPE "ExperienceLevels" AS ENUM ('BEGINNER', 'INTERMEDIATE', 'ADVANCED');

-- CreateTable
CREATE TABLE "Students" (
    "id" VARCHAR(7) NOT NULL,
    "user_id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "first_name" VARCHAR(50) NOT NULL,
    "last_name" VARCHAR(50) NOT NULL,
    "personality_type" VARCHAR(6),
    "timezone" VARCHAR(6),
    "gpa" DECIMAL(3,2),
    "bio" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ,

    CONSTRAINT "Students_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Calendars" (
    "id" SERIAL NOT NULL,
    "student_id" VARCHAR(7) NOT NULL,
    "group_id" INTEGER NOT NULL,

    CONSTRAINT "Calendars_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CalendarEvents" (
    "id" SERIAL NOT NULL,
    "calendar_id" INTEGER NOT NULL,
    "created_by" TEXT NOT NULL,
    "event_name" VARCHAR(100) NOT NULL,
    "start_time" TIMESTAMPTZ NOT NULL,
    "end_time" TIMESTAMPTZ NOT NULL,
    "date" DATE NOT NULL,
    "description" TEXT NOT NULL,
    "event_type" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ,

    CONSTRAINT "CalendarEvents_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StudyGroups" (
    "id" SERIAL NOT NULL,
    "conversation_id" INTEGER NOT NULL,
    "calendar_id" INTEGER NOT NULL,
    "group_name" VARCHAR(30) NOT NULL,
    "group_size" INTEGER NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ,

    CONSTRAINT "StudyGroups_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Conversations" (
    "id" SERIAL NOT NULL,
    "conversation_type" VARCHAR(15) NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "Conversations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Messages" (
    "id" SERIAL NOT NULL,
    "conversation_id" INTEGER NOT NULL,
    "sent_by" TEXT NOT NULL,
    "message_type" VARCHAR(10) NOT NULL,
    "message_content" TEXT,
    "sent_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "Messages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Files" (
    "id" SERIAL NOT NULL,
    "student_id" TEXT,
    "file_location" VARCHAR(255) NOT NULL,
    "file_name" VARCHAR(255) NOT NULL,
    "file_size" BIGINT NOT NULL,
    "file_type" VARCHAR(20) NOT NULL,
    "mime_type" VARCHAR(100),
    "checksum" VARCHAR(64),
    "uploaded_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "Files_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CallRecords" (
    "id" SERIAL NOT NULL,
    "conversation_id" INTEGER NOT NULL,
    "call_type" VARCHAR(10) NOT NULL,
    "started_by" TEXT NOT NULL,
    "start_time" TIMESTAMPTZ NOT NULL,
    "end_time" TIMESTAMPTZ,
    "call_status" VARCHAR(10) NOT NULL,
    "duration" INTEGER,

    CONSTRAINT "CallRecords_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SubjectExperienceLevels" (
    "student_id" TEXT NOT NULL,
    "subject_id" INTEGER NOT NULL,
    "experience_level" "ExperienceLevels" NOT NULL,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "SubjectExperienceLevels_pkey" PRIMARY KEY ("student_id","subject_id")
);

-- CreateTable
CREATE TABLE "PreferredSubjects" (
    "student_id" TEXT NOT NULL,
    "subject_id" INTEGER NOT NULL,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "PreferredSubjects_pkey" PRIMARY KEY ("student_id","subject_id")
);

-- CreateTable
CREATE TABLE "StudentAvailability" (
    "student_id" TEXT NOT NULL,
    "day_of_week" "DaysOfWeek" NOT NULL,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "PreferredStudyTimes" (
    "student_id" TEXT NOT NULL,
    "time_of_day" "TimesOfDay" NOT NULL,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "PreferredStudyStyles" (
    "student_id" TEXT NOT NULL,
    "study_style" "StudyStyles" NOT NULL,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "StudyGroupMembers" (
    "student_id" TEXT NOT NULL,
    "group_id" INTEGER NOT NULL,
    "joined_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "left_at" TIMESTAMPTZ,

    CONSTRAINT "StudyGroupMembers_pkey" PRIMARY KEY ("student_id","group_id")
);

-- CreateTable
CREATE TABLE "ConversationParticipants" (
    "student_id" TEXT NOT NULL,
    "conversation_id" INTEGER NOT NULL,
    "joined_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "left_at" TIMESTAMPTZ,

    CONSTRAINT "ConversationParticipants_pkey" PRIMARY KEY ("student_id","conversation_id")
);

-- CreateTable
CREATE TABLE "MessageFiles" (
    "message_id" INTEGER NOT NULL,
    "file_id" INTEGER NOT NULL,

    CONSTRAINT "MessageFiles_pkey" PRIMARY KEY ("message_id","file_id")
);

-- CreateTable
CREATE TABLE "Subjects" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,

    CONSTRAINT "Subjects_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Students_user_id_key" ON "Students"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "Students_email_key" ON "Students"("email");

-- CreateIndex
CREATE INDEX "Students_email_idx" ON "Students"("email");

-- CreateIndex
CREATE INDEX "Students_created_at_idx" ON "Students"("created_at");

-- CreateIndex
CREATE INDEX "Students_deleted_at_idx" ON "Students"("deleted_at");

-- CreateIndex
CREATE INDEX "Students_first_name_last_name_idx" ON "Students"("first_name", "last_name");

-- CreateIndex
CREATE UNIQUE INDEX "Calendars_student_id_key" ON "Calendars"("student_id");

-- CreateIndex
CREATE UNIQUE INDEX "Calendars_group_id_key" ON "Calendars"("group_id");

-- CreateIndex
CREATE INDEX "Calendars_student_id_idx" ON "Calendars"("student_id");

-- CreateIndex
CREATE INDEX "Calendars_group_id_idx" ON "Calendars"("group_id");

-- CreateIndex
CREATE INDEX "CalendarEvents_calendar_id_idx" ON "CalendarEvents"("calendar_id");

-- CreateIndex
CREATE INDEX "CalendarEvents_created_by_idx" ON "CalendarEvents"("created_by");

-- CreateIndex
CREATE INDEX "CalendarEvents_date_idx" ON "CalendarEvents"("date");

-- CreateIndex
CREATE INDEX "CalendarEvents_start_time_idx" ON "CalendarEvents"("start_time");

-- CreateIndex
CREATE INDEX "CalendarEvents_event_type_idx" ON "CalendarEvents"("event_type");

-- CreateIndex
CREATE INDEX "CalendarEvents_deleted_at_idx" ON "CalendarEvents"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "StudyGroups_conversation_id_key" ON "StudyGroups"("conversation_id");

-- CreateIndex
CREATE UNIQUE INDEX "StudyGroups_calendar_id_key" ON "StudyGroups"("calendar_id");

-- CreateIndex
CREATE INDEX "StudyGroups_created_at_idx" ON "StudyGroups"("created_at");

-- CreateIndex
CREATE INDEX "StudyGroups_group_name_idx" ON "StudyGroups"("group_name");

-- CreateIndex
CREATE INDEX "StudyGroups_deleted_at_idx" ON "StudyGroups"("deleted_at");

-- CreateIndex
CREATE INDEX "Conversations_conversation_type_idx" ON "Conversations"("conversation_type");

-- CreateIndex
CREATE INDEX "Conversations_created_at_idx" ON "Conversations"("created_at");

-- CreateIndex
CREATE INDEX "Conversations_deleted_at_idx" ON "Conversations"("deleted_at");

-- CreateIndex
CREATE INDEX "Messages_conversation_id_sent_at_idx" ON "Messages"("conversation_id", "sent_at");

-- CreateIndex
CREATE INDEX "Messages_sent_by_idx" ON "Messages"("sent_by");

-- CreateIndex
CREATE INDEX "Messages_message_type_idx" ON "Messages"("message_type");

-- CreateIndex
CREATE INDEX "Messages_sent_at_idx" ON "Messages"("sent_at");

-- CreateIndex
CREATE INDEX "Messages_deleted_at_idx" ON "Messages"("deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "Files_student_id_key" ON "Files"("student_id");

-- CreateIndex
CREATE INDEX "Files_student_id_idx" ON "Files"("student_id");

-- CreateIndex
CREATE INDEX "Files_file_type_idx" ON "Files"("file_type");

-- CreateIndex
CREATE INDEX "Files_uploaded_at_idx" ON "Files"("uploaded_at");

-- CreateIndex
CREATE INDEX "Files_deleted_at_idx" ON "Files"("deleted_at");

-- CreateIndex
CREATE INDEX "Files_checksum_idx" ON "Files"("checksum");

-- CreateIndex
CREATE INDEX "CallRecords_conversation_id_idx" ON "CallRecords"("conversation_id");

-- CreateIndex
CREATE INDEX "CallRecords_started_by_idx" ON "CallRecords"("started_by");

-- CreateIndex
CREATE INDEX "CallRecords_start_time_idx" ON "CallRecords"("start_time");

-- CreateIndex
CREATE INDEX "CallRecords_call_status_idx" ON "CallRecords"("call_status");

-- CreateIndex
CREATE INDEX "CallRecords_duration_idx" ON "CallRecords"("duration");

-- CreateIndex
CREATE INDEX "SubjectExperienceLevels_experience_level_idx" ON "SubjectExperienceLevels"("experience_level");

-- CreateIndex
CREATE INDEX "StudentAvailability_day_of_week_idx" ON "StudentAvailability"("day_of_week");

-- CreateIndex
CREATE UNIQUE INDEX "StudentAvailability_student_id_day_of_week_key" ON "StudentAvailability"("student_id", "day_of_week");

-- CreateIndex
CREATE INDEX "PreferredStudyTimes_time_of_day_idx" ON "PreferredStudyTimes"("time_of_day");

-- CreateIndex
CREATE UNIQUE INDEX "PreferredStudyTimes_student_id_time_of_day_key" ON "PreferredStudyTimes"("student_id", "time_of_day");

-- CreateIndex
CREATE INDEX "PreferredStudyStyles_study_style_idx" ON "PreferredStudyStyles"("study_style");

-- CreateIndex
CREATE UNIQUE INDEX "PreferredStudyStyles_student_id_study_style_key" ON "PreferredStudyStyles"("student_id", "study_style");

-- CreateIndex
CREATE INDEX "StudyGroupMembers_joined_at_idx" ON "StudyGroupMembers"("joined_at");

-- CreateIndex
CREATE INDEX "StudyGroupMembers_left_at_idx" ON "StudyGroupMembers"("left_at");

-- CreateIndex
CREATE INDEX "ConversationParticipants_joined_at_idx" ON "ConversationParticipants"("joined_at");

-- CreateIndex
CREATE INDEX "ConversationParticipants_left_at_idx" ON "ConversationParticipants"("left_at");

-- CreateIndex
CREATE INDEX "Subjects_name_idx" ON "Subjects"("name");

-- AddForeignKey
ALTER TABLE "Calendars" ADD CONSTRAINT "Calendars_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "Students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Calendars" ADD CONSTRAINT "Calendars_group_id_fkey" FOREIGN KEY ("group_id") REFERENCES "StudyGroups"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CalendarEvents" ADD CONSTRAINT "CalendarEvents_calendar_id_fkey" FOREIGN KEY ("calendar_id") REFERENCES "Calendars"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CalendarEvents" ADD CONSTRAINT "CalendarEvents_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "Students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StudyGroups" ADD CONSTRAINT "StudyGroups_conversation_id_fkey" FOREIGN KEY ("conversation_id") REFERENCES "Conversations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Messages" ADD CONSTRAINT "Messages_conversation_id_fkey" FOREIGN KEY ("conversation_id") REFERENCES "Conversations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Messages" ADD CONSTRAINT "Messages_sent_by_fkey" FOREIGN KEY ("sent_by") REFERENCES "Students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Files" ADD CONSTRAINT "Files_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "Students"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CallRecords" ADD CONSTRAINT "CallRecords_conversation_id_fkey" FOREIGN KEY ("conversation_id") REFERENCES "Conversations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CallRecords" ADD CONSTRAINT "CallRecords_started_by_fkey" FOREIGN KEY ("started_by") REFERENCES "Students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SubjectExperienceLevels" ADD CONSTRAINT "SubjectExperienceLevels_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "Students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SubjectExperienceLevels" ADD CONSTRAINT "SubjectExperienceLevels_subject_id_fkey" FOREIGN KEY ("subject_id") REFERENCES "Subjects"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PreferredSubjects" ADD CONSTRAINT "PreferredSubjects_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "Students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PreferredSubjects" ADD CONSTRAINT "PreferredSubjects_subject_id_fkey" FOREIGN KEY ("subject_id") REFERENCES "Subjects"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StudentAvailability" ADD CONSTRAINT "StudentAvailability_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "Students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PreferredStudyTimes" ADD CONSTRAINT "PreferredStudyTimes_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "Students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PreferredStudyStyles" ADD CONSTRAINT "PreferredStudyStyles_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "Students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StudyGroupMembers" ADD CONSTRAINT "StudyGroupMembers_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "Students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StudyGroupMembers" ADD CONSTRAINT "StudyGroupMembers_group_id_fkey" FOREIGN KEY ("group_id") REFERENCES "StudyGroups"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ConversationParticipants" ADD CONSTRAINT "ConversationParticipants_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "Students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ConversationParticipants" ADD CONSTRAINT "ConversationParticipants_conversation_id_fkey" FOREIGN KEY ("conversation_id") REFERENCES "Conversations"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MessageFiles" ADD CONSTRAINT "MessageFiles_message_id_fkey" FOREIGN KEY ("message_id") REFERENCES "Messages"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MessageFiles" ADD CONSTRAINT "MessageFiles_file_id_fkey" FOREIGN KEY ("file_id") REFERENCES "Files"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
