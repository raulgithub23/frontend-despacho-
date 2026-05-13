# STAGE 1 - BUILD
FROM node:20-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci --frozen-lockfile
COPY . .

ARG VITE_API_URL=http://localhost:8081
ENV VITE_API_URL=$VITE_API_URL
RUN npm run build

# STAGE 2 - RUNTIME
FROM nginx:1.25-alpine AS runtime

RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/app.conf
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]