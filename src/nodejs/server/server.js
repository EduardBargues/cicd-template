// Express App Setup
const express = require("express");
const http = require("http");
const cors = require("cors");

// Initialization
const app = express();
app.use(cors());
app.get("/health-check", (req, res) => {
  res.send("health-check OK !!!!!");
});

app.get("/nodejs-server", (req, res) => {
  res.send(
    "Greetings from a nodejs+express app! nodejs-server endpoint in the container reached :)"
  );
});

// Server
const port = process.env.PORT || 8080;
const server = http.createServer(app);
server.listen(port, () => console.log(`Server running on port ${port}`));
