defmodule NanoShdxw.Messaging.StartConversation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "start_conversations" do


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(start_conversation, attrs) do
    start_conversation
    |> cast(attrs, [])
    |> validate_required([])
  end
end
