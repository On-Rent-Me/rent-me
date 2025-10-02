# Stage 1: Build dependencies
FROM ruby:3.4.6 as build

# Install bundler
RUN gem install bundler

# Set the working directory inside the container
WORKDIR /app

# Copy the Gemfile and Gemfile.lock to leverage Docker cache
COPY Gemfile Gemfile.lock ./

# Install gems into a vendor directory
RUN bundle install --path vendor/bundle

# Stage 2: Production image
FROM ruby:3.4.6-slim

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

# Set the command to run your application.
# For example, a basic Rack app with Puma on port 8080.
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

# Expose the port your application listens on
EXPOSE 8080
