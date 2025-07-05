import express from "express";
import APIResponse from "../classes/ApiResponse";
import prisma from "../prisma.js"

const express = express();

// STUDENT ROUTES
const studentRouter = express.Router();

studentRouter.get('/:studentId/profile', async (req, res) => {
    const studentId = req.params.studentId;

    if(!studentId){
        const response = APIResponse.badRequest("student id is null");
        return res.status(response.status).json(response.toJSON());
    }

    try{
        const studentData = await prisma.$queryRaw`
            SELECT 
                s.first_name AS "FirstName",
                s.last_name AS "LastName",
                s.email AS "Email",
                s.personality_type AS "PersonalityType",
                s.timezone AS "Timezone",
                s.gpa AS "GPA",
                s.bio AS "Bio",
                MAX(f.file_location) AS "Avatar",
            
                json_agg(
                DISTINCT jsonb_build_object(
                    'subject', sub.name,
                    'experience_level', sel.experience_level
                )
                ) FILTER (WHERE sel.subject_id IS NOT NULL) AS "SubjectExperienceLevels",
            
                array_agg(DISTINCT sa.day_of_week) FILTER (WHERE sa.day_of_week IS NOT NULL) AS "StudentAvailability",
                array_agg(DISTINCT pst.time_of_day) FILTER (WHERE pst.time_of_day IS NOT NULL) AS "PreferredStudyTimes",
                array_agg(DISTINCT pss.study_style) FILTER (WHERE pss.study_style IS NOT NULL) AS "PreferredStudyStyles",
                array_agg(DISTINCT sub2.name) FILTER (WHERE ps.subject_id IS NOT NULL) AS "PreferredSubjects",
                array_agg(DISTINCT pl.language) FILTER (WHERE pl.language IS NOT NULL) AS "PreferredLanguages",
                array_agg(DISTINCT c.course_name) FILTER (WHERE c.course_name IS NOT NULL) AS "StudentCourses",
                array_agg(DISTINCT l.lesson_name) FILTER (WHERE l.lesson_name IS NOT NULL) AS "StudentLessons"

            FROM "Students" s
            LEFT JOIN "Files" f ON s.id = f.student_id
            LEFT JOIN "SubjectExperienceLevels" sel ON s.id = sel.student_id
            LEFT JOIN "Subjects" sub ON sub.id = sel.subject_id
            LEFT JOIN "PreferredSubjects" ps ON s.id = ps.student_id
            LEFT JOIN "Subjects" sub2 ON sub2.id = ps.subject_id
            LEFT JOIN "StudentAvailability" sa ON s.id = sa.student_id
            LEFT JOIN "PreferredStudyTimes" pst ON s.id = pst.student_id
            LEFT JOIN "PreferredStudyStyles" pss ON s.id = pss.student_id
            LEFT JOIN "PreferredLanguages" pl ON s.id = pl.student_id
            LEFT JOIN "StudentCourses" sc ON s.id = sc.student_id
            LEFT JOIN "Courses" c ON c.id = sc.course_id
            LEFT JOIN "StudentLessons" sl ON s.id = sl.student_id
            LEFT JOIN "Lessons" l ON l.id = sl.lesson_id
            WHERE s.id = ${studentId}
            GROUP BY s.id;
        `;

        if(studentData.length === 0){
            const response = APIResponse.notFound("Student profile not found");
            return res.status(response.status).json(response.toJSON());
        }

        const response = APIResponse.success(studentData[0], "Full student profile retrieved");
        return res.status(response.status).json(response.toJSON());
    }
    catch(error){
        const response = APIResponse.error(error.message);
        return res.status(response.status).json(response.toJSON());
    }
});

studentRouter.patch('/edit', async (req, res) => {
    try {
        const {
            studentId,
            student,
            file,
            subjectExperienceLevels,
            preferredSubjects,
            availability,
            studyTimes,
            studyStyles,
            languages,
            courses,
            lessons
        } = req.body;

        if(!studentId) {
            const response = APIResponse.badRequest("Missing studentId");
            return res.status(response.status).json(response.toJSON());
        }

        const operations = [];
        if (student) {
            operations.push(
                prisma.students.update({
                    where: { id: studentId },
                    data: student
                })
            );
        }

        if (file) {
            operations.push(
                prisma.files.upsert({
                    where: { student_id: studentId },
                    update: { file_location: avatar },
                    create: { 
                        student_id: studentId, 
                        file_location: file.path,
                        file_name: file.name,
                        file_size: file.size,
                        file_type: file.type, 
                        deleted_at: new Date().toISOString()
                    }
                })
            );
        }

        if (subjectExperienceLevels) {
            operations.push(
                prisma.subjectExperienceLevels.deleteMany({ 
                    where: { student_id: studentId } 
                })
            );

            operations.push(
                prisma.subjectExperienceLevels.createMany({
                    data: subjectExperienceLevels.map(entry => ({
                        student_id: studentId,
                        subject_id: entry.subject_id,
                        experience_level: entry.experience_level
                        })
                    )
                })
            );
        }

        if (preferredSubjects) {
            operations.push(
                prisma.preferredSubjects.deleteMany({ 
                    where: { student_id: studentId } 
                })
            );

            operations.push(
                prisma.preferredSubjects.createMany({
                    data: preferredSubjects.map(subjectId => ({
                        student_id: studentId,
                        subject_id: subjectId
                        })
                    )
                })
            );
        }

        if (availability) {
            operations.push(
                prisma.studentAvailability.deleteMany({ 
                    where: { student_id: studentId } 
                })
            );

            operations.push(
                prisma.studentAvailability.createMany({
                    data: availability.map(day => ({ 
                        student_id: studentId, 
                        day_of_week: day 
                    })
                )})
            );
        }

        if (studyTimes) {
            operations.push(
                prisma.preferredStudyTimes.deleteMany({ 
                    where: { student_id: studentId } 
                })
            );

            operations.push(
                prisma.preferredStudyTimes.createMany({
                    data: studyTimes.map(time => ({ 
                        student_id: studentId, 
                        time_of_day: time 
                    })
                )})
            );
        }

        if (studyStyles) {
            operations.push(
                prisma.preferredStudyStyles.deleteMany({ 
                    where: { student_id: studentId } 
                })
            );

            operations.push(
                prisma.preferredStudyStyles.createMany({
                    data: studyStyles.map(style => ({ 
                        student_id: studentId, 
                        study_style: style 
                    })
                )})
            );
        }

        if (languages) {
            operations.push(
                prisma.preferredLanguages.deleteMany({ 
                    where: { student_id: studentId } 
                })
            );

            operations.push(
                prisma.preferredLanguages.createMany({
                    data: languages.map(language => ({ 
                        student_id: studentId, 
                        language 
                    })
                )})
            );
        }      
        
        if (courses) {
            operations.push(
                prisma.studentCourses.deleteMany({ 
                    where: { student_id: studentId } 
                })
            );

            operations.push(
                prisma.studentCourses.createMany({
                    data: courses.map(courseId => ({ 
                        student_id: studentId, 
                        course_id: courseId 
                    }))
                })
            );
        }

        if (lessons) {
            operations.push(
                prisma.studentLessons.deleteMany({ 
                    where: { student_id: studentId } 
                })
            );
            
            operations.push(
                prisma.studentLessons.createMany({
                    data: lessons.map(lessonId => ({ 
                        student_id: studentId, 
                        lesson_id: lessonId 
                    })
                )})
            );
        }

        await prisma.$transaction(operations);

        const studentData = await prisma.$queryRaw`
            SELECT 
                s.first_name AS "FirstName",
                s.last_name AS "LastName",
                s.email AS "Email",
                s.personality_type AS "PersonalityType",
                s.timezone AS "Timezone",
                s.gpa AS "GPA",
                s.bio AS "Bio",
                MAX(f.file_location) AS "Avatar",
            
                json_agg(
                DISTINCT jsonb_build_object(
                    'subject', sub.name,
                    'experience_level', sel.experience_level
                )
                ) FILTER (WHERE sel.subject_id IS NOT NULL) AS "SubjectExperienceLevels",
            
                array_agg(DISTINCT sa.day_of_week) FILTER (WHERE sa.day_of_week IS NOT NULL) AS "StudentAvailability",
                array_agg(DISTINCT pst.time_of_day) FILTER (WHERE pst.time_of_day IS NOT NULL) AS "PreferredStudyTimes",
                array_agg(DISTINCT pss.study_style) FILTER (WHERE pss.study_style IS NOT NULL) AS "PreferredStudyStyles",
                array_agg(DISTINCT sub2.name) FILTER (WHERE ps.subject_id IS NOT NULL) AS "PreferredSubjects",
                array_agg(DISTINCT pl.language) FILTER (WHERE pl.language IS NOT NULL) AS "PreferredLanguages",
                array_agg(DISTINCT c.course_name) FILTER (WHERE c.course_name IS NOT NULL) AS "StudentCourses",
                array_agg(DISTINCT l.lesson_name) FILTER (WHERE l.lesson_name IS NOT NULL) AS "StudentLessons"

            FROM "Students" s
            LEFT JOIN "Files" f ON s.id = f.student_id
            LEFT JOIN "SubjectExperienceLevels" sel ON s.id = sel.student_id
            LEFT JOIN "Subjects" sub ON sub.id = sel.subject_id
            LEFT JOIN "PreferredSubjects" ps ON s.id = ps.student_id
            LEFT JOIN "Subjects" sub2 ON sub2.id = ps.subject_id
            LEFT JOIN "StudentAvailability" sa ON s.id = sa.student_id
            LEFT JOIN "PreferredStudyTimes" pst ON s.id = pst.student_id
            LEFT JOIN "PreferredStudyStyles" pss ON s.id = pss.student_id
            LEFT JOIN "PreferredLanguages" pl ON s.id = pl.student_id
            LEFT JOIN "StudentCourses" sc ON s.id = sc.student_id
            LEFT JOIN "Courses" c ON c.id = sc.course_id
            LEFT JOIN "StudentLessons" sl ON s.id = sl.student_id
            LEFT JOIN "Lessons" l ON l.id = sl.lesson_id
            WHERE s.id = ${studentId}
            GROUP BY s.id;
        `;

        if (studentData.length === 0) {
            const response = APIResponse.notFound("Updated profile not found");
            return res.status(response.status).json(response.toJSON());
        }

        const response = APIResponse.success(studentData[0], "Student profile updated successfully");
        return res.status(response.status).json(response.toJSON());

    }
    catch(error){
        const response = APIResponse.error(error.message);
        return res.status(response.status).json(response.toJSON());
    }
});

export default studentRouter;