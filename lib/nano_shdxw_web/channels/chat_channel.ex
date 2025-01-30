defmodule NanoShdxwWeb.ChatChannel do
  use Phoenix.Channel
  alias NanoShdxw.Messaging

  def join("chat:" <> user_id, _params, socket) do
    {:ok, assign(socket, :user_id, user_id)}
  end

  def handle_in("new_message", %{"receiver_id" => receiver_id, "content" => content}, socket) do
    sender_id = socket.assigns.user_id

    case Messaging.create_message(%{sender_id: sender_id, receiver_id: receiver_id, content: content}) do
      {:ok, _messages} ->
        broadcast!(socket, "new_message", %{sender_id: sender_id, receiver_id: receiver_id, content: content})
        {:noreply, socket}

      {:error, _changeset} ->
        {:reply, {:error, %{reason: "Failed to send message"}}, socket}
    end
  end
end
