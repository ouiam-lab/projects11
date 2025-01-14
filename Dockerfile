# Stage 1: Build the React application
FROM node:18 AS build
WORKDIR /app

# Copy package files and install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy the rest of the source code into the container
COPY . .

# Build the Vite project for production
RUN npm run build

# Stage 2: Serve the application with Nginx
FROM nginx:stable-alpine
WORKDIR /usr/share/nginx/html

# Clean default Nginx files
RUN rm -rf ./*

# Copy the React build files from the first stage
COPY --from=build /app/dist .

# Expose the default Nginx port
EXPOSE 80
# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
