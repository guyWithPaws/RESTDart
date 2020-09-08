FROM google/dart

WORKDIR /app

ADD pubspec.* /app/
RUN pub get
ADD . /app
RUN pub get --offline

ENV PORT 8080
CMD []
ENTRYPOINT ["/usr/bin/dart", "bin/server.dart"]