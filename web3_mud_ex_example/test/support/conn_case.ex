defmodule Web3MudExExample.ConnTest do
  @moduledoc false

  alias Web3MudExExample.Brain

  def process_output(conn) do
    processors = [
      Kalevala.Output.Tags,
      Kalevala.Output.Tables,
      Kalevala.Output.StripTags
    ]

    Kalevala.ConnTest.process_output(conn, processors)
  end

  def process_brain(brain_name) do
    Brain.load_all()
    |> Brain.process_all()
    |> Map.get(brain_name)
  end
end

defmodule Web3MudExExample.ConnCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      import Kalevala.Character.Conn
      import Kalevala.ConnTest
      import Web3MudExExample.ConnTest
    end
  end
end
