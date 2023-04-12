defmodule Kalevala.ForemanTest do
  use ExUnit.Case

  alias Kalevala.Character.Conn
  alias Kalevala.Character.Foreman

  describe "handling the conn" do
    test "prints text" do
      conn = setup_conn(["Text"])
      state = setup_state()

      {:noreply, _state} = Foreman.handle_conn(conn, state)

      assert_receive {:send, %Conn.Text{data: ["Text"]}}
    end

    test "handles halting" do
      conn = setup_conn()
      state = setup_state()

      conn = Conn.halt(conn)

      {:noreply, _state} = Foreman.handle_conn(conn, state)

      assert_receive :terminate
    end

    test "transitions to the next controller" do
      conn = setup_conn()
      state = setup_state()

      conn = Conn.put_controller(conn, ExampleController)

      {:noreply, state, {:continue, :init_controller}} = Foreman.handle_conn(conn, state)

      assert state.controller == ExampleController
    end

    test "resets the flash state" do
      conn = setup_conn()
      state = setup_state()

      conn = Conn.put_flash(conn, :key, "value")
      conn = Conn.put_controller(conn, ExampleController)
      {:noreply, state, {:continue, :init_controller}} = Foreman.handle_conn(conn, state)

      assert state.flash == %{}
    end
  end

  defp setup_conn() do
    %Conn{}
  end

  defp setup_conn(text) do
    %Conn{
      output: [%Conn.Text{data: text}]
    }
  end

  defp setup_state() do
    %Foreman{
      callback_module: Foreman.Player,
      private: %Foreman.Player{
        protocol: self()
      }
    }
  end
end
