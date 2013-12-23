defmodule Lumberjack.Commit do
  def all do
    System.cmd("git rev-list --all")
    |> String.split
  end
end