defmodule Estim8Web.RoomLive do
  use Estim8Web, :live_view

  @emoji [
    "😺",
    "😸",
    "😹",
    "😻",
    "😼",
    "😽",
    "🙀",
    "😿",
    "😾",
    "🙈",
    "🙉",
    "🙊",
    "🐵",
    "🐒",
    "🦍",
    "🐶",
    "🐕",
    "🐩",
    "🐺",
    "🦊",
    "🦝",
    "🐱",
    "🐈",
    "🦁",
    "🐯",
    "🐅",
    "🐆",
    "🐴",
    "🐎",
    "🦄",
    "🦓",
    "🦌",
    "🐮",
    "🐂",
    "🐃",
    "🐄",
    "🐷",
    "🐖",
    "🐗",
    "🐽",
    "🐏",
    "🐑",
    "🐐",
    "🐪",
    "🐫",
    "🦙",
    "🦒",
    "🐘",
    "🦏",
    "🦛",
    "🐭",
    "🐁",
    "🐀",
    "🐹",
    "🐰",
    "🐇",
    "🐿",
    "🦔",
    "🦇",
    "🐻",
    "🐨",
    "🐼",
    "🦘",
    "🦡",
    "🐾",
    "🦃",
    "🐔",
    "🐓",
    "🐣",
    "🐤",
    "🐥",
    "🐦",
    "🐧",
    "🕊",
    "🦅",
    "🦆",
    "🦢",
    "🦉",
    "🦚",
    "🦜",
    "🐸",
    "🐊",
    "🐢",
    "🦎",
    "🐍",
    "🐲",
    "🐉",
    "🦕",
    "🦖",
    "🐳",
    "🐋",
    "🐬",
    "🐟",
    "🐠",
    "🐡",
    "🦈",
    "🐙",
    "🐚",
    "🦀",
    "🦞",
    "🦐",
    "🦑",
    "🐌",
    "🦋",
    "🐛",
    "🐜",
    "🐝",
    "🐞",
    "🦗",
    "🕷",
    "🕸",
    "🦂",
    "🦟",
    "🦠"
  ]

  defp topic(room_id), do: "room:#{room_id}"

  defp users(room_id) do
    Estim8Web.Presence.list(topic(room_id))
    |> Enum.map(fn {_, data} ->
      data[:metas] |> List.first()
    end)
  end

  def mount(%{"room" => room_id}, _, socket) do
    {:ok, assign(socket, room_id: room_id)}
  end

  def render(assigns) when not is_map_key(assigns, :user_id) do
    ~H"""
    <div class="w-screen min-h-screen bg-yellow-100 flex justify-center items-center p-4">
      <div class="max-w-[400px] w-full">
        <form phx-submit="join">
          <label class="block font-bold mb-2" for="name">Enter your name</label>
          <div class="flex">
            <input required class="block rounded-l-lg border-2 border-r-0 border-yellow-500 w-full" id="name" name="name" type="text" placeholder="Name" />
            <button class="rounded-r-lg bg-yellow-400 px-4 py-2 text-black font-bold">Submit</button>
          </div>
        </form>
      </div>
    </div>
    """
  end

  def render(assigns) do
    icons =
      Enum.filter(assigns.users, fn
        %{x: _, y: _, id: user_id, round_id: round_id} ->
          round_id == assigns.round_id and (user_id == assigns.user_id or assigns.reveal)

        _ ->
          false
      end)

    ~H"""
      <div class="w-screen min-h-screen bg-yellow-100 p-4">
        <div class="w-full max-w-2xl mx-auto">
          <p class="mb-4 text-xl font-bold">Round <%= @round_id %></p>
          <div phx-click={if not @reveal, do: "vote", else: ""} class="relative grid grid-cols-3 rounded-3xl border-4 border-slate-700 bg-slate-700 overflow-hidden gap-1">
            <div class="bg-white aspect-square grid place-content-center text-5xl font-bold">0</div>
            <div class="bg-white aspect-square grid place-content-center text-5xl font-bold">1</div>
            <div class="bg-white aspect-square grid place-content-center text-5xl font-bold">2</div>
            <div class="bg-white aspect-square grid place-content-center text-5xl font-bold">3</div>
            <div class="bg-white aspect-square grid place-content-center text-5xl font-bold">5</div>
            <div class="bg-white aspect-square grid place-content-center text-5xl font-bold">8</div>
            <div class="bg-white aspect-square grid place-content-center text-5xl font-bold">13</div>
            <div class="bg-white aspect-square grid place-content-center text-5xl font-bold">21</div>
            <div class="bg-white aspect-square grid place-content-center text-5xl font-bold">?</div>
            <%= for user <- icons do %>
              <div class="absolute translate-y-[-50%] translate-x-[-50%]" style={"top: #{user.y * 100}%; left: #{user.x * 100}%"}>
                <span class="text-4xl"><%= user.emoji %></span>
              </div>
            <% end %>
          </div>
          <%= if @leader do %>
            <div class="grid grid-cols-2 gap-2">
              <button phx-click="reveal" disabled={@reveal} class="px-4 py-2 mt-4 bg-yellow-400 rounded-lg text-black font-bold disabled:bg-yellow-200">Reveal votes</button>
              <button phx-click="hide" disabled={not @reveal} class="px-4 py-2 mt-4 bg-yellow-400 rounded-lg text-black font-bold disabled:bg-yellow-200">Hide votes</button>
            </div>
          <% end %>
          <div>
            <p class="mt-4 text-xl font-bold">Participants</p>
            <div class="flex gap-4 flex-wrap">
              <%= for user <- @users do %>
                <p class="text-lg"><span class="text-xl"><%= user.emoji %></span> <%= user.name %></p>
              <% end %>
            </div>
          </div>
        </div>
      </div>
    """
  end

  def handle_event("join", %{"name" => name}, socket) do
    room_id = socket.assigns.room_id
    topic = topic(room_id)

    Estim8Web.Endpoint.subscribe(topic)

    existing = users(room_id)

    leader = length(existing) == 0

    user_id = SecureRandom.uuid()

    user = %{id: user_id, emoji: Enum.random(@emoji), name: name}

    Estim8Web.Presence.track(self(), topic, user_id, user)

    users = users(room_id)

    game_state =
      case :ets.lookup(:estim8_game_states, room_id) do
        [{^room_id, state}] ->
          state

        _ ->
          state = %{round_id: 1, reveal: false}
          :ets.insert(:estim8_game_states, {room_id, state})
          state
      end

    {:noreply,
     assign(socket,
       user_id: user_id,
       users: users,
       leader: leader,
       reveal: game_state.reveal,
       round_id: game_state.round_id
     )}
  end

  def handle_event("vote", %{"x" => x, "y" => y}, socket) do
    Estim8Web.Presence.update(
      self(),
      topic(socket.assigns.room_id),
      socket.assigns.user_id,
      fn m ->
        m |> Map.put(:x, x) |> Map.put(:y, y) |> Map.put(:round_id, socket.assigns.round_id)
      end
    )

    {:noreply, socket}
  end

  def handle_event("reveal", _value, socket) do
    :ets.insert(
      :estim8_game_states,
      {socket.assigns.room_id, %{round_id: socket.assigns.round_id, reveal: true}}
    )

    Estim8Web.Endpoint.broadcast(topic(socket.assigns.room_id), "reveal", true)

    {:noreply, assign(socket, reveal: true)}
  end

  def handle_event("hide", _value, socket) do
    new_round = socket.assigns.round_id + 1

    :ets.insert(
      :estim8_game_states,
      {socket.assigns.room_id, %{round_id: new_round, reveal: false}}
    )

    Estim8Web.Endpoint.broadcast(topic(socket.assigns.room_id), "round", new_round)
    Estim8Web.Endpoint.broadcast(topic(socket.assigns.room_id), "reveal", false)

    {:noreply, assign(socket, reveal: false, round_id: socket.assigns.round_id + 1)}
  end

  def handle_info(%{event: "presence_diff", payload: _}, socket) do
    users = users(socket.assigns.room_id)

    {:noreply, assign(socket, users: users)}
  end

  def handle_info(%{event: "round", payload: round_id}, socket) do
    {:noreply, assign(socket, round_id: round_id)}
  end

  def handle_info(%{event: "reveal", payload: reveal}, socket) do
    {:noreply, assign(socket, reveal: reveal)}
  end
end
