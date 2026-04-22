# Use a lightweight Nginx image
FROM nginx:stable-alpine

# Copy the pre-existing build folder content to the Nginx html directory
COPY build/ /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
