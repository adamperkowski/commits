FROM alpine:latest
RUN apk add --no-cache git bash
COPY check-commit-message.sh /usr/local/bin/check-commit-message
RUN chmod +x /usr/local/bin/check-commit-message
LABEL org.opencontainers.image.source=https://codeberg.org/koibtw/commits
