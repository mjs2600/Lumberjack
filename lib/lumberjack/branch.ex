defmodule Lumberjack.Branch do
  use GenServer.Behaviour

  def start_link(branch_name) do
    IO.puts "Tracking Branch #{branch_name}..."
    :gen_server.start_link(__MODULE__, [branch_name], [])
  end

  def init(branch_name) do
    {:ok, {String.from_char_list!(branch_name), []}}
  end

  def handle_call(:commits, _from, {branch_name, commits}) do
    {:reply, commits, {branch_name, commits}}
  end

  def handle_call(request, from, config) do
    super(request, from, config)
  end

  def handle_cast({:push_commit, commit}, {branch_name, commits}) do
    updated_commits = add_commit(commit, commits, branch_name)
    {:noreply, {branch_name, updated_commits}}
  end

  def handle_cast(request, config) do
    super(request, config)
  end

  defp add_commit(commit, commits, branch_name) do
    if commit_on_branch?(commit, branch_name) do
      [commit | commits]
    else
      commits
    end
  end

  defp commit_on_branch?(commit, branch_name) do
    branches = System.cmd("git branch --contains #{commit}")
    IO.inspect branches
    IO.inspect branch_name
    String.contains? branches, branch_name
  end
end
