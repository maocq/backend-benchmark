defmodule ElixirMs.Helpers.CustomTelemetry do
  @moduledoc false

  alias ElixirMs.Utils.DataTypeUtils
  import Telemetry.Metrics

  @service_name "fua_credentials"

  def custom_telemetry_events() do
    :telemetry.attach(
      "fua-ecto",
      [:elixir_ms, :adapters, :repositories, :repo, :query],
      &handle_custom_event/4,
      nil
    )

    :telemetry.attach("fua-plug-stop", [:elixir_ms, :plug, :stop], &handle_custom_event/4, nil)
    :telemetry.attach("fua-redis-stop", [:redix, :pipeline, :stop], &handle_custom_event/4, nil)
    :telemetry.attach("fua_session-vm-memory", [:vm, :memory], &handle_custom_event/4, nil)
    :telemetry.attach("vm-total_run_queue_lengths", [:vm, :total_run_queue_lengths], &handle_custom_event/4, nil)
    :telemetry.attach("rcommons-success", [:async, :message, :completed], &handle_custom_event/4, nil)
    :telemetry.attach("rcommons-event-failure", [:async, :event, :failure], &handle_custom_event/4, nil)
    :telemetry.attach("rcommons-command-failure", [:async, :command, :failure], &handle_custom_event/4, nil)
    :telemetry.attach("rcommons-query-failure", [:async, :query, :failure], &handle_custom_event/4, nil)
  end

  def execute_custom_event(metric, value, metadata \\ %{})
  def execute_custom_event(metric, value, metadata) when is_list(metric) do
    metadata = Map.put(metadata, :service, @service_name)
    :telemetry.execute([:elixir | metric], %{duration: value}, metadata)
  end
  def execute_custom_event(metric, value, metadata) when is_atom(metric) do
    execute_custom_event([metric], value, metadata)
  end

  defp handle_custom_event([:elixir_ms, :adapters, :repositories, :repo, :query], measures, metadata, _) do
    :telemetry.execute(
      [:elixir, :db, :query],
      %{duration: DataTypeUtils.system_time_to_milliseconds(measures.total_time)},
      %{source: metadata.source, service: @service_name}
    )
  end

  defp handle_custom_event([:elixir_ms, :plug, :stop], measures, metadata, _) do
    :telemetry.execute(
      [:elixir, :http_request_duration_milliseconds],
      %{duration: DataTypeUtils.monotonic_time_to_milliseconds(measures.duration)},
      %{request_path: metadata.conn.request_path, service: @service_name}
    )
  end

  defp handle_custom_event([:redix, :pipeline, :stop], measures, metadata, _) do
    :telemetry.execute(
      [:elixir, :redis_request],
      %{duration: DataTypeUtils.monotonic_time_to_milliseconds(measures.duration)},
      %{commands: List.first(List.first(metadata.commands)), service: @service_name}
    )
  end

  defp handle_custom_event(metric, measures, metadata, _) do
    metadata = Map.put(metadata, :service, @service_name)
    :telemetry.execute([:elixir | metric], measures, metadata)
  end

  def metrics do
    [
      #Http
      counter("elixir.http_outgoing_request.count", tags: [:service, :request_path, :status]),
      sum("elixir.http_outgoing_request.duration", tags: [:service, :request_path, :status]),

      # Plug Metrics
      counter("elixir.http_request_duration_milliseconds.count", tags: [:request_path, :service]),
      sum("elixir.http_request_duration_milliseconds.duration", tags: [:request_path, :service]),

      # Ecto
      sum("elixir.db.query.duration", tags: [:source, :service]),
      counter("elixir.db.query.count", tags: [:source, :service]),

      #Redis
      counter("elixir.redis_request.count", tags: [:commands, :service]),
      sum("elixir.redis_request.duration", tags: [:commands, :service]),

      #Reactive Commons
      counter("elixir.async.message.completed.count", tags: [:transaction, :result, :service]),
      sum("elixir.async.message.completed.duration", tags: [:transaction, :result, :service]),

      counter("elixir.async.command.failure.count", tags: [:service]),
      sum("elixir.async.command.failure.duration", tags: [:service]),

      counter("elixir.async.event.failure.count", tags: [:service]),
      sum("elixir.async.event.failure.duration", tags: [:service]),

      counter("elixir.async.query.failure.count", tags: [:service]),
      sum("elixir.async.query.failure.duration", tags: [:service]),

      # VM Metrics
      last_value("elixir.vm.memory.total", unit: {:byte, :kilobyte}, tags: [:service]),
      sum("elixir.vm.total_run_queue_lengths.total", tags: [:service]),
      sum("elixir.vm.total_run_queue_lengths.cpu", tags: [:service]),
      sum("elixir.vm.total_run_queue_lengths.io", tags: [:service])
    ]
  end
end
