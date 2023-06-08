#!/bin/sh

# Install all the dependencies for the project
npm install --legacy-peer-deps

# Create .env file if it doesn't exist
if [ ! -f ".env.production" ]; then
    touch .env.production
    # Append the env schema
    echo "Generating the .env file..."
    cat <<EOF >> .env.production
PORT=3000
#
## JWT
#

JWT_SECRET=



#
## DBConnection deployed  -  use this.
#

DATABASE_HOST=localhost
DATABASE_PORT=3306
DATABASE_NAME=hunkydorycode
DATABASE_USER=root
DATABASE_PASSWORD=root



#
# SMTP 
#

SMTP_PORT=
SMTP_HOST=
SMTP_USER=
SMTP_PASS=


#
## Firebase Auth
#

FIREBASE_APIKEY=
FIREBASE_AUTHDOMAIN=
FIREBASE_PROJECTID=
FIREBASE_STORAGEBUCKET=
FIREBASE_MESSAGINGSENDERID=
FIREBASE_APPID=
FIREBASE_MEASUREMENTID=


#
## Cloudinary config
#

CLOUDINARY_URL=

#
## REDIS config
#
REDIS_HOSTNAME=
REDIS_PORT=
REDIS_PASSWORD=
EOF
fi