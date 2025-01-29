defmodule NanoShdxw.Messaging do
  @moduledoc """
  The Messaging context.
  """

  import Ecto.Query, warn: false
  alias NanoShdxw.Repo

  alias NanoShdxw.Messaging.Message

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages do
    Repo.all(Message)
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(id), do: Repo.get!(Message, id)



  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  def get_conversation(sender_id, receiver_id) do
    query =
      from m in Message,
        where: (m.sender_id == ^sender_id and m.receiver_id == ^receiver_id) or
               (m.sender_id == ^receiver_id and m.receiver_id == ^sender_id),
        order_by: [asc: m.inserted_at]

    Repo.all(query)
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{data: %Message{}}

  """
  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end

  alias NanoShdxw.Messaging.StartConversation

  @doc """
  Returns the list of start_conversations.

  ## Examples

      iex> list_start_conversations()
      [%StartConversation{}, ...]

  """
  def list_start_conversations do
    Repo.all(StartConversation)
  end

  @doc """
  Gets a single start_conversation.

  Raises `Ecto.NoResultsError` if the Start conversation does not exist.

  ## Examples

      iex> get_start_conversation!(123)
      %StartConversation{}

      iex> get_start_conversation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_start_conversation!(id), do: Repo.get!(StartConversation, id)

  @doc """
  Creates a start_conversation.

  ## Examples

      iex> create_start_conversation(%{field: value})
      {:ok, %StartConversation{}}

      iex> create_start_conversation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_start_conversation(attrs \\ %{}) do
    %StartConversation{}
    |> StartConversation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a start_conversation.

  ## Examples

      iex> update_start_conversation(start_conversation, %{field: new_value})
      {:ok, %StartConversation{}}

      iex> update_start_conversation(start_conversation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_start_conversation(%StartConversation{} = start_conversation, attrs) do
    start_conversation
    |> StartConversation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a start_conversation.

  ## Examples

      iex> delete_start_conversation(start_conversation)
      {:ok, %StartConversation{}}

      iex> delete_start_conversation(start_conversation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_start_conversation(%StartConversation{} = start_conversation) do
    Repo.delete(start_conversation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking start_conversation changes.

  ## Examples

      iex> change_start_conversation(start_conversation)
      %Ecto.Changeset{data: %StartConversation{}}

  """
  def change_start_conversation(%StartConversation{} = start_conversation, attrs \\ %{}) do
    StartConversation.changeset(start_conversation, attrs)
  end
end
