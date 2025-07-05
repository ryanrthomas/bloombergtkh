import express from "express";
import APIResponse from "../classes/ApiResponse";
import prisma from "../prisma.js"

const express = express();

//SEARCH ROUTES
const searchRouter = express.Router();

searchRouter.post('/name', async (req, res) => {
    try {
        const { 
            query, 
            personality_type, 
            timezone, 
            preferred_language, 
            preferred_study_style, 
            preferred_study_times, 
            preferred_subjects,
        } = req.body;
        
        if (!query) {
            const response = APIResponse.badRequest("Please enter a valid student name");
            return res.status(response.status).json(response.toJSON());
        }

        const searchResults = await searchStudents({
            nameQuery: query,
            filters: {
                personality_type,
                timezone,
                preferred_language,
                preferred_study_style,
                preferred_study_times,
                preferred_subjects
            }
        });

        const response = APIResponse.success(
            {
                searchType: 'students',
                query: query,
                filters: {
                    personality_type,
                    timezone,
                    preferred_language,
                    preferred_study_style,
                    preferred_study_times,
                    preferred_subjects
                },
                results: searchResults.data,
                total: searchResults.total
            }
        );

        res.status(response.status).json(response.toJSON());
    }
    catch (error) {
        const response = APIResponse.error();
        res.status(response.status).json(response.toJSON());
    }
});

searchRouter.post('/courses', async (req, res) => {
    try {
        const { 
            query, 
            course_difficulty, 
            course_rating, 
            course_likes, 
            number_of_lessons
        } = req.body;
        
        if (!query) {
            return res.status(400).json({
            error: 'Search query is required',
            message: 'Please provide a course name to search for'
            });
        }

        const searchResults = await searchCourses({
            courseQuery: query,
            filters: {
                course_difficulty,
                course_rating,
                course_likes,
                number_of_lessons
            }
        });

        const response = APIResponse.success(
            {
                searchType: 'courses',
                query: query,
                filters: {
                    course_difficulty,
                    course_rating,
                    course_likes,
                    number_of_lessons
                },
                results: searchResults.data,
                total: searchResults.total
            }
        );

        res.status(response.status).json(response.toJSON());
    }  
    catch(error){
        const response = APIResponse.error();
        res.status(response.status).json(response.toJSON());
    }
});

const searchStudents = async ({name, filters}) => {
    //imagine its here
};

const searchCourses = async ({name, filters}) => {
    //imagine its here
};

export default searchRouter;