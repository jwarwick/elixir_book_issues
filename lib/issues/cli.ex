defmodule Issues.CLI do
  @default_count 4

  @moduledoc """
  Handle the command line parsing and the dispatch to
the various functions that end up generating a table
of the last _n_ issues in a github project
"""
def run(argv) do
  argv
  |> parse_args
  |> process
end

@doc """
'argv' can be - or --help, which returns :help.

Otherwise it is a github  user name, project name, ad (optionally)
the number of entries to format

Return a tuple of '{user, project, count}', or ':help' if help was given.
"""

def parse_args(argv) do
  parse = OptionParser.parse(argv, switches: [help: :boolean],
  aliases: [h: :help])
    case parse do
      { [help: true], _ } -> :help
      { _, [user, project, count] } -> {user, project, binary_to_integer count}
      {_, [user, project] } -> {user, project, @default_count}
      _ -> :help
    end
  end

def process(:help) do
  IO.puts """
  usage: issues <user> <project> [count | #{@default_count}]
    """
    System.halt(0)
  end

def process({user, project, count}) do
  Issues.GithubIssues.fetch(user, project)
end

end



