require('dotenv').config(
    {
        path: `.env.${process.env.NODE_ENV}`
    }
);
const Server = require('./app/models/Server');

const server = new Server();
server.listen();
