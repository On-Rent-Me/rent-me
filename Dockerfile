# Stage 1: Build dependencies
FROM ruby:3.4.6 as build

# Install build dependencies
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev && \
    rm -rf /var/lib/apt/lists/*

# Install bundler
RUN gem install bundler

# Set the working directory inside the container
WORKDIR /app

# Copy the Gemfile and Gemfile.lock to leverage Docker cache
COPY Gemfile Gemfile.lock ./

# Configure bundler to use precompiled gems
RUN bundle config set --local force_ruby_platform false

# Install gems into a vendor directory
RUN bundle install --path vendor/bundle

# Stage 2: Production image
FROM ruby:3.4.6-slim

# Install runtime dependencies
RUN apt-get update -qq && \
    apt-get install -y libpq5 && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /app

# Copy the vendored gems from the build stage
COPY --from=build /app/vendor/bundle /app/vendor/bundle

# Copy the rest of the application code
COPY . .

# Set environment variables for Ruby
ENV BUNDLE_PATH=/app/vendor/bundle \
    BUNDLE_APP_CONFIG=/app/vendor/bundle \
    BUNDLE_BIN=/app/vendor/bundle/bin

# Precompile assets for production
RUN bundle exec rails assets:precompile

# Set the command to run your application with database setup
CMD ["sh", "-c", "bundle exec rails db:prepare && bundle exec puma -C config/puma.rb"]

# Expose the port your application listens on
EXPOSE 8080
