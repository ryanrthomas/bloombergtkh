-- CreateEnum
CREATE TYPE "LanguageEnum" AS ENUM ('ENGLISH', 'SPANISH', 'FRENCH', 'GERMAN', 'ITALIAN', 'PORTUGUESE', 'RUSSIAN', 'CHINESE_SIMPLIFIED', 'CHINESE_TRADITIONAL', 'JAPANESE', 'KOREAN', 'ARABIC', 'HINDI', 'DUTCH', 'SWEDISH', 'NORWEGIAN', 'DANISH', 'POLISH', 'CZECH', 'HUNGARIAN', 'FINNISH', 'GREEK', 'TURKISH', 'HEBREW', 'THAI', 'VIETNAMESE', 'INDONESIAN', 'MALAY', 'FILIPINO', 'SWAHILI');

-- CreateEnum
CREATE TYPE "Status" AS ENUM ('NOT_STARTED', 'IN_PROGRESS', 'COMPLETED');

-- CreateTable
CREATE TABLE "Courses" (
    "id" SERIAL NOT NULL,
    "course_name" VARCHAR(100) NOT NULL,
    "course_difficulity" "ExperienceLevels" NOT NULL,
    "description" TEXT NOT NULL,
    "number_of_lessons" INTEGER NOT NULL,
    "course_rating" DECIMAL(3,2) NOT NULL,
    "course_likes" INTEGER NOT NULL,

    CONSTRAINT "Courses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Lessons" (
    "id" SERIAL NOT NULL,
    "course_id" INTEGER NOT NULL,
    "lesson_name" VARCHAR(100) NOT NULL,
    "lesson_difficulty" "ExperienceLevels" NOT NULL,
    "description" TEXT NOT NULL,
    "duration" INTEGER NOT NULL,

    CONSTRAINT "Lessons_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PreferredLanguages" (
    "student_id" VARCHAR(7) NOT NULL,
    "language" "LanguageEnum" NOT NULL
);

-- CreateTable
CREATE TABLE "StudentLikesRatings" (
    "student_id" VARCHAR NOT NULL,
    "course_id" INTEGER NOT NULL,

    CONSTRAINT "StudentLikesRatings_pkey" PRIMARY KEY ("student_id","course_id")
);

-- CreateTable
CREATE TABLE "StudentCourses" (
    "student_id" VARCHAR(7) NOT NULL,
    "course_id" INTEGER NOT NULL,
    "course_status" "Status" NOT NULL,

    CONSTRAINT "StudentCourses_pkey" PRIMARY KEY ("student_id","course_id")
);

-- CreateTable
CREATE TABLE "StudentLessons" (
    "student_id" VARCHAR(7) NOT NULL,
    "lesson_id" INTEGER NOT NULL,
    "lesson_status" "Status" NOT NULL,

    CONSTRAINT "StudentLessons_pkey" PRIMARY KEY ("student_id","lesson_id")
);

-- CreateTable
CREATE TABLE "LessonFiles" (
    "lesson_id" INTEGER NOT NULL,
    "file_id" INTEGER NOT NULL,

    CONSTRAINT "LessonFiles_pkey" PRIMARY KEY ("lesson_id","file_id")
);

-- CreateTable
CREATE TABLE "CourseFiles" (
    "course_id" INTEGER NOT NULL,
    "file_id" INTEGER NOT NULL,

    CONSTRAINT "CourseFiles_pkey" PRIMARY KEY ("course_id","file_id")
);

-- CreateIndex
CREATE INDEX "PreferredLanguages_student_id_language_idx" ON "PreferredLanguages"("student_id", "language");

-- CreateIndex
CREATE UNIQUE INDEX "PreferredLanguages_student_id_language_key" ON "PreferredLanguages"("student_id", "language");

-- CreateIndex
CREATE INDEX "StudentLikesRatings_student_id_course_id_idx" ON "StudentLikesRatings"("student_id", "course_id");

-- CreateIndex
CREATE INDEX "StudentCourses_student_id_course_id_idx" ON "StudentCourses"("student_id", "course_id");

-- CreateIndex
CREATE INDEX "StudentLessons_student_id_lesson_id_idx" ON "StudentLessons"("student_id", "lesson_id");

-- CreateIndex
CREATE INDEX "LessonFiles_lesson_id_file_id_idx" ON "LessonFiles"("lesson_id", "file_id");

-- CreateIndex
CREATE INDEX "CourseFiles_course_id_file_id_idx" ON "CourseFiles"("course_id", "file_id");

-- AddForeignKey
ALTER TABLE "Lessons" ADD CONSTRAINT "Lessons_course_id_fkey" FOREIGN KEY ("course_id") REFERENCES "Courses"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PreferredLanguages" ADD CONSTRAINT "PreferredLanguages_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "Students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StudentLikesRatings" ADD CONSTRAINT "StudentLikesRatings_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "Students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StudentLikesRatings" ADD CONSTRAINT "StudentLikesRatings_course_id_fkey" FOREIGN KEY ("course_id") REFERENCES "Courses"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StudentCourses" ADD CONSTRAINT "StudentCourses_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "Students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StudentCourses" ADD CONSTRAINT "StudentCourses_course_id_fkey" FOREIGN KEY ("course_id") REFERENCES "Courses"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StudentLessons" ADD CONSTRAINT "StudentLessons_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "Students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StudentLessons" ADD CONSTRAINT "StudentLessons_lesson_id_fkey" FOREIGN KEY ("lesson_id") REFERENCES "Lessons"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LessonFiles" ADD CONSTRAINT "LessonFiles_lesson_id_fkey" FOREIGN KEY ("lesson_id") REFERENCES "Lessons"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LessonFiles" ADD CONSTRAINT "LessonFiles_file_id_fkey" FOREIGN KEY ("file_id") REFERENCES "Files"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CourseFiles" ADD CONSTRAINT "CourseFiles_course_id_fkey" FOREIGN KEY ("course_id") REFERENCES "Courses"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CourseFiles" ADD CONSTRAINT "CourseFiles_file_id_fkey" FOREIGN KEY ("file_id") REFERENCES "Files"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
