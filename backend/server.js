import express from "express"
import cors from "cors"
import authRouter from "./routes/auth.js";
import studentRouter from "./routes/student.js";
import studyGroupRouter from "./routes/groups.js";
import searchRouter from "./routes/search.js";

const app = express();
const port = 8080;

app.use(cors());
app.use(express.json());

app.use('/api/auth', authRouter);
app.use('/api/students', studentRouter);
app.use('/api/groups', studyGroupRouter);
app.use('/api/search', searchRouter);

app.listen(port, () => {
    console.log("Server is listening on port 8080.");
});