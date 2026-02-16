FROM nginx:alpine

# Remove default config
RUN rm /etc/nginx/conf.d/default.conf

# Copy our custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy website files (don't use COPY . because it will copy nginx.conf to wrong place)
COPY index.html /usr/share/nginx/html/
# If you have other files, add them:
# COPY styles.css /usr/share/nginx/html/
# COPY script.js /usr/share/nginx/html/

EXPOSE 8080
