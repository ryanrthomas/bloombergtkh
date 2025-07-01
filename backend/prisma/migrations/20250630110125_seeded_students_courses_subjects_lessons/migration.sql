-- CreateIndex
CREATE INDEX "Courses_id_idx" ON "Courses"("id");

-- CreateIndex
CREATE INDEX "Courses_course_name_idx" ON "Courses"("course_name");

-- CreateIndex
CREATE INDEX "Courses_course_difficulity_idx" ON "Courses"("course_difficulity");

-- CreateIndex
CREATE INDEX "Courses_course_rating_idx" ON "Courses"("course_rating");

-- CreateIndex
CREATE INDEX "Courses_course_likes_idx" ON "Courses"("course_likes");
