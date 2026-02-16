FROM nginx:alpine
# Remove default config
RUN rm /etc/nginx/conf.d/default.conf
# Copy our custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf
# Copy website files
COPY index.html /usr/share/nginx/html/
COPY index.css /usr/share/nginx/html/
COPY index.js /usr/share/nginx/html/
EXPOSE 8080
