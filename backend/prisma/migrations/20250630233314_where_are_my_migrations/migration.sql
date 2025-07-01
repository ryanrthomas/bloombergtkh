-- DropForeignKey
ALTER TABLE "StudyGroups" DROP CONSTRAINT "StudyGroups_conversation_id_fkey";

-- AlterTable
ALTER TABLE "StudyGroups" ALTER COLUMN "conversation_id" DROP NOT NULL,
ALTER COLUMN "calendar_id" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "StudyGroups" ADD CONSTRAINT "StudyGroups_conversation_id_fkey" FOREIGN KEY ("conversation_id") REFERENCES "Conversations"("id") ON DELETE SET NULL ON UPDATE CASCADE;
