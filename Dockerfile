# Use multi-stage builds to reduce final image size

# Builder stage
FROM node:20 AS builder

WORKDIR /app

# Copy only package files for dependency installation
COPY package.json package-lock.json ./
RUN npm ci

# Copy the rest of the application code
COPY . .

# Build the application
RUN npm run build

# Runner stage
FROM node:20 AS runner

WORKDIR /app

# Copy built application from builder stage
COPY --from=builder /app/build ./build  # Change this to where your build output is located

# Install production dependencies only
COPY package.json package-lock.json ./
RUN npm ci --only=production  # Use --only=production to avoid installing dev dependencies

# Expose the application port
EXPOSE 3000

# Command to run the application
CMD ["node", "build/index.js"]
