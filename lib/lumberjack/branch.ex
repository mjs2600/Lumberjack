defmodule Lumberjack.Branch do
  use GenServer.Behaviour

  def start_link(branch) do
    IO.puts "Tracking Branch #{branch}..."
    :gen_server.start_link(__MODULE__, [branch], [])
  end

  def init(branch) do
    IO.puts branch
    {:ok, {branch, []}}
  end

  def handle_call(request, from, config) do
    super(request, from, config)
  end

  def handle_cast(request, config) do
    super(request, config)
  end
end
