import supabase from "../supabase.js";
import { PrismaClient } from "@prisma/client/index.js"
import { faker } from "@faker-js/faker";

const prisma = new PrismaClient();
const courses = [
        "API Development",
        "Agile & Scrum Methodology", 
        "Algorithms & Data Structures",
        "Backend",
        "Big Data Tools",
        "Blockchain Fundamentals",
        "Cloud Computing",
        "Cybersecurity Basics",
        "Data Visualization",
        "Database Design & Management",
        "Deep Learning",
        "DevOps & CI/CD",
        "Frontend",
        "Full Stack Web Development",
        "Git & Version Control",
        "Machine Learning",
        "Mobile App Development",
        "Natural Language Processing",
        "Python for Data Analysis",
        "SQL for Data Analysis",
        "Software Testing & QA",
        "Statistics for Data Science",
        "Technical Interview Prep",
        "UI/UX Design"
    ];
const languages = [
    "ENGLISH",
    "SPANISH",
    "FRENCH",
    "GERMAN",
    "ITALIAN",
    "PORTUGUESE",
    "RUSSIAN",
    "CHINESE_SIMPLIFIED",
    "CHINESE_TRADITIONAL",
    "JAPANESE",
    "KOREAN",
    "ARABIC",
    "HINDI",
    "DUTCH",
    "SWEDISH",
    "NORWEGIAN",
    "DANISH",
    "POLISH",
    "CZECH",
    "HUNGARIAN",
    "FINNISH",
    "GREEK",
    "TURKISH",
    "HEBREW",
    "THAI",
    "VIETNAMESE",
    "INDONESIAN",
    "MALAY",
    "FILIPINO",
    "SWAHILI"
];

const personality_types = ["ISTJ","ISFJ","INFJ","INTJ","ISTP","ISFP","INFP","INTP","ESTP","ESFP","ENFP","ENTP","ESTJ","ESFJ","ENFJ","ENTJ"];
const difficulty_levels = ["BEGINNER", "INTERMEDIATE", "ADVANCED"];
const daysOfWeek = ["SUNDAY", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY"];
const studyTimes = ["MORNING", "AFTERNOON", "EVENING", "NIGHT"];
const studyStyles = ["PAIR","GROUP","FLEXIBLE"];
const timezones = [
    "UTC-12", "UTC-11", "UTC-10", "UTC-9", "UTC-8", "UTC-7", "UTC-6",
    "UTC-5", "UTC-4", "UTC-3", "UTC-2", "UTC-1", "UTC+0",
    "UTC+1", "UTC+2", "UTC+3", "UTC+4", "UTC+5", "UTC+6",
    "UTC+7", "UTC+8", "UTC+9", "UTC+10", "UTC+11", "UTC+12", "UTC+13", "UTC+14"
];
const course_status = ["NOT_STARTED", "IN_PROGRESS", "COMPLETED"];


const randomCourseIdGenerator = () => {
    return Math.floor(Math.random() * 24) + 1;
}

const generateStudentId = () => {
    const randomNumber = Math.floor(Math.random() * 99999) + 1;
    return ((randomNumber * 53171) % 1705829).toString().padStart(7, '0');
}; 

const createStudents = async () => {
    let createdStudents = 0;
    let numberOfUsersToCreate = 1000;
    let attempts = 0;
    const maxAttempts = 10000;

    while(createdStudents < numberOfUsersToCreate && attempts < maxAttempts){
        attempts++;
        let email;
        let emailExists = true;
        while(emailExists) {
            email = faker.internet.email();
            const existingStudent = await prisma.students.findUnique({
                where: {
                    email
                }
            });
            emailExists = !!existingStudent;
        }

        const studentId = generateStudentId();
        try {
            const existingStudent = await prisma.students.findUnique({
                where: {
                    id: studentId
                }
            });
            if (existingStudent) {
                console.log(`Student ID ${studentId} already exists, generating new one...`);
                continue;
            }
            
            const { data: supabaseData, error: supabaseError } = await supabase.auth.signUp({
                email: faker.internet.email(),
                password: "securepassword123"
            }); 
            
            if(supabaseError || !supabaseData.user) {
                console.error(`Failed to create Supabase user: ${supabaseError?.message}`);
                await new Promise(resolve => setTimeout(resolve, 2000)); 
                continue;
            }

            const newStudent = await prisma.students.create({
                data: {
                    id: studentId,
                    user_id: supabaseData.user.id,
                    email: supabaseData.user.email,
                    first_name: faker.person.firstName(),
                    last_name: faker.person.lastName(),
                    personality_type: personality_types[Math.floor(Math.random() * personality_types.length-1)],
                    timezone: timezones[Math.floor(Math.random() * timezones.length-1)],
                    gpa: faker.number.float({min:1.2, max: 4.0, precision: 0.2}),
                    bio: faker.lorem.sentences(2)
                }
            });

            console.log(`New student "${newStudent.first_name} ${newStudent.last_name}" with ID: ${newStudent.id} created successfully!`);
            createdStudents++;


            await Promise.all([
                prisma.files.create({
                    data: {
                        file_location: faker.image.avatar(),
                        file_name: faker.lorem.words(),
                        file_size: faker.number.bigInt(),
                        file_type: "file",
                        deleted_at: new Date().toISOString()
                    }
                }),

                prisma.subjectExperienceLevels.createMany({
                    data: [...new Set([
                        { student_id: studentId, subject_id: Math.floor(Math.random() * 24) + 1, experience_level: difficulty_levels[faker.number.int({min: 0, max: 2})] },
                        { student_id: studentId, subject_id: Math.floor(Math.random() * 24) + 1, experience_level: difficulty_levels[faker.number.int({min: 0, max: 2})] }
                    ])]
                }),

                prisma.preferredSubjects.createMany({
                    data: [...new Set([faker.number.int({min: 1, max: 24}), faker.number.int({min: 1, max: 24})])].map(id => ({ 
                        student_id: studentId, subject_id: id 
                    }))
                }),

                prisma.studentAvailability.createMany({
                data: [...new Set([daysOfWeek[faker.number.int({min: 0, max: daysOfWeek.length-1})], daysOfWeek[faker.number.int({min: 0, max: daysOfWeek.length-1})]])].map(day => ({
                    student_id: studentId,
                    day_of_week: day
                }))
                }),

                prisma.preferredStudyTimes.createMany({
                data: [...new Set([studyTimes[faker.number.int({min: 0, max: studyTimes.length-1})], studyTimes[faker.number.int({min: 0, max: studyTimes.length-1})]])].map(time => ({
                    student_id: studentId,
                    time_of_day: time // Replace with Enum or map if needed
                }))
                }),

                prisma.preferredStudyStyles.createMany({
                data: [...new Set([studyStyles[faker.number.int({min: 0, max: studyStyles.length-1})], studyStyles[faker.number.int({min: 0, max: studyStyles.length-1})]])].map(style => ({
                    student_id: studentId,
                    study_style: style // Enum assumed
                }))
                }),

                prisma.preferredLanguages.createMany({
                data:  [...new Set([languages[faker.number.int({min: 0, max: languages.length-1})], languages[faker.number.int({min: 0, max: languages.length-1})]])].map(lang => ({
                    student_id: studentId,
                    language: lang // Enum assumed
                }))
                }),

                prisma.studentCourses.createMany({
                data: [...new Set([faker.number.int({min: 1, max: 24}), faker.number.int({min: 1, max: 24})])].map(course_id => ({
                    student_id: studentId,
                    course_id,
                    course_status: course_status[faker.number.int({min: 0, max: 2})]
                }))
                }),

                prisma.studentLessons.createMany({
                data: [1, 2].map(lesson_id => ({
                    student_id: studentId,
                    lesson_id,
                    lesson_status: course_status[faker.number.int({min: 0, max: 2})]
                }))
                })
            ]);
            await new Promise(resolve => setTimeout(resolve, 5000)); 
        }
        catch (error) {
            console.error(`Error creating student: ${error.message}`);
            continue;
        }
    }

    if (attempts >= maxAttempts) {
        console.log(`Reached maximum attempts (${maxAttempts}). Created ${createdStudents} students.`);
    }
    
    console.log(`Finished! Created ${createdStudents} students total.`);
    await prisma.$disconnect();
};

const createCourses = async () => {

    for(let i = 0; i < courses.length; i++){
        const existingCourse = await prisma.courses.findFirst({
            where: {
                course_name: courses[i]
            }
        });

        if(existingCourse) {
            console.log(`Course named "${existingCourse.course_name}" already exists.`);
            break;
        }

        const randomDifficulty = Math.floor(Math.random() * 3);
        
        const newCourse = await prisma.courses.create({
            data: {
                course_name: courses[i],
                course_difficulity: difficulty_levels[randomDifficulty],
                description: faker.lorem.paragraph(),
                number_of_lessons: faker.number.int({min: 6, max: 9}),
                course_rating: faker.number.float({min: 0, max: 5, precision: 0.01}),
                course_likes: faker.number.int({min: 0, max: 1000})
            }
        });
    }

    console.log("All courses created successfully!");
    await prisma.$disconnect();
}

const createSubjects = async () => {
    for(let i = 0; i < courses.length; i++){
        try{
            const existingSubject = await prisma.subjects.findFirst({
                where: {
                    name: courses[i]
                }
            });

            if(existingSubject) {
                console.log(`Subject named "${existingSubject.name}" already exists.`);
                break;
            }

            const newSubject = await prisma.subjects.create({
                data: {
                    name: courses[i]
                }
            });
        }
        catch(error){
            console.log(error);
        }
    }
    console.log("All subjects created successfully!");
    await prisma.$disconnect();
}

const createLessons = async () => {
    for(let i = 0; i < courses.length; i++){
        try{
            const existingCourse = await prisma.courses.findFirst({
                where: {
                    course_name: courses[i]
                }
            });

            if(existingCourse) {
                console.log(`Existing course named ${existingCourse.course_name} was found, creating course lessons.`);
                const numOfLessons = existingCourse.number_of_lessons;
                for(let x = 0; x < numOfLessons; x++){
                    const randomDuration = faker.number.int({min: 5, max: 10});
                    const newLesson = await prisma.lessons.create({
                        data: {
                            course_id: existingCourse.id,
                            lesson_name: `${x+1}. ${faker.lorem.sentence()}`,
                            lesson_difficulty: existingCourse.course_difficulity,
                            description: faker.lorem.paragraph(),
                            duration: randomDuration * 60000
                        }
                    });

                    if(newLesson){
                        console.log(`New lesson named "${newLesson.name}" was added to course named "${existingCourse.name}" successfully!`);
                    }
                }
            }
        }
        catch(error){
            console.error(`Error creating lesson: ${error.message}`);
            continue;
        }
    }
}
createStudents().catch(console.error);
//createCourses().catch(console.error);
//createSubjects().catch(console.error);
//createLessons().catch(console.error);