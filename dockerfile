# 1. Use official Node.js image
FROM node:18

# 2. Create app directory inside container
WORKDIR /app

# 3. Copy package files first (for faster builds)
COPY package*.json ./

# 4. Install dependencies
RUN npm install

# 5. Copy rest of the application code
COPY . .

# 6. Tell Docker which port the app uses
EXPOSE 3002

# 7. Start the application
CMD ["npm", "start"]
