defmodule Lumberjack.BranchManager do
  use GenServer.Behaviour

  def start_link do
    IO.puts "Starting BranchManager..."
    :gen_server.start_link(__MODULE__, [], [])
  end

  def init(_args) do
    branches = branch_names
    |> Enum.map &create_branch(&1)
    IO.puts "BranchManager started"
    seed_commits(branches)
    commits = Enum.map branches, &:gen_server.call(&1, :commits)
    IO.inspect commits
    {:ok, branches}
  end

  defp create_branch(branch_name) do
    {:ok, branch} = Lumberjack.Branch.start_link(branch_name)
    branch
  end

  def seed_commits(branches) do
    Lumberjack.Commit.all
    |> add_commits_to_branches(branches)
    {:noreply, branches}
  end

  defp add_commits_to_branches(commits, branches) do
    Enum.map commits, &add_commit_to_branches(&1, branches)
  end

  defp add_commit_to_branches(commit, branches) do
    Enum.map branches, &add_commit_to_branch(commit, &1)
  end

  defp add_commit_to_branch(commit, branch) do
    :gen_server.cast branch, {:push_commit, commit}
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
