defmodule NanoShdxw.Messaging.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :content, :string
    belongs_to :sender, NanoShdxw.Accounts.User
    belongs_to :receiver, NanoShdxw.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :sender_id, :receiver_id])
    |> validate_required([:content, :sender_id, :receiver_id])
  end
end
