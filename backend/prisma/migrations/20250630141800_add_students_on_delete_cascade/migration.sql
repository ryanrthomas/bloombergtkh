-- DropForeignKey
ALTER TABLE "CalendarEvents" DROP CONSTRAINT "CalendarEvents_created_by_fkey";

-- DropForeignKey
ALTER TABLE "Calendars" DROP CONSTRAINT "Calendars_student_id_fkey";

-- DropForeignKey
ALTER TABLE "CallRecords" DROP CONSTRAINT "CallRecords_started_by_fkey";

-- DropForeignKey
ALTER TABLE "ConversationParticipants" DROP CONSTRAINT "ConversationParticipants_student_id_fkey";

-- DropForeignKey
ALTER TABLE "Files" DROP CONSTRAINT "Files_student_id_fkey";

-- DropForeignKey
ALTER TABLE "Messages" DROP CONSTRAINT "Messages_sent_by_fkey";

-- DropForeignKey
ALTER TABLE "PreferredLanguages" DROP CONSTRAINT "PreferredLanguages_student_id_fkey";

-- DropForeignKey
ALTER TABLE "PreferredStudyStyles" DROP CONSTRAINT "PreferredStudyStyles_student_id_fkey";

-- DropForeignKey
ALTER TABLE "PreferredStudyTimes" DROP CONSTRAINT "PreferredStudyTimes_student_id_fkey";

-- DropForeignKey
ALTER TABLE "PreferredSubjects" DROP CONSTRAINT "PreferredSubjects_student_id_fkey";

-- DropForeignKey
ALTER TABLE "StudentAvailability" DROP CONSTRAINT "StudentAvailability_student_id_fkey";

-- DropForeignKey
ALTER TABLE "StudentCourses" DROP CONSTRAINT "StudentCourses_student_id_fkey";

-- DropForeignKey
ALTER TABLE "StudentLessons" DROP CONSTRAINT "StudentLessons_student_id_fkey";

-- DropForeignKey
ALTER TABLE "StudentLikesRatings" DROP CONSTRAINT "StudentLikesRatings_student_id_fkey";

-- DropForeignKey
ALTER TABLE "StudyGroupMembers" DROP CONSTRAINT "StudyGroupMembers_student_id_fkey";

-- DropForeignKey
ALTER TABLE "SubjectExperienceLevels" DROP CONSTRAINT "SubjectExperienceLevels_student_id_fkey";

-- AddForeignKey
ALTER TABLE "Calendars" ADD CONSTRAINT "Calendars_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "Students"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CalendarEvents" ADD CONSTRAINT "CalendarEvents_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "Students"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Messages" ADD CONSTRAINT "Messages_sent_by_fkey" FOREIGN KEY ("sent_by") REFERENCES "Students"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Files" ADD CONSTRAINT "Files_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "Students"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CallRecords" ADD CONSTRAINT "CallRecords_started_by_fkey" FOREIGN KEY ("started_by") REFERENCES "Students"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SubjectExperienceLevels" ADD CONSTRAINT "SubjectExperienceLevels_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "Students"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PreferredSubjects" ADD CONSTRAINT "PreferredSubjects_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "Students"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StudentAvailability" ADD CONSTRAINT "StudentAvailability_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "Students"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PreferredStudyTimes" ADD CONSTRAINT "PreferredStudyTimes_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "Students"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PreferredStudyStyles" ADD CONSTRAINT "PreferredStudyStyles_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "Students"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StudyGroupMembers" ADD CONSTRAINT "StudyGroupMembers_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "Students"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ConversationParticipants" ADD CONSTRAINT "ConversationParticipants_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "Students"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PreferredLanguages" ADD CONSTRAINT "PreferredLanguages_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "Students"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StudentLikesRatings" ADD CONSTRAINT "StudentLikesRatings_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "Students"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StudentCourses" ADD CONSTRAINT "StudentCourses_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "Students"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StudentLessons" ADD CONSTRAINT "StudentLessons_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "Students"("id") ON DELETE CASCADE ON UPDATE CASCADE;
