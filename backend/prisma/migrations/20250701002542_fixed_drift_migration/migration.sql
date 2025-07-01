-- DropForeignKey
ALTER TABLE "Calendars" DROP CONSTRAINT "Calendars_group_id_fkey";

-- AlterTable
ALTER TABLE "Calendars" ALTER COLUMN "student_id" DROP NOT NULL,
ALTER COLUMN "group_id" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "Calendars" ADD CONSTRAINT "Calendars_group_id_fkey" FOREIGN KEY ("group_id") REFERENCES "StudyGroups"("id") ON DELETE SET NULL ON UPDATE CASCADE;
