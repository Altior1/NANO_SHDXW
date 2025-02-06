defmodule NanoShdxw.Messaging do
  @moduledoc """
  The Messaging context.
  """

  import Ecto.Query, warn: false
  alias NanoShdxw.Repo

  alias NanoShdxw.Messaging.Message
  alias NanoShdxw.Accounts
  alias NanoShdxw.Accounts.User

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
  def get_messages_by_conversation_link(link) do
    Repo.all(from m in Message, where: m.link == ^link, order_by: [asc: m.message_date])
  end

  def get_conversation_by_link(link) do
    Repo.all(from m in Message, where: m.link == ^link)
  end

  def create_message(attrs) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  def create_conversation(attrs) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  def create_message_by_topic(attrs) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  def get_last_messages_per_receiver do
    subquery =
      from(m in Message,
        select: %{receiver_id: m.receiver_id, max_inserted_at: max(m.message_date)},
        group_by: m.receiver_id
      )

    query =
      from(m in Message,
        join: s in subquery(subquery),
        on: m.receiver_id == s.receiver_id and m.inserted_at == s.max_inserted_at,
        select: %{receiver_id: m.receiver_id, content: m.content, inserted_at: m.inserted_at}
      )

    Repo.all(query)
  end

  def get_last_messages_per_sender do
    Message
    # |> select([m], %{content: m.content, inserted_at: m.inserted_at, receiver_id: m.receiver_id})
    |> select([m], %{link: m.link})
    |> group_by([m], m.link)
    |> order_by([m], desc: m.inserted_at)
    |> limit(1)
    |> Repo.all()
  end

  def get_conversation(sender_id, receiver_id) do
    query =
      from m in Message,
        where:
          (m.sender_id == ^sender_id and m.receiver_id == ^receiver_id) or
            (m.sender_id == ^receiver_id and m.receiver_id == ^sender_id),
        order_by: [asc: m.inserted_at]

    Repo.all(query)
  end

  def get_last_message_by_topic_id(topic_id) do
    query =
      from m in Message,
        where: m.topic_id == ^topic_id,
        order_by: [desc: m.inserted_at],
        limit: 1,
        select: %{content: m.content, inserted_at: m.inserted_at, sender_id: m.sender_id, receiver_id: m.receiver_id}

    Repo.one(query)
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

  alias NanoShdxw.Messaging.Topic

  @doc """
  Returns the list of topic.

  ## Examples

      iex> list_topic()
      [%Topic{}, ...]

  """
  def list_topic do
    Repo.all(Topic)
  end

  @doc """
  Gets a single topic.

  Raises `Ecto.NoResultsError` if the Topic does not exist.

  ## Examples

      iex> get_topic!(123)
      %Topic{}

      iex> get_topic!(456)
      ** (Ecto.NoResultsError)

  """
  def get_topic!(id), do: Repo.get!(Topic, id)

  def get_topic_by_link!(link) do
    Repo.get_by!(Topic, link: link)
  end

  def get_messages_by_topic_id(topic_id) do
    topic_id |>IO.inspect(label: "lala")
    Repo.all(from m in Message, where: m.topic_id == ^topic_id, order_by: [asc: m.inserted_at])
  end

  @doc """
  Creates a topic.

  ## Examples

      iex> create_topic(%{field: value})
      {:ok, %Topic{}}

      iex> create_topic(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_topic(attrs \\ %{}) do
    users = Map.get(attrs, :user_ids, []) |> Accounts.get_users()

    %Topic{}
    |> Topic.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:users, users)
    |> Repo.insert()
  end

  @doc """
  Updates a topic.

  ## Examples

      iex> update_topic(topic, %{field: new_value})
      {:ok, %Topic{}}

      iex> update_topic(topic, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_topic(%Topic{} = topic, attrs) do
    topic
    |> Topic.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a topic.

  ## Examples

      iex> delete_topic(topic)
      {:ok, %Topic{}}

      iex> delete_topic(topic)
      {:error, %Ecto.Changeset{}}

  """
  def delete_topic(%Topic{} = topic) do
    Repo.delete(topic)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking topic changes.

  ## Examples

      iex> change_topic(topic)
      %Ecto.Changeset{data: %Topic{}}

  """
  def change_topic(%Topic{} = topic, attrs \\ %{}) do
    Topic.changeset(topic, attrs)
  end

  def associate_users_to_topic(topic, user_ids) do
    topic
    |> IO.inspect(label: "topic")


    %NanoShdxw.Messaging.Topic{}
    # |> Ecto.Changeset.change(topic)
    Topic.changeset(%Topic{}, topic)
    |> IO.inspect(label: "changeset 1 ")
    # |> Ecto.Changeset.put_assoc(:users, [Accounts.get_user_by_id(user_id)])
    |> Ecto.Changeset.put_assoc(:users, NanoShdxw.Accounts.list_users(user_ids))
    |> IO.inspect(label: "changeset 2")
    |> Repo.insert!()
    # |> Ecto.Changeset.put_assoc(:topics, topic)

    # Repo.transaction(fn ->
    #   for user_id <- user_ids do
    #     %NanoShdxw.Messaging.Topic{}
    #     |> Ecto.Changeset.change(topic)
    #     |> Ecto.Changeset.put_assoc(:users, Accounts.get_user_by_id(user_id))
    #     # |> Ecto.Changeset.put_assoc(:topics, topic)
    #     |> Repo.insert!()
    #   end
    # end)
  end

  def list_topics_for_current_user(user_id) do
    Repo.all(
      from t in Topic,
        join: ut in "users_topics",
        on: ut.topic_id == t.id,
        where: ut.user_id == ^user_id,
        select: t
    )
  end

  def get_users_by_topic_id(topic_id) do
    Repo.all(
      from ut in "users_topics",
        join: u in User,
        on: ut.user_id == u.id,
        where: ut.topic_id == ^topic_id,
        select: u
    )
  end
end
