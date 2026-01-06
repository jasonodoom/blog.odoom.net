# build stage
FROM hugomods/hugo:exts AS builder

ARG NIX_STORE_PATH
ENV NIX_STORE_PATH=$NIX_STORE_PATH

WORKDIR /app
COPY hugo-site /app

# Clone Paper theme if not already present
RUN apk add --no-cache git npm && \
    if [ ! -d "themes/paper/.git" ]; then \
      git clone https://github.com/nanxiaobei/hugo-paper.git themes/paper; \
    fi

RUN hugo --minify

# Build pagefind search index
RUN npx pagefind --site public

# production stage
FROM nginx:alpine

COPY --from=builder /app/public /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
