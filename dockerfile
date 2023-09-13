# Base image
FROM node:18 as build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the entire project directory
COPY . .

# Build the Angular app
RUN npm run build --prod

# Stage 2: Use a lightweight image for serving the app
FROM nginx:1.21.0-alpine

# Copy the built app from the previous stage
COPY --from=build /app/dist/front /usr/share/nginx/html

# Expose the default port for serving Angular apps
EXPOSE 80

# Start the Nginx server
CMD ["nginx", "-g", "daemon off;"]