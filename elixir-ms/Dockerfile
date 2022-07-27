FROM elixir:1.13.4-alpine
ENV MIX_ENV=prod
WORKDIR /app
RUN apk add build-base git && mix local.hex --force && mix local.rebar --force
COPY mix.exs mix.lock ./
RUN mix deps.get && mix deps.compile
COPY . .
RUN mix distillery.release #&& rm -rf /app/_build/prod/rel/elixir_ms/etc

FROM elixir:1.13.4-alpine
ENV MIX_ENV=prod
WORKDIR /app
EXPOSE 8080
RUN apk update && apk upgrade && apk add bash && mkdir -p /app/rel/elixir_ms/var
COPY --from=0 /app/_build/prod /app
COPY --from=0 /app/config /app/rel/elixir_ms/etc

#VOLUME /app/rel/elixir_ms/etc
#RUN chown #{elixir_user}#:#{elixir_user}# -R /app/rel/elixir_ms/
#USER #{elixir_user}#


#docker exec -it elixir-ms sh
#./rel/elixir_ms/bin/elixir_ms remote_console

ENTRYPOINT exec /app/rel/elixir_ms/bin/elixir_ms foreground