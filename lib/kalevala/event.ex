defmodule Kalevala.Event.Metadata do
  @moduledoc """
  Metadata for an event, used for telemetry
  """

  defstruct [:start_time, :end_time]
end

defmodule Kalevala.Event.Message do
  @moduledoc """
  Struct for sending a message
  """

  @type t() :: %__MODULE__{}

  defstruct [:channel_name, :character, :id, :text, meta: %{}, type: "speech"]

  @doc """
  Generate a random ID
  """
  def generate_id() do
    bytes =
      Enum.reduce(1..8, <<>>, fn _, bytes ->
        bytes <> <<Enum.random(0..255)>>
      end)

    Base.encode16(bytes, case: :lower)
  end
end

defmodule Kalevala.Event do
  @moduledoc """
  An internal event
  """

  @type t() :: %__MODULE__{}

  @type item_request_drop() :: %__MODULE__{
          topic: __MODULE__.ItemDrop.Request
        }

  @type item_request_pickup() :: %__MODULE__{
          topic: __MODULE__.ItemPickUp.Request
        }

  @type movement_request() :: %__MODULE__{
          topic: __MODULE__.Movement.Request
        }

  @type movement_voting() :: %__MODULE__{
          topic: __MODULE__.Movement.Voting
        }

  @type message() :: %__MODULE__{
          topic: __MODULE__.Message
        }

  @type topic() :: String.t()

  defstruct [:acting_character, :data, :from_pid, :topic, metadata: %__MODULE__.Metadata{}]

  @doc """
  Set the start time on an event
  """
  def set_start_time(event) do
    update_metadata(event, %{event.metadata | start_time: System.monotonic_time()})
  end

  @doc """
  Set the end time on an event
  """
  def set_end_time(event) do
    update_metadata(event, %{event.metadata | end_time: System.monotonic_time()})
  end

  @doc """
  Timing for an event in microseconds
  """
  def timing(event) do
    event.metadata.end_time - event.metadata.start_time
  end

  defp update_metadata(event, metadata) do
    %{event | metadata: metadata}
  end
end

defmodule Kalevala.Event.Delayed do
  @moduledoc """
  Struct for sending a message
  """

  @type t() :: %__MODULE__{}

  defstruct [
    :acting_character,
    :data,
    :delay,
    :from_pid,
    :topic,
    metadata: %Kalevala.Event.Metadata{}
  ]

  @doc """
  Turn a delayed event into a stanard event
  """
  def to_event(delayed_event) do
    %Kalevala.Event{
      acting_character: delayed_event.acting_character,
      data: delayed_event.data,
      from_pid: delayed_event.from_pid,
      topic: delayed_event.topic,
      metadata: delayed_event.metadata
    }
  end
end

defmodule Kalevala.Event.Display do
  @moduledoc """
  An event to display text/data back to the user
  """

  defstruct output: [], options: []
end
