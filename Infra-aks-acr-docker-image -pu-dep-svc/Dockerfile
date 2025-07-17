# Base nginx image
FROM nginx:alpine

# Copy custom nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Copy static app files to nginx html directory
COPY app/ /usr/share/nginx/html/

# Expose HTTP port
EXPOSE 80
