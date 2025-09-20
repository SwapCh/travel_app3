// server/server.js
const express = require("express");
const cors = require("cors");
const axios = require("axios");

const app = express();
app.use(cors());
app.use(express.json());

const PORT = 3000;

// Gemini API key
const GEMINI_API_KEY = "AIzaSyAmGiVTEhYbDmBPeSNu7rDjgvbaG9QptUc";

app.post("/chat", async (req, res) => {
  const { message } = req.body;
  if (!message) return res.status(400).json({ error: "Message required" });

  try {
    const response = await axios.post(
      `https://generativelanguage.googleapis.com/v1beta2/models/text-bison-001:generate?key=${GEMINI_API_KEY}`,
      {
        prompt: { text: message },
        temperature: 0.7,
        maxOutputTokens: 200,
      },
      {
        headers: { "Content-Type": "application/json" },
      }
    );

    const botReply = response.data.candidates?.[0]?.content || "Sorry, I couldn't respond.";
    res.json({ reply: botReply });
  } catch (error) {
    console.error(error.response?.data || error.message);
    res.status(500).json({ error: "Failed to get response from Gemini API" });
  }
});

app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
