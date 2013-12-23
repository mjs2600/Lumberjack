defmodule Lumberjack.BranchManager do
  use GenServer.Behaviour

  def start_link do
    IO.puts "Starting BranchManager..."
    :gen_server.start_link(__MODULE__, [], [])
  end

  def init(_args) do
    branches = branch_names
    |> Enum.map fn(branch) -> Lumberjack.Branch.start_link(branch) end
    IO.puts "BranchManager started"
    seed_commits(branches)
    {:ok, branches}
  end

  def seed_commits(branches) do
    Lumberjack.Commit.all
    |> Enum.map fn(commit) -> 
                    Enum.map branches,
                         fn(branch) ->
                             :gen_server.cast branch,
                                         {:push_commit, commit}
                         end
                end
    {:noreply, branches}
  end

  defp branch_names do
    :git.branches("./")
  end

  def handle_call(request, from, config) do
    super(request, from, config)
  end

  def handle_cast(request, config) do
    super(request, config)
  end
end
