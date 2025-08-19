FROM node@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8ca09d9e AS builder
WORKDIR /app
COPY . .

FROM nginx@sha256:d67ea0d64d518b1bb04acde3b00f722ac3e9764b3209a9b0a98924ba35e4b779

RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

RUN chown -R appuser:appgroup /usr/share/nginx/html

WORKDIR /usr/share/nginx/html
COPY --from=builder /app ./


USER appuser

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
