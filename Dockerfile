FROM node:22-bookworm-slim AS build
WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

FROM node:22-bookworm-slim AS runner
WORKDIR /app
ENV NODE_ENV=production

COPY package*.json ./
RUN npm ci --omit=dev

# Your build script emits server bundle + client assets into dist/
COPY --from=build /app/dist ./dist

# Keep shared available at runtime (harmless; some setups read it)
COPY --from=build /app/shared ./shared

EXPOSE 5000

CMD ["npm", "start"]
