defmodule NanoShdxwWeb.ConversationLive do
  use NanoShdxwWeb, :live_view
  alias NanoShdxw.Messaging
  alias NanoShdxw.Accounts

  @impl true
  def mount(%{"link" => link}, _session, socket) do
    topic = Messaging.get_topic_by_link!(link)
    messages = Messaging.get_messages_by_topic_id(topic.id) |> IO.inspect(label: "messages")
    # Récupérez les utilisateurs associés au Topic
    users = Messaging.get_users_by_topic_id(topic.id)
    current_user = socket.assigns.current_user
    # Déterminez le sender et le receiver
    {sender, receiver} =
      case users do
        [user1, user2] ->
          if user1.id == current_user.id do
            {user1, user2}
          else
            {user2, user1}
          end

        _ ->
          {nil, nil}
      end

    if connected?(socket) do
      Phoenix.PubSub.subscribe(NanoShdxw.PubSub, "conversation:#{link}")
    end

    {:ok,
     socket
     |> assign(:sender, sender)
     |> assign(:receiver, receiver)
     |> assign(:messages, messages)
     |> assign(:message_content, "")
     |> assign(:link, link)
     |> assign(:topic, topic)}
  end

  @impl true
  def handle_event("send_message", %{"content" => content}, socket) do
    sender_id = socket.assigns.sender.id
    receiver_id = socket.assigns.receiver.id
    link = socket.assigns.link
    topic_id = socket.assigns.topic.id
    topic_id |> IO.inspect(label: "topiiiiic")

    case Messaging.create_message(%{
           sender_id: sender_id,
           receiver_id: receiver_id,
           content: content,
           link: link,
           topic_id: topic_id
         }) do
      {:ok, message} ->
        Phoenix.PubSub.broadcast(
          NanoShdxw.PubSub,
          "conversation:#{link}",
          {:new_message, message}
        )

        {:noreply, assign(socket, :message_content, "")}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Failed to send message")}
    end
  end

  @impl true
  def handle_info({:new_message, message}, socket) do
    {:noreply, update(socket, :messages, fn messages -> messages ++ [message] end)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="messages">
      <%= for message <- @messages do %>
        <div class={"message #{if message.sender_id == @sender.id, do: "sent", else: "received"}"}>
          <p>{message.content}</p>
          <small>{message.message_date}</small>
        </div>
      <% end %>
    </div>
    <form phx-submit="send_message">
      <input
        type="text"
        name="content"
        value={@message_content}
        placeholder="Type your message..."
        required
      />
      <button type="submit">Send</button>
    </form>
    """
  end
end
