FROM dannyben/alpine-ruby:4.0

RUN gem install mockly -v 0.0.1

WORKDIR /app

VOLUME /app/mocks

EXPOSE 3000

ENTRYPOINT ["mockly"]