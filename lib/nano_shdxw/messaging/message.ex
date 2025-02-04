defmodule NanoShdxw.Messaging.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :content, :string
    field :title, :string
    field :message_date, :utc_datetime
    field :link, :string
    belongs_to :sender, NanoShdxw.Accounts.User
    belongs_to :receiver, NanoShdxw.Accounts.User
    belongs_to :topic, NanoShdxw.Messaging.Topic

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :sender_id, :receiver_id, :link, :message_date])
    |> validate_required([:sender_id, :receiver_id])
    |> put_message_date()
    |> put_link()
  end

  defp put_message_date(changeset) do
    case get_change(changeset, :message_date) do
      nil ->
        put_change(changeset, :message_date, DateTime.utc_now() |> DateTime.truncate(:second))

      _ ->
        changeset
    end
  end

  defp put_link(changeset) do
    case get_change(changeset, :link) do
      nil -> put_change(changeset, :link, SecureRandom.urlsafe_base64(16))
      _ -> changeset
    end
  end
end
