defmodule Kalevala.Character.Command.RouterTest do
  use ExUnit.Case

  defmodule Router do
    use Kalevala.Character.Command.Router, scope: TestGame

    module(GetCommand) do
      parse("get", :run, fn command ->
        command
        |> text(:item)
        |> optional(preposition("from", :container))
      end)
    end

    module(GiveCommand) do
      parse("give", :run, fn command ->
        command
        |> text(:item, trim: true)
        |> repeat(
          choice([
            preposition("from", :container),
            preposition("to", :character)
          ])
        )
      end)
    end

    module(MoveCommand) do
      parse("north", :run, aliases: ["n"])
      parse("south", :run, aliases: ["s"])
    end

    module(SayCommand) do
      parse("say", :run, fn command ->
        command
        |> spaces()
        |> optional(
          symbol(">")
          |> word(:at)
          |> spaces()
        )
        |> text(:message)
      end)
    end

    module(TellCommand) do
      parse("tell", :run, fn command ->
        command
        |> spaces()
        |> word(:name)
        |> spaces()
        |> text(:message)
      end)
    end

    module(WalkCommand) do
      parse("walk", :run, fn command ->
        command
        |> spaces()
        |> repeat(
          choice([
            preposition("in", :in),
            preposition("on", :on),
            preposition("by", :by)
          ])
        )
      end)
    end
  end

  describe "parsing commands" do
    test "a simple command" do
      {:ok, parsed_command} = Router.parse("north")

      assert parsed_command.module == TestGame.MoveCommand
      assert parsed_command.function == :run

      assert parsed_command.params == %{
               "command" => "north"
             }
    end

    test "a command with a single variable" do
      {:ok, parsed_command} = Router.parse("say hello there")

      assert parsed_command.module == TestGame.SayCommand
      assert parsed_command.function == :run

      assert parsed_command.params == %{
               "command" => "say",
               "message" => "hello there"
             }
    end

    test "a command with an optional word" do
      {:ok, parsed_command} = Router.parse("say >villager hello there")

      assert parsed_command.params == %{
               "command" => "say",
               "at" => "villager",
               "message" => "hello there"
             }

      {:ok, parsed_command} = Router.parse("say >\"town crier\" hello there")

      assert parsed_command.params == %{
               "command" => "say",
               "at" => "town crier",
               "message" => "hello there"
             }
    end

    test "a command with a word before text" do
      {:ok, parsed_command} = Router.parse("tell villager hello")

      assert parsed_command.module == TestGame.TellCommand
      assert parsed_command.function == :run

      assert parsed_command.params == %{
               "command" => "tell",
               "name" => "villager",
               "message" => "hello"
             }
    end

    test "a command with a quoted word before text" do
      {:ok, parsed_command} = Router.parse("tell \"town crier\" hello")

      assert parsed_command.module == TestGame.TellCommand
      assert parsed_command.function == :run

      assert parsed_command.params == %{
               "command" => "tell",
               "name" => "town crier",
               "message" => "hello"
             }
    end

    test "a command with an alias" do
      {:ok, parsed_command} = Router.parse("n")

      assert parsed_command.module == TestGame.MoveCommand
      assert parsed_command.function == :run

      assert parsed_command.params == %{
               "command" => "north"
             }
    end

    test "failure: simple commands aren't caught when partially matching" do
      # not finding the alias for `n`
      {:error, :unknown} = Router.parse("nope")

      # not finding `north`
      {:error, :unknown} = Router.parse("northward")
      {:error, :unknown} = Router.parse("north is a direction")
    end
  end

  describe "text globbing" do
    test "a command using only one text section" do
      {:ok, parsed_command} = Router.parse("get silver sword")

      assert parsed_command.module == TestGame.GetCommand
      assert parsed_command.function == :run

      assert parsed_command.params == %{
               "command" => "get",
               "item" => "silver sword"
             }
    end

    test "a command with multiple text sections" do
      {:ok, parsed_command} = Router.parse("get silver sword from large crate")

      assert parsed_command.module == TestGame.GetCommand
      assert parsed_command.function == :run

      assert parsed_command.params == %{
               "command" => "get",
               "item" => "silver sword",
               "container" => "large crate"
             }
    end

    test "a command with multiple stops" do
      {:ok, parsed_command} = Router.parse("give silver sword from bag to merchant")

      assert parsed_command.module == TestGame.GiveCommand
      assert parsed_command.function == :run

      assert parsed_command.params == %{
               "command" => "give",
               "item" => "silver sword",
               "container" => "bag",
               "character" => "merchant"
             }

      # Flipping the order
      {:ok, parsed_command} = Router.parse("give silver sword to merchant from bag")

      assert parsed_command.params == %{
               "command" => "give",
               "item" => "silver sword",
               "container" => "bag",
               "character" => "merchant"
             }
    end
  end

  describe "prepositional phrases" do
    test "walk command with many prepositions" do
      {:ok, parsed_command} = Router.parse("walk in the house on the lake by the river")

      assert parsed_command.module == TestGame.WalkCommand
      assert parsed_command.function == :run

      assert parsed_command.params == %{
               "command" => "walk",
               "in" => "the house",
               "on" => "the lake",
               "by" => "the river"
             }
    end
  end
end
