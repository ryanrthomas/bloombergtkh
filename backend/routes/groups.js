import express from "express";
import APIResponse from "../classes/ApiResponse";
import prisma from "../prisma.js"

const express = express();

// GROUP ROUTES
const studyGroupRouter = express.Router();

studyGroupRouter.post('/create', async (req, res) => {
    try {
        const { groupName, memberIds = []} = req.body;
        const amountOfMembers = memberIds.length;
        if (!groupName || groupName.length > 30) {
            const response = APIResponse.badRequest(!groupName ? "Missing required field: groupName" : "Group Name is too long.");
            return res.status(response.status).json(response.toJSON());
        }

        if (amountOfMembers > 0) {
            const members = await prisma.students.findMany({
                where: {
                    id: { in: memberIds }
                }
            });

            if (members.length !== amountOfMembers){
                const response = APIResponse.badRequest("One or more member IDs are invalid");
                return res.status(response.status).json(response.toJSON());
            }
        }

        const studyGroupData = await prisma.$transaction( async (trxn) => {

            const groupConversation = await trxn.conversations.create({
                data: {
                    conversation_type: "GROUP"
                }
            });

            const calendar = await trxn.calendars.create({
                data: {}
            });

            const studyGroup = await trxn.studyGroups.create({
                data: {
                    group_name: groupName,
                    group_size: amountOfMembers,
                    conversation_id: groupConversation.id,
                    calendar_id: calendar.id
                }
            });

            
            const updatedCalendar = await trxn.calendars.update({
                where: {
                    id: calendar.id
                },
                data: {
                    group_id: studyGroup.id
                }
            });

            const studyGroupMembers = await trxn.studyGroupMembers.createMany({
                data: memberIds.map(memberId => ({
                    student_id: memberId,
                    group_id: studyGroup.id
                }))
            });

            return { 
                studyGroup, 
                conversation: groupConversation, 
                calendar: updatedCalendar,
                studyGroupMembers
            };
        });

        const response = APIResponse.created( studyGroupData, "Study group created successfully" );
        return res.status(response.status).json(response.toJSON());
    
    }
    
    catch(error){
        const response = APIResponse.error(error.message);
        return res.status(response.status).json(response.toJSON());
    }
});

studyGroupRouter.get('/:groupId/members', async (req, res) => {
    try {
        const groupId = req.params.groupId;
        const studyGroupMembers = await prisma.studyGroupMembers.findMany({
            where: {
                group_id: groupId
            }
        });

        if(studyGroupMembers.length === 0){
            const response = APIResponse.notFound("There are no members in this study group");
            res.status(response.status).json(response.toJSON());
        }

        const response = APIResponse.success(studyGroupMembers, "Group members feteched successfully");
        res.status(response.status).json(response.toJSON());
    }
    catch (error) {
        const response = APIResponse.error(error.message);
        return res.status(response.status).json(response.toJSON());
    }
});

export default studyGroupRouter;