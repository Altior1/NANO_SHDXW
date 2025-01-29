defmodule NanoShdxw.MessagingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `NanoShdxw.Messaging` context.
  """

  @doc """
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        content: "some content"
      })
      |> NanoShdxw.Messaging.create_message()

    message
  end

  @doc """
  Generate a start_conversation.
  """
  def start_conversation_fixture(attrs \\ %{}) do
    {:ok, start_conversation} =
      attrs
      |> Enum.into(%{

      })
      |> NanoShdxw.Messaging.create_start_conversation()

    start_conversation
  end
end
