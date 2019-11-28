FROM ruby:2.6.4
RUN apt-get update -qq && apt-get install -y nodejs npm
RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp
RUN npm install yarn -g

RUN RAILS_ENV=production rails assets:clobber
RUN RAILS_ENV=production rails assets:precompile
RUN RAILS_ENV=production rails db:create db:migrate
# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000


# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]