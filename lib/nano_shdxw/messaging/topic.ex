defmodule NanoShdxw.Messaging.Topic do
  use Ecto.Schema
  import Ecto.Changeset

  schema "topics" do
    field :link, :string
    # field :id_user, :integer
    field :titre, :string

    has_many :messages, NanoShdxw.Messaging.Message
    many_to_many :users, NanoShdxw.Accounts.User, join_through: "users_topics"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(topic, attrs) do
    topic
    |> cast(attrs, [:id_message, :titre, :link])
    |> validate_required([:link])
  end
end
