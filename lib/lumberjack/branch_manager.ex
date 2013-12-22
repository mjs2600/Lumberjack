defmodule Lumberjack.BranchManager do
  use GenServer.Behaviour

  def start_link do
    IO.puts "Starting BranchManager..."
    :gen_server.start_link(__MODULE__, [], [])
  end

  def init(_args) do
    IO.puts "BranchManager started"
    {:ok, []}
  end
end
