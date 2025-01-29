defmodule NanoShdxw.MessagingTest do
  use NanoShdxw.DataCase

  alias NanoShdxw.Messaging

  describe "messages" do
    alias NanoShdxw.Messaging.Message

    import NanoShdxw.MessagingFixtures

    @invalid_attrs %{content: nil}

    test "list_messages/0 returns all messages" do
      message = message_fixture()
      assert Messaging.list_messages() == [message]
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert Messaging.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      valid_attrs = %{content: "some content"}

      assert {:ok, %Message{} = message} = Messaging.create_message(valid_attrs)
      assert message.content == "some content"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messaging.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()
      update_attrs = %{content: "some updated content"}

      assert {:ok, %Message{} = message} = Messaging.update_message(message, update_attrs)
      assert message.content == "some updated content"
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      assert {:error, %Ecto.Changeset{}} = Messaging.update_message(message, @invalid_attrs)
      assert message == Messaging.get_message!(message.id)
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = Messaging.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Messaging.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = Messaging.change_message(message)
    end
  end

  describe "start_conversations" do
    alias NanoShdxw.Messaging.StartConversation

    import NanoShdxw.MessagingFixtures

    @invalid_attrs %{}

    test "list_start_conversations/0 returns all start_conversations" do
      start_conversation = start_conversation_fixture()
      assert Messaging.list_start_conversations() == [start_conversation]
    end

    test "get_start_conversation!/1 returns the start_conversation with given id" do
      start_conversation = start_conversation_fixture()
      assert Messaging.get_start_conversation!(start_conversation.id) == start_conversation
    end

    test "create_start_conversation/1 with valid data creates a start_conversation" do
      valid_attrs = %{}

      assert {:ok, %StartConversation{} = start_conversation} = Messaging.create_start_conversation(valid_attrs)
    end

    test "create_start_conversation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messaging.create_start_conversation(@invalid_attrs)
    end

    test "update_start_conversation/2 with valid data updates the start_conversation" do
      start_conversation = start_conversation_fixture()
      update_attrs = %{}

      assert {:ok, %StartConversation{} = start_conversation} = Messaging.update_start_conversation(start_conversation, update_attrs)
    end

    test "update_start_conversation/2 with invalid data returns error changeset" do
      start_conversation = start_conversation_fixture()
      assert {:error, %Ecto.Changeset{}} = Messaging.update_start_conversation(start_conversation, @invalid_attrs)
      assert start_conversation == Messaging.get_start_conversation!(start_conversation.id)
    end

    test "delete_start_conversation/1 deletes the start_conversation" do
      start_conversation = start_conversation_fixture()
      assert {:ok, %StartConversation{}} = Messaging.delete_start_conversation(start_conversation)
      assert_raise Ecto.NoResultsError, fn -> Messaging.get_start_conversation!(start_conversation.id) end
    end

    test "change_start_conversation/1 returns a start_conversation changeset" do
      start_conversation = start_conversation_fixture()
      assert %Ecto.Changeset{} = Messaging.change_start_conversation(start_conversation)
    end
  end
end
