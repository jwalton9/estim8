defmodule Estim8Web.HomeLive do
  use Estim8Web, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
      <div class="p-4 w-screen min-h-screen flex justify-center items-center bg-yellow-100">
        <div class="container flex flex-col gap-4 items-center">
          <h1 class="text-center text-5xl font-extrabold">Estim8</h1>
          <button phx-click="create" class="rounded-lg bg-yellow-400 px-4 py-2 font-bold">Create new room</button>
        </div>
      </div>
    """
  end

  def handle_event("create", _, socket) do
    id = SecureRandom.urlsafe_base64(6)

    {:noreply, socket |> redirect(to: "/room/#{id}")}
  end
end
