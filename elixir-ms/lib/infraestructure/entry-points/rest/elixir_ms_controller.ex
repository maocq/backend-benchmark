defmodule ElixirMs.EntryPoint.Rest.ElixirMsController do
  alias ElixirMs.UseCase.CasesUseCase
  alias ElixirMs.UseCase.GetAccountUseCase
  alias ElixirMs.UseCase.GetHelloUseCase
  alias ElixirMs.UseCase.GetPrimesUseCase

  use Plug.Router
  use Plug.ErrorHandler

  require Logger

  plug(CORSPlug,
    methods: ["GET", "POST"],
    origin: [~r/.*/],
    headers: ["Content-Type", "Accept", "User-Agent"]
  )

  plug(Plug.Logger, log: :debug)
  plug(Plug.Parsers, parsers: [:urlencoded, :json], json_decoder: Poison)
  plug(:match)
  plug(:dispatch)

  get "/api/hello" do
    "Hello"
    |> build_response(conn)
  end

  get "/api/case-one" do
    latency = conn.query_params["latency"] || 0

    case CasesUseCase.case_one(latency) do
      {:ok, response} -> response |> build_response(conn)
      {:error, error} ->
        Logger.error("Error case one #{inspect(error)}")
        build_response(%{status: 500, body: "Error"}, conn)
    end
  end

  get "/api/case-two" do
    latency = conn.query_params["latency"] || 0

    case CasesUseCase.case_two(latency) do
      {:ok, response} -> response |> build_response(conn)
      {:error, error} ->
        Logger.error("Error case two #{inspect(error)}")
        build_response(%{status: 500, body: "Error"}, conn)
    end
  end

  get "/api/case-three" do
    CasesUseCase.case_three()
    |> build_response(conn)
  end

  get "/api/find-by-id" do
    GetAccountUseCase.find_by_id(4000)
    |> build_response(conn)
  end

  get "/api/find-one" do
    GetAccountUseCase.find_one()
    |> build_response(conn)
  end

  get "/api/find-multiple-one" do
    GetAccountUseCase.find_multiple_one()
    |> build_response(conn)
  end

  get "/api/find-test" do
    GetAccountUseCase.find_test()
    |> build_response(conn)
  end

  get "/api/find-multiple-test" do
    GetAccountUseCase.find_multiple_test()
    |> build_response(conn)
  end

  get "/api/findall" do
    GetAccountUseCase.find_all()
    |> build_response(conn)
  end

  get "/api/get-hello" do
    latency = conn.query_params["latency"] || 0

    case GetHelloUseCase.handle(latency) do
      {:ok, response} -> response |> build_response(conn)
      {:error, error} ->
        Logger.error("Error get hello #{inspect(error)}")
        build_response(%{status: 500, body: "Error"}, conn)
    end
  end

  get "/api/get-multiple-hello" do
    case GetHelloUseCase.handle_multiple() do
      {:ok, response} -> response |> build_response(conn)
      {:error, error} ->
        Logger.error("Error get hello #{inspect(error)}")
        build_response(%{status: 500, body: "Error"}, conn)
    end
  end

  get "/api/primes" do
    GetPrimesUseCase.get_primes_list(1000)
    |> build_response(conn)
  end

  match _ do
    %{request_path: path} = conn
    build_response(%{status: 404, body: %{status: 404, path: path}}, conn)
  end

  def build_response(%{status: status, body: body}, conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Poison.encode!(body))
  end

  def build_response(response, conn), do: build_response(%{status: 200, body: response}, conn)

  @impl Plug.ErrorHandler
  def handle_errors(conn, error) do
    Logger.error("Internal server - #{inspect(error)}")
    build_response(%{status: 500, body: %{status: 500, error: "Internal server"}}, conn)
  end

end
