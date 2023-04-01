const express = require('express');
const cors = require('cors');
const fileupload = require('express-fileupload');

class Server {

    constructor(){
        this.app = express();
        this.port = process.env.PORT;
        this.paths = {
            auth:         '/api/v1/auth',
            users:        '/api/v1/users',
        };
        this.middlewares();
        this.routes();
    }

    middlewares(){
        // CORS
        this.app.use( cors() );

        // Body Parser
        this.app.use( express.json() );

        // Public
        this.app.use( express.static( 'public' ) );

        // File Upload
        this.app.use( fileupload( {
            useTempFiles: true,
            tempFileDir: '/tmp/',
            createParentPath: true,
        } ) );
    }

    routes(){
        // this.app.use( '/', require('./routes/index') );
        this.app.use( this.paths.auth, require('../routes/auth.routes') );
        this.app.use( this.paths.users, require('../routes/users.routes') );
    }

    listen(){
        this.app.listen( this.port, () => {
            console.log(`Server running on port ${ this.port }`);
        } );
    }
}

module.exports = Server;