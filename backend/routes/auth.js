import express from "express";
import APIResponse from "../classes/ApiResponse";
import prisma from "../prisma.js"
import supabase from "../supabase.js";

const express = express();

const generateStudentId = () => {
    const randomNumber = Math.floor(Math.random() * 99999) + 1;
    return ((randomNumber * 53171) % 1705829).toString().padStart(7, '0');
}; 
//AUTH ROUTES
const authRouter = express.Router();
authRouter.post('/register', async (req, res) => {
    try {
        const { email, password, firstName, lastName } = req.body;

        if (!email || !password || !firstName || !lastName) {
            const response = APIResponse.badRequest();
            return res.status(response.status).json(response.toJSON());
        }
        
        const { data: supabaseData, error: supabaseError } = await supabase.auth.signUp({
            email,
            password
        });

        if(supabaseError || !supabaseData.user){
            const response = APIResponse.error(supabaseError || "New user creation failed");
            return res.status(response.status).json(response.toJSON());
        }
        const studentId = generateStudentId();
        let newStudent;
        try {
            newStudent = await prisma.students.create({
                data: {
                    id: studentId,
                    user_id: supabaseData.user.id,
                    email: email,
                    first_name: firstName,
                    last_name: lastName
                }
            });
        }
        catch(dbError) {
            await supabase.auth.admin.deleteUser(data.user.id).catch(() => {});
            const response = APIResponse.error("Failed to create student profile");
            return res.status(response.status).json(response.toJSON());
        }

        const response = APIResponse.created(
            newStudent,
            "New user registered and student profile created successfully"
        );

        return res.status(response.status).json(response.toJSON());
        
    }
    catch(error){
        const response = APIResponse.error();
        return res.status(response.status).json(response.toJSON());
    }
});

authRouter.post('/login', async (req, res) => {
    try {
        const { email, password } = req.body;
        if (!email || !password) {
            const response = APIResponse.badRequest("Invalid email or password");
            return res.status(response.status).json(response.toJSON());
        }

        const { data, error } = await supabase.auth.signInWithPassword({
            email,
            password
        });

        if(error || !data.user){
            const response = APIResponse.error(error.message);
            return res.status(response.status).json(response.toJSON());
        }

        let existingStudent;
        try {
            existingStudent = await prisma.students.findUnique({
                where: {
                    user_id: data.user.id
                }
            });
        }
        catch(dbError) {
            const response = APIResponse.error("Failed to fetch student profile");
            return res.status(response.status).json(response.toJSON());
        }

        if(existingStudent){
            const response = APIResponse.success(
                existingStudent,
                "User signed in successfully",
            )
            return res.status(response.status).json(response.toJSON());
        }
        else {
            const response = APIResponse.notFound("Student profile not found");
            return res.status(response.status).json(response.toJSON());
        }
    }
    catch(error){
        const response = APIResponse.error();
        return res.status(response.status).json(response.toJSON());
    }
});

authRouter.post('/logout', async (req, res) => {
    try {
        const { error } = await supabase.auth.signOut();
        if(error){
            const response = APIResponse.error(error.message);
            return res.status(response.status).json(response.toJSON());
        }
        const response = APIResponse.success(null, "User logged out successfully");
        return res.status(response.status).json(response.toJSON());
    }
    catch(error){
        const response = APIResponse.error();
        return res.status(response.status).json(response.toJSON());
    }
});

authRouter.post('/delete', async (req, res) => {
    try {
        const { userId } = req.body;
        const { data, error } = await supabase.auth.admin.deleteUser(userId);

        if(error){
            const response = APIResponse.error("Failed to delete account");
            return res.status(response.status).json(response.toJSON());
        }

        try {
            await prisma.students.delete({
                where: {
                    user_id: userId
                }
            });
        }
        catch (dbError) {
            const response = APIResponse.error("Failed to delete student profile");
            return res.status(response.status).json(response.toJSON());
        }
        
        const response = APIResponse.success(null, "User account deleted successfully");
        return res.status(response.status).json(response.toJSON());
    }
    catch(error){
        const response = APIResponse.error(error.message);
        return res.status(response.status).json(response.toJSON());
    }
});

export default authRouter;