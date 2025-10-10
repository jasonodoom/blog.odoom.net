# build stage
FROM hugomods/hugo:exts AS builder

WORKDIR /app
COPY hugo-site /app
RUN hugo --minify

# production stage
FROM nginx:alpine

COPY --from=builder /app/public /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
