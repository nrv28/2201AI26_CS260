# Use official Node.js image as base
FROM node:latest

# Create and set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application files
COPY Main.js ./
COPY public ./public
COPY routes ./routes
COPY views ./views

# Expose the port on which the app runs (if app
EXPOSE 3000

# Command to run the application
CMD ["node", "Main.js"]
