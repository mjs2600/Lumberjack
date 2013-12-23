defmodule Lumberjack.Branch do
  use GenServer.Behaviour

  def start_link(branch_name) do
    IO.puts "Tracking Branch #{branch_name}..."
    :gen_server.start_link(__MODULE__, [branch_name], [])
  end

  def init(branch_name) do
    IO.puts branch_name
    {:ok, {branch_name, []}}
  end

  def handle_call(request, from, config) do
    super(request, from, config)
  end

  def handle_cast({:push_commit, commit}, {branch_name, commits}) do
    {:noreply, {branch_name, [commit | commits]}}
  end

  def handle_cast(request, config) do
    super(request, config)
  end
end
