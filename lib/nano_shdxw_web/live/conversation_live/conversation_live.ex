defmodule NanoShdxwWeb.ConversationLive do
  use NanoShdxwWeb, :live_view
  alias NanoShdxw.Messaging
  alias NanoShdxw.Accounts.User

  @impl true
  def mount(%{"sender_id" => sender_id, "receiver_id" => receiver_id}, _session, socket) do
    sender = NanoShdxw.Repo.get!(User, sender_id)
    receiver = NanoShdxw.Repo.get!(User, receiver_id)

    if connected?(socket) do
      Phoenix.PubSub.subscribe(NanoShdxw.PubSub, "conversation:#{sender_id}:#{receiver_id}")
      Phoenix.PubSub.subscribe(NanoShdxw.PubSub, "conversation:#{receiver_id}:#{sender_id}")
    end

    {:ok,
     socket
     |> assign(:sender, sender)
     |> assign(:receiver, receiver)
     |> assign(:messages, Messaging.get_conversation(sender_id, receiver_id))
     |> assign(:message_content, "")}
  end

  @impl true
  def handle_event("send_message", %{"content" => content}, socket) do
    sender_id = socket.assigns.sender.id
    receiver_id = socket.assigns.receiver.id

    case Messaging.create_message(%{sender_id: sender_id, receiver_id: receiver_id, content: content}) do
      {:ok, message} ->
        Phoenix.PubSub.broadcast(
          NanoShdxw.PubSub,
          "conversation:#{sender_id}:#{receiver_id}",
          {:new_message, message}
        )
        {:noreply, assign(socket, :message_content, content)}

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
    <h2>Conversation entre {@sender.email} et {@receiver.email}</h2>
    <div class="messages">
      <%= for message <- @messages do %>
        <div class={"message #{if message.sender_id == @sender.id, do: "sent", else: "received"}"}>
          <p>{message.content}</p>
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

    <%!-- <.simple_form
      for={@form}
      id="messaging-form"
      phx-target={@myself}
      phx-submit="send_message"
    >
    <.input field={@form[:content]} type="text" label="Message" required />
    </.simple_form> --%>
    """
  end
end
